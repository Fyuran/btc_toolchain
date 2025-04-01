
/* ----------------------------------------------------------------------------
Function: 
    btc_AIPaths_fnc_unhideObjects

Description:
    Unhides textures ingame

Parameters:
    _object -

Returns:

Examples:
    (begin example)
        call btc_AIPaths_fnc_unhideObjects;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "..\script_component.hpp"

if(!isServer) exitWith {
    remoteExecCall [QFUNC(unhideObjects), 2];
};
GVAR(objects) = missionNamespace getVariable [QGVAR(objects), []];
if(GVAR(objects) isEqualTo []) exitWith {
    ["no btc_AIPaths objects found"] remoteExecCall ["systemChat", remoteExecutedOwner];
};

private _cfg = configFile >> "CfgVehicles";
GVAR(objects) apply {
    private _object = _x;
    private _textures = getArray(_cfg >> typeOf _object >> "hiddenSelectionsTextures");
    {
        _object setObjectTextureGlobal [_forEachIndex, _x];
    } forEach _textures;
};

#ifdef DEBUG_MODE_FULL
    [format ["%1 objects are being shown", count GVAR(objects)]] remoteExecCall ["systemChat", remoteExecutedOwner];
#endif
