#define CHAT 1
#define LOGS 2
#define ERROR 4
#define GLOBAL 8
/* ----------------------------------------------------------------------------
Function: btc_tools_fnc_debug

Description:
    Reports diagnostics information to rpt and user screen

Parameters:
    _message - [String]
    _mode - [Array]
    _file - [String]

Returns:

Examples:
    (begin example)
        [["Hello World"], 1] call btc_tools_fnc_debug;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params [
    ["_message", ["BTC Message debug"], [[""]]],
    ["_mode", 0, [123]]
];
if (mode <= 0) exitWith {
    [["invalid mode passed to btc_tools_fnc_debug: %1", _mode], 6] call btc_tools_fnc_debug;
};

private _useChat = [_mode, CHAT] call BIS_fnc_bitflagsCheck;
private _useLogs = [_mode, LOGS] call BIS_fnc_bitflagsCheck;
private _isError = [_mode, ERROR] call BIS_fnc_bitflagsCheck;
private _global = [_mode, GLOBAL] call BIS_fnc_bitflagsCheck;

if(!_isError) then {
    [format _message, "btc_debug", [_useChat, _useLogs, _global]] call CBA_fnc_debug;
} else { //it's an error message
    ["%1", format _message] remoteExecCall ["BIS_fnc_error", 0];
    [format _message, "btc_debug", [_useChat, _useLogs, _global]] call CBA_fnc_debug;
};
