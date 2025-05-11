/* ----------------------------------------------------------------------------
Function: btc_snowstorm_fnc_init

Description:
    Initiates snowfall.

Parameters:

Returns:

Examples:
    (begin example)
	[] call btc_snowstorm_fnc_init;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "script_component.hpp"
#define TRANS_DELAY 10

if(!isServer) exitWith {};

params[
	["_duration", -1, [123]]
];
GVAR(duration) = -1;
GVAR(timedSnowstorm) = false;
if(_duration > 0) then { 
	GVAR(duration) = CBA_missionTime + GVAR(duration);
	GVAR(timedSnowstorm) = true;
};

if(!isNil QGVAR(handle)) then { //make sure the previous handler is removed
	[] remoteExecCall [QFUNC(terminate), 0];
};

//ace will overwrite any kind of weather settings passed
if(ACEGVAR(weather,windSimulation)) exitWith {
	private _msg = format["%1: snowfall could not be executed while ace is managing wind simulation", __FILE__];
	[_msg] remoteExecCall ["BIS_fnc_error", 0];
	diag_log _msg;
};

0 setRainbow 0;
0 setGusts 1;
0 setOvercast 1;
0 setRain 1;
0 setFog [0.5, 0.014, 0];
setWind[0, -1, true];
forceWeatherChange;

GVAR(windTrans) = [TRANS_DELAY, 40] spawn FUNC(windSmoothTrans);
GVAR(JIP_CSounds) = [] remoteExecCall [QFUNC(snowSounds_clients), [0, -2] select isDedicated, true]; //jip id removal is handled in terminate fnc

GVAR(handle) = [{
	[{
		0 setOvercast 1;
		0 setRain 1;
		private _randMag = random [10, 15, 20];
		private _fog = [linearConversion[0, 20, _randMag, 0.5, 1, true], 0.9] select (_randMag >= 15);	
		TRANS_DELAY setFog [_fog, 0, 0];
		#ifdef BTC_DEBUG
		hint format["fog val: %1", _fog];
		#endif
		[
			"a3\data_f\snowflake4_ca.paa", // texture of the particle (r = alpha; g = normalX; b = normalY; a = color;)
			4, // dropsInTexture - the number of drops that are present in the drop texture
			0.01, // minimum rain strength when the effect starts to be rendered
			_randMag, // distance of the effect
			1, // coefficient of how much the wind influences water drops
			_randMag, // fall speed of the drops
			0.5, // random part of the fall speed
			0.5, // coefficient of how much the drop could randomly change direction
			0.07, // width of the single drop
			0.07, // height of the single drop
			[1, 1, 1, 0.5], // color of the drop
			0.5, // luminescence of the drop facing to sun	
			0.5, // luminescence of the drop opposite to sun
			0.5, // coefficient that tells us how much "refracted" light from the scene is added to the drop color
			0.5, // coefficient to tune color saturation of the refraction effect (0=BW, 1=original color)
			true, // rain is snow, will be used in "snow" env sound controller (optional, default is false)
			false // when true, the dropColor is preserved and not affected by eye accommodation (optional, default is false)
		] call BIS_fnc_setRain;
		

		[_randMag] call FUNC(snowSounds);
		//[] remoteExecCall [QFUNC(snowDust), [0, -2] select isDedicated];

	}, [], random[3, 6, 10]] call CBA_fnc_waitAndExecute;

	if(GVAR(timedSnowstorm)) then {
		GVAR(duration) = GVAR(duration) - CBA_missionTime;
		if(GVAR(duration) <= 0) then {
			[] remoteExecCall [QFUNC(terminate), 0];
		};
	};

}, 11, []] call CBA_fnc_addPerFrameHandler;