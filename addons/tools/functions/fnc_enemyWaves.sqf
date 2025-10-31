#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: btc_tools_fnc_enemyWaves

Description:
    Handles AI units spawn with a set or random timer

Parameters:
    _obj - [Object]
    _side - [Side]
	_timeout - [Number]
	_format - [String]
    _waves - [Array]:
    [
        WaveN:
        [
            GrpN:
            [
                [Class1, Quantity1], [Class2, Quantity2]
            ]
        ]
    ]
Returns:

Examples:
    (begin example)
    [getPosASL waves_spawn, east, 120, [
        [
            [
                ["O_Soldier_A_F", 3],["O_soldierU_AT_F", 2]
            ]
        ],
        [
            [
                ["O_Soldier_A_F", 1],["O_soldierU_AT_F", 1]
            ]
        ]
    ]] call btc_tools_fnc_enemyWaves;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[ 
 ["_obj", objNull, [objNull]], 
 ["_side", east, [east]],
 ["_timeout", 60, [123]],
 ["_formation", "COLUMN", [""]],
 ["_waves", [], [[]]] 
]; 
 
if(isNull _obj) exitWith { 
 [["_obj is null"], 6] call FUNC(debug); 
}; 
if(_waves isEqualTo []) exitWith { 
 [["_waves is empty"], 6] call FUNC(debug); 
}; 
 

[_obj, _side, _timeout, _formation, _waves] spawn {
 params["_obj", "_side", "_timeout", "_formation", "_waves"]; 
 
	private _units = [];
	{ 
		private _time = CBA_missionTime + _timeout;
		private _threshold = (count _units) - (floor((count _units) * 0.75)); 
		 
		waitUntil { 
			sleep 5;
            #ifdef BTC_DEBUG
			[["%1 - time remaining: %2", _obj, _time - CBA_missionTime], 9] call FUNC(debug); 
			[["%1 - units remaining: %2 threshold: %3", _obj, count _units, _threshold], 9] call FUNC(debug);
            #endif  
			(CBA_missionTime > _time) ||   
			((count _units) <= _threshold) 
		}; 
 
		private _wave = _x;
        #ifdef BTC_DEBUG
		[["%1 - Spawning wave: %1", _obj, _forEachIndex + 1], 9] call FUNC(debug);
        #endif
		_wave apply {//wave 
			private _group = _x; 
			private _grp = createGroup[_side, true]; 
			_grp setVariable ["acex_headless_blacklist", true]; 
			 
			_group apply { 
				if(!(_x params [ //class-quantity array 
					["_class", "", [""]], 
					["_quantity", 0, [123]] 
				])) then { 
					[["btc_tools_fnc_enemyWaves: invalid _units array: %1", _x], 6] call FUNC(debug); 
					continue; 
				}; 
 
				if(!(isClass (configFile >> "CfgVehicles" >> _class))) then { 
					[["btc_tools_fnc_enemyWaves: %1 is not a valid class", _class], 6] call FUNC(debug); 
					continue; 
				}; 
 
				for "_j" from 1 to _quantity do { 
					private _unit = _grp createUnit [_class, [_obj, 1] call CBA_fnc_randPos, [], 0, "NONE"]; 
					_units pushBack _unit;
					_unit setVariable[QGVAR(wave_spawn), _obj]; 
 
					_unit addEventHandler["Killed", { 
						params ["_unit"];
						private _obj = _unit getVariable[QGVAR(wave_spawn), objNull];
						private _units = _obj getVariable[QGVAR(wave_units), []];
						private _index = _units find _unit; 
						_units deleteAt _index;
						#ifdef BTC_DEBUG
						[["Removing %1(%2) from %3", _unit, _obj, _units], 9] call FUNC(debug);
						#endif
						_obj setVariable[QGVAR(wave_units), _units];
					}]; 
					_unit addEventHandler["Deleted", { 
						params ["_unit"]; 
						private _obj = _unit getVariable[QGVAR(wave_spawn), objNull];
						private _units = _obj getVariable[QGVAR(wave_units), []];
						private _index = _units find _unit; 
						_units deleteAt _index;
						#ifdef BTC_DEBUG
						[["Removing %1(%2) from %3", _unit, _obj, _units], 9] call FUNC(debug);
						#endif
						_obj setVariable[QGVAR(wave_units), _units];
					}]; 
					sleep 0.5; 
				};

				_obj setVariable[QGVAR(wave_units), _units];
				#ifdef BTC_DEBUG
				[["%1 now holds %2 units", _obj, count _units], 9] call FUNC(debug);
				#endif
				 
			};
            #ifndef BTC_DEBUG
			private _players = (allPlayers select {alive _x}) - entities "HeadlessClient_F";
            #else
			private _players = allGroups select {side _x == west};
            #endif
			private _playerLeaders = [];
			_players apply {_playerLeaders pushBackUnique leader _x;};
			_playerLeaders = [_playerLeaders, [_obj], {_x distance _input0}, "ASCEND"] call BIS_fnc_sortBy;
			private _leader = _playerLeaders select 0;
			
            #ifdef BTC_DEBUG
			[["%1 heading for: %2", _grp, _leader], 9] call FUNC(debug);
            #endif
			private _wp = _grp addWaypoint [getPosASL _leader, -1];  
			_wp setWaypointBehaviour "AWARE"; 
			_wp setWaypointCombatMode "YELLOW"; 
			_wp setWaypointFormation _formation; 
			_wp setWaypointSpeed "FULL"; 
		}; 
 
	}forEach _waves; 
};
