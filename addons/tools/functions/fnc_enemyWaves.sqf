#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: btc_tools_fnc_enemyWaves

Description:
    Handles AI units spawn with a set or random timer

Parameters:
    _pos - [Array]
    _side - [Side]
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
 ["_pos", [0,0,0], [[]], 3], 
 ["_side", east, [east]],
 ["_timeout", 60, [123]],
 ["_formation", "COLUMN", [""]],
 ["_waves", [], [[]]] 
]; 
 
if(_pos isEqualTo [0, 0, 0]) exitWith { 
 [["btc_tools_fnc_enemyWaves _pos is invalid"], 6] call FUNC(debug); 
}; 
if(_waves isEqualTo []) exitWith { 
 [["btc_tools_fnc_enemyWaves _waves is empty"], 6] call FUNC(debug); 
}; 
 
//Store the units somewhere to be later accessed 
if(isNil "btc_tools_enemyUnits") then { 
    btc_tools_enemyUnits = []; 
}; 

[_pos, _side, _timeout, _formation, _waves] spawn {
 params["_pos", "_side", "_timeout", "_formation", "_waves"]; 
 
	{ 
		private _time = CBA_missionTime + _timeout; 
		private _unitCount = count btc_tools_enemyUnits; 
		private _threshold = _unitCount - (floor(_unitCount * 0.75)); 
		 
		waitUntil { 
			sleep 5;
            #ifdef BTC_DEBUG
			[["time remaining: %1", _time - CBA_missionTime], 9] call FUNC(debug); 
			[["units remaining: %1 threshold: %2", count btc_tools_enemyUnits, _threshold], 9] call FUNC(debug);
            #endif  
			(CBA_missionTime > _time) ||   
			((count btc_tools_enemyUnits) <= _threshold) 
		}; 
 
		private _wave = _x;
        #ifdef BTC_DEBUG
		[["Spawning wave: %1", _forEachIndex + 1], 9] call FUNC(debug);
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
					private _unit = _grp createUnit [_class, [_pos, 1] call CBA_fnc_randPos, [], 0, "NONE"]; 
					btc_tools_enemyUnits pushBack _unit; 
 
					_unit addEventHandler["Killed", { 
						params ["_unit"]; 
						private _index = btc_tools_enemyUnits find _unit; 
						btc_tools_enemyUnits deleteAt _index; 
					}]; 
					_unit addEventHandler["Deleted", { 
						params ["_unit"]; 
						private _index = btc_tools_enemyUnits find _unit; 
						btc_tools_enemyUnits deleteAt _index; 
					}]; 
					sleep 0.5; 
				}; 
			};
            #ifndef BTC_DEBUG
			private _players = (allPlayers select {alive _x}) - entities "HeadlessClient_F";
            #else
			private _players = allGroups select {side _x == west};
            #endif
			private _playerLeaders = [];
			_players apply {_playerLeaders pushBackUnique leader _x;};
			_playerLeaders = [_playerLeaders, [_pos], {_x distance _input0}, "ASCEND"] call BIS_fnc_sortBy;
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
