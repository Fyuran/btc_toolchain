
/* ----------------------------------------------------------------------------
Function: 
    btc_serverLogger_fnc_clientsAddData

Description:
    Server manages client's sendData event setup on the client's network side, JIP compatible

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_serverLogger_fnc_clientsAddData;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_component.hpp"

GVAR(JIP_Clients_EH_ID) = [{  
    GVAR(addData_EH) = [QGVAR(addData_EH), { 

        private _data = [
            name player,
            getPlayerUID player,
            diag_fps, //average framerate calculated over last 16 frames.
            viewDistance   
        ];

        #ifdef DEBUG_MODE_FULL
            private _timestamp = [CBA_missionTime] call CBA_fnc_formatElapsedTime;
            systemChat format ["%1 client sending data", _timestamp];
            [format["%1: %2(%3) client sending data: %4", __FILE__, name player, getPlayerUID player, _data]] remoteExecCall["diag_log", [2, clientOwner]];
        #endif

        [QGVAR(server_saveData_EH), _data] call CBA_fnc_serverEvent;

    }] call CBA_fnc_addEventHandler;
}] remoteExecCall ["call", -2, true];