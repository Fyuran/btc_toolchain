#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: btc_c4booby_fnc_deleteObject

Description:
    Passed object is stripped of its attached objects, timer is halted and conditions are evaluated

Parameters:
    _obj : Object

Returns:

Examples:
    (begin example)
        [this] call btc_c4booby_fnc_deleteObject;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

params[
	["_obj",objNull,[objNull]]
];
if(isNull _obj) exitWith {ERROR_MSG_1("btc_c4booby_fnc_deleteObject: bad params: %1",_this)};

private _handle = _obj getVariable ["c4booby_timer_handle", -1];
if(_handle != -1) then {
	[_handle] call CBA_fnc_removePerFrameHandler;
};
private _objs = attachedObjects _obj;
_objs apply {deleteVehicle _x};
