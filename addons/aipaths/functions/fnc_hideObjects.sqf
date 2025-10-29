#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: 
    btc_AIPaths_fnc_hideObjects

Description:
    Hides textures ingame

Parameters:
    _object -

Returns:

Examples:
    (begin example)
        call btc_AIPaths_fnc_hideObjects;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!isServer) exitWith {
    remoteExecCall [QFUNC(hideObjects), 2];
};
GVAR(objects) = missionNamespace getVariable [QGVAR(objects), []];
if(GVAR(objects) isEqualTo []) exitWith {
    ["no btc_AIPaths objects found"] remoteExecCall ["systemChat", remoteExecutedOwner];
};

GVAR(objects) apply {
    private _object = _x;
    private _textures = getObjectTextures _object;
    {
        _object setObjectTextureGlobal [_forEachIndex, ""];
    } forEach _textures;
};

#ifdef DEBUG_MODE_FULL
    [format ["%1 objects are being hidden", count GVAR(objects)]] remoteExecCall ["systemChat", remoteExecutedOwner];
#endif
