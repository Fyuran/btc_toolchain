#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		name = "=BTC= Snowstorm";
		author = "=BTC= Black Templars Clan";
        authors[] = {"=BTC=Fyuran"};
		units[] = {};
		url = "http://www.blacktemplars.it";
		requiredVersion = REQUIRED_VERSION;
		weapons[] = {};
		requiredAddons[] = {"btc_main"};
		VERSION_CONFIG;
	};
};

class CfgSounds {
	class GVAR(wind_transition) {
		name = QGVAR(wind_transition);
		sound[] = {QPATHTOF(sounds\wind_transition.ogg), 5,1};
		titles[] = {};
	};
	class GVAR(indoor_h_windLoop) {
		name = QGVAR(indoor_h_windLoop);
		sound[] = {QPATHTOF(sounds\indoor_h_windLoop.ogg), 1,1};
		titles[] = {};
	};
	class GVAR(h_windLoop) {
		name = QGVAR(h_windLoop);
		sound[] = {QPATHTOF(sounds\h_windLoop.ogg), 1,1};
		titles[] = {};
	};
	class GVAR(indoor_h_windLoop_2) {
		name = QGVAR(indoor_h_windLoop_2);
		sound[] = {QPATHTOF(sounds\indoor_h_windLoop_2.ogg), 1,1};
		titles[] = {};
	};
	class GVAR(h_windLoop_2) {
		name = QGVAR(h_windLoop_2);
		sound[] = {QPATHTOF(sounds\h_windLoop_2.ogg), 1,1};
		titles[] = {};
	};
	class GVAR(wolf1) {
		name = QGVAR(wolf1);
		sound[] = {QPATHTOF(sounds\Wolf1.ogg), 1,1};
		titles[] = {};
	};
	class GVAR(wolf2) {
		name = QGVAR(wolf2);
		sound[] = {QPATHTOF(sounds\Wolf2.ogg), 1,1};
		titles[] = {};
	};
};

class Extended_PreStart_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preStart));
    };
};

class Extended_PreInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_preInit));
    };
};
