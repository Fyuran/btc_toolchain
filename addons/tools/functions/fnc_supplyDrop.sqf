
/* ----------------------------------------------------------------------------
Function: btc_tools_fnc_supplyDrop

Description:
    Apply chemical damage.

Parameters:
    _veh - Air unit to which spawn supplies from. [Object]
    _paradropClasses - Array of CfgVehicles string classes. [Array]
	_inventoryClasses - Array of items string classes. [Array]

Returns:

Examples:
    (begin example)
	[ 
		plane,  
		[
			"Box_East_WpsSpecial_F", 
			"ACE_medicalSupplyCrate_advanced", 
			"rhs_mags_crate", 
			"Box_NATO_AmmoOrd_F", 
			"rhsusf_m1a1fep_d", 
			"rhsusf_m1025_d_s_m2"
		],  
		[
			[
				["arifle_MX_F", 1], ["30Rnd_65x39_caseless_mag", 4], ["rhsusf_weap_MP7A2", 2], ["rhsusf_mag_40Rnd_46x30_FMJ", 3]
			],
			[],
			[],
			[],
			[
				["arifle_MX_GL_F", 2], ["rhs_mag_M441_HE", 10], ["30Rnd_65x39_caseless_mag", 10]
			],
			[]
		] 
	] call btc_tools_fnc_supplyDrop;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "script_component.hpp"

params[
	["_veh", objNull, [objNull]],
	["_paradropClasses", [], [[""]]],
	["_inventoryClasses", [], [[]]]
];

if (isNull _veh) exitWith {
	#ifdef BTC_DEBUG
	["passed a null _veh object"] call BIS_fnc_error;
	#endif
};
private _posATL = getPosATL _veh;		
if (surfaceIsWater _posATL) exitWith {
	#ifdef BTC_DEBUG
	["attempting to supply over water: %1", _posATL] call BIS_fnc_error;
	#endif 
};

[_veh, _paradropClasses, _inventoryClasses] spawn {
	params[
		["_veh", objNull, [objNull]],
		["_paradropClasses", objNull, [[""]]],
		["_inventoryClasses", [], [[]]]
	];
	
	{
		 //if object is a class create a vehicle else null check
		if(!isClass (configFile >> "CfgVehicles" >> _x)) then {
			#ifdef BTC_DEBUG
			["invalid class: %1", _x] call BIS_fnc_error; 
			#endif
		   continue; 
		};
		private _vehPosATL = getPosATL _veh;
		
		if((_vehPosATL#2) < 15) then {
			#ifdef BTC_DEBUG
			["flight path too low, must be above 15m, currently: %1", _vehPosATL#2] call BIS_fnc_error; 
			#endif
			continue;
		};
		
		private _dropVelocity = (velocity _veh) vectorMultiply 0.9;
		private _calculatedDropPos = _vehPosATL vectorAdd ((vectorDir _veh) vectorMultiply -5);
		_calculatedDropPos = _calculatedDropPos vectorDiff [0, 0, 1];
		private _supply = createVehicle[_x, [0, 0, 100], [], 0, "CAN_COLLIDE"];  
		_supply setPosATL _calculatedDropPos;

		//parachute must not be spawned as "FLY" as it will spawn 150 m above ground
		private _para = createVehicle ["I_Parachute_02_F", (getPosATL _supply) vectorAdd [0, 0, 1], [], 0, "CAN_COLLIDE"];
		_para setVehicleLock "LOCKED"; //prevent stupid shit from happening
		_supply attachTo [_para, [0,0,0]]; 
		_para setVelocity _dropVelocity;
		
		sleep 0.5;

		//inventory parsing
		private _inventory = _inventoryClasses param[_forEachIndex, ["", 1]];
		if(_inventory isNotEqualTo []) then {
			clearMagazineCargoGlobal _supply;
			clearWeaponCargoGlobal _supply;
			clearBackpackCargoGlobal _supply;
			clearItemCargoGlobal _supply; //also removes vests and uniforms
			
			private _backpackBase = configFile >> "CfgVehicles" >> "Bag_Base";
			_inventory apply {
				_x params[
					["_class", "", [""]],
					["_count", 1, [123]]
				];
				if(
					(!isClass (configFile >> "CfgVehicles" >> _class)) &&
					{(!isClass (configFile >> "CfgWeapons" >> _class))} && 
					{(!isClass (configFile >> "CfgAmmo" >> _class))} &&
					{(!isClass (configFile >> "CfgMagazines" >> _class))}
				) then {
					#ifdef BTC_DEBUG
					["invalid class: %1", _class] call BIS_fnc_error; 
					#endif
					continue;
				};
				
				if !([_supply, _class] call CBA_fnc_canAddItem) then {
					#ifdef BTC_DEBUG
					["no inventory room for: %1", _class] call BIS_fnc_error; 
					#endif
					continue;
				};
				
				private _probableBackpack = configFile >> "CfgVehicles" >> _class;
				private _inheritsFromBackpackbase = [_probableBackpack, _backpackBase] call CBA_fnc_inheritsFrom;
				 if(_inheritsFromBackpackbase) then {
					_supply addBackpackCargoGlobal[_class, _count];												 
				 } else {
					_supply addItemCargoGlobal[_class, _count]; //Works with items, weapons, magazines, equipment and glasses but not backpacks.
				 };			 
			};		
		}; 

		//ground landing smoke and detach from parachute to avoid ground clipping						
		[
		{
			(getPos(_this#0)#2) <= 1
		},
		{
			params[
				["_supply", objNull, [objNull]]
			];
			detach _supply;
			private _posATL = getPosATL _supply;
			private _smoke = "SmokeShellGreen" createVehicle _posATL;
			_smoke attachTo [_supply, [0,0,0]]; 
		},
		[_supply]
		] call CBA_fnc_waitUntilAndExecute		
	} forEach _paradropClasses;
};

#ifdef BTC_DEBUG
hint "Spawning supplies...";
diag_log format["%1 spawning supplies", __FILE__];
#endif

