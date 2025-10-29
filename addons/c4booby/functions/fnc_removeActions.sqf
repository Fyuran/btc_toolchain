#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: btc_c4booby_fnc_removeActions

Description:
    Helper function that removes actions from a single barrel and its phone

Parameters:


Returns:

Examples:
    (begin example)
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(!params[
	["_defuser",objNull,[objNull]]
]) exitWith{ERROR_MSG_1("btc_c4booby_fnc_removeActions: bad params: %1",_this)};

_actionIDS = _defuser getVariable ["c4booby_actionids",[]];
if(_actionIDS isEqualTo []) exitWith {ERROR_MSG_1(format["btc_c4booby_fnc_removeActions: bad actions ids: %1",_actionIDS])};
_actionIDS apply {[_defuser,0,_x] call ace_interact_menu_fnc_removeActionFromObject};

true
