#include "script_component.hpp"
/* ----------------------------------------------------------------------------
Function: btc_snowstorm_fnc_terminate

Description:
    Stops snowfall

Parameters:

Returns:

Examples:
    (begin example)
	[] call btc_snowstorm_fnc_terminate;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */

if(isServer) then {
    if(!isNil QGVAR(JIP_CSounds)) then { //client sounds handler
        remoteExecCall ["", GVAR(JIP_CSounds)];
    };

    if(!isNil QGVAR(handle)) then { //make sure the previous handler is removed
        [GVAR(handle)] call CBA_fnc_removePerFrameHandler;
    };

    if(!isNil QGVAR(windTrans)) then { //should wind transition not be done just end it
        terminate GVAR(windTrans); 
    };

	0 setOvercast 0;
	0 setRain 0;
	0 setFog 0;
    0 setGusts 0;
    setWind [0, 0, true];
    forceWeatherChange;

    GVAR(timedSnowstorm) = false;
};

if(!isNil QGVAR(snowDust)) then { //do not allow more than one particle object
	deleteVehicle GVAR(snowDust);
};

if(GVAR(windSoundID) != -1) then {
    stopSound GVAR(windSoundID);
    GVAR(windSoundID) = -1;
};

if(!isNil QGVAR(indoor_handle)) then {
    [GVAR(indoor_handle)] call CBA_fnc_removePerFrameHandler;
    GVAR(indoor_handle) = nil; //reset to allow execution of client side function again
};

if(!isNil QGVAR(sound_loop_handle)) then { //sound loop
    [GVAR(sound_loop_handle)] call CBA_fnc_removePerFrameHandler;
    GVAR(sound_loop_handle) = nil;
};
