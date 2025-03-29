
/* ----------------------------------------------------------------------------
Function: 
    btc_serverLogger_fnc_serverSaveData

Description:
    Server manages receiving data

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_serverLogger_fnc_serverSaveData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_component.hpp"

GVAR(server_saveData_EH) = [QGVAR(server_saveData_EH), { 
    params [
        ["_name", "", [""]],
        ["_uid", "", [""]],
        ["_fps", -1, [0]],
        ["_viewDistance", -1, [0]]
    ];
    _fps = round _fps;
    _viewDistance = round _viewDistance;

    private _data = GVAR(logger_data) getOrDefault [GVAR(logger_timestamp), []];
    
    //_name = _name regexReplace[",", "."]; //replace commas with dots as commas are used as separator in extension
    // if((_name select [0]) isEqualTo "=") then {
    //     _name = _name insert [0, "'"] //add a single quote to escape equal sign = in .csv files
    // };
    //_name = format["%1 (VD:%2)", _name, _viewDistance];

    _data pushBack [
        _name,
        _uid,
        _fps,
        _viewDistance
    ];

    #ifdef DEBUG_MODE_FULL
        [format["%1: server saving data", GVAR(logger_timestamp)]] remoteExecCall ["systemChat", 0];
        diag_log format ["%1: server saving data: %2", __FILE__, _this];
    #endif

    GVAR(logger_data) set [GVAR(logger_timestamp), _data];

    private _allPlayersCount = count allPlayers;
    if(isDedicated) then { //add 1 to count of _allPlayers as server data is being added, unecessary on listen servers
        _allPlayersCount = _allPlayersCount + 1;
    };

    private _dataCount = count (GVAR(logger_data) get GVAR(logger_timestamp));
    #ifdef DEBUG_MODE_FULL
        [format["%1: dataCount: %2 playersCount: %3", GVAR(logger_timestamp), _dataCount, _allPlayersCount]] remoteExecCall ["systemChat", 0];
        diag_log format["%1: dataCount: %2 playersCount: %3", __FILE__, _dataCount, _allPlayersCount];
    #endif
    if(_dataCount >= _allPlayersCount) then {
        private _extArr = ["manageSession", [missionName, worldName, count entities "CAManBase", count agents]];
        GVAR(logger_data) apply { //compose array with separated arguments to send to extension
            _y apply {
                (_extArr#1) pushBack _x;
            };
        };

        #ifdef DEBUG_MODE_FULL
            diag_log format ["%1: sending extension array is: %2", __FILE__, _extArr];
        #endif

        if(count _extArr < 2) exitWith {};//do not call extension if no useful data is present

        diag_log format ["%1: extension called", __FILE__, _extArr];
        private _return = str ("btc_serverLogger" callExtension _extArr);

        #ifdef DEBUG_MODE_FULL
            diag_log format ["%1: extension return: %2", __FILE__, _return];
        #endif
    };
}] call CBA_fnc_addEventHandler;