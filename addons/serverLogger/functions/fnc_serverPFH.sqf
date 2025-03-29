
/* ----------------------------------------------------------------------------
Function: 
    btc_serverLogger_fnc_serverPFH

Description:
    Manages the CBA PFH to perform a data send every 'btc_serverLogger_logging_cooldown' seconds

Parameters:

Returns:

Examples:
    (begin example)
        [] call btc_serverLogger_fnc_serverPFH;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_component.hpp"

params[
    ["_delay", GVAR(logging_cooldown), [0]]
];

//periodic EH trigger
GVAR(PFH) = [{
    params[
        ["_delay", GVAR(logging_cooldown), [0]]
    ];
    if(not GVAR(logging_isEnabled)) exitWith {};
    
    GVAR(logger_timestamp) = [CBA_missionTime] call CBA_fnc_formatElapsedTime;

    GVAR(logger_data) = createHashMap;
    #ifdef DEBUG_MODE_FULL
        [format["%1: clients should be sending data...(set delay: %2)", GVAR(logger_timestamp), _delay]] remoteExecCall ["systemChat", 0];
        diag_log format ["%1: clients should be sending data...(set delay: %2)", __FILE__, _delay];
        if(!isMultiplayer) then {[QGVAR(addData_EH)] call CBA_fnc_globalEvent;}; //trigger twice for testing
    #endif 
    [QGVAR(addData_EH)] call CBA_fnc_globalEvent;
    
}, _delay, _delay] call CBA_fnc_addPerFrameHandler;