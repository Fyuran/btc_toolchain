
/* ----------------------------------------------------------------------------
Function: 
    btc_serverLogger_fnc_serverAddData

Description:
    Adds server data to global var holding clients data

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_serverLogger_fnc_serverAddData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_component.hpp"

GVAR(addData_EH) = [QGVAR(addData_EH), {

    private _uid = serverName;
    if(!isDedicated) then {_uid = getPlayerUID player}; //listen servers act as both host and server
    private _data = [
        "Server",
        _uid,
        diag_fps,
        viewDistance
    ];
    #ifdef DEBUG_MODE_FULL
        private _timestamp = [CBA_missionTime] call CBA_fnc_formatElapsedTime;
        [format["%1: server adding its data", _timestamp]] remoteExecCall ["systemChat", 0];
        diag_log format ["%1: server adding its data %2", __FILE__, _data];
    #endif

    [QGVAR(server_saveData_EH), _data] call CBA_fnc_serverEvent;

}] call CBA_fnc_addEventHandler;