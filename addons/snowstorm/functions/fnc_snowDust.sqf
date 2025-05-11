/* ----------------------------------------------------------------------------
Function: btc_snowstorm_fnc_snowDust

Description:
    Spawns several particles simulating wind lifting snow

Parameters:

Returns:

Examples:
    (begin example)
	[] call btc_snowstorm_fnc_snowDust;
    (end)

Author:
    Fyuran

---------------------------------------------------------------------------- */
#include "script_component.hpp"
if(!hasInterface) exitWith {};

if(!isNil QGVAR(snowDust)) then { //do not allow more than one particle object
	deleteVehicle GVAR(snowDust);
};

private _curRain = rain;

// Adjust drop interval based on rain strength
private _dropInterval = linearConversion[0, 1, rain, 0.008, 0.09, true];
private _radius = [15, 40] select (!isNull objectParent player);

private _pos = (player modelToWorldWorld [0,0,0]) vectorAdd (wind vectorMultiply -1); //the stronger the wind the farther from the player

#ifdef BTC_DEBUG
Points1 pushBack [_pos#0, _pos#1, 1];
#endif

private _snowDust = "#particlesource" createVehicleLocal (ASLToAGL _pos);
GVAR(snowDust) = _snowDust;
_snowDust attachTo[player, [0,0,0]];

private _emissive = [[4,4,4,0]];
private _opacityFactor = 1;
if (((apertureParams select 0) < 9) && {currentVisionMode player == 0}) then {
	// Night
	_opacityFactor = 0.3 + (fog / 2);
	_emissive = [[0.5, 0.5, 0.5, 0]];
} else {
	// Day
	_opacityFactor = 0.3;
	_emissive = [[100, 100, 100, 0]];
};

_snowDust setParticleCircle [_radius, wind];

_snowDust setParticleRandom [
	0, //lt
	[15, 15, 0], //pos
	[0, 0, 0], //vel
	3, // rotvel
	0.1, // size
	[0,0,0,0], //col
	0,
	0
];

_snowDust setParticleParams [
	["\A3\data_f\cl_basic", 1, 0, 1], //["A3\Data_F\ParticleEffects\Universal\Universal", 16, 12, 8, 1],
	"",
	"Billboard",
	1, // timer per
	10, // lt
	[0, 0, 0], //pos
	[1, 0, -0.1], // vel
	3, // rot vel
	0.3, // weight
	0.232, //vol
	0.1, //rub
	[2, 10, 15], //size
	[[1,1,1, 0.001],[1,1,1, 0.01],[1,1,1, _opacityFactor], [1, 1, 1, _opacityFactor],[1, 1, 1, _opacityFactor/2],[1,1,1, 0.05],[1,1,1, 0.01],[1,1,1, 0]], //col
	[3], // anim speed
	1, // rand dir per
	0, // rnd dir intens
	"", // on timer script
	"", // before destroy script
	"", // obj
	0,  // angle
	true, // on surface
	-1, // bounceOnSurface
	_emissive // emissive col for daylight effect
];

_snowDust setDropInterval _dropInterval;