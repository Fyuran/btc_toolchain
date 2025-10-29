#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		name = "=BTC= Gear Weight Calculator";
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

#include "rsc.hpp"

class CfgVehicles {
	class Man;
	class CAManBase: Man {
		class ACE_SelfActions {
			class btc_ace_Actions {
				displayName = "BTC Menu";
				condition = "";
				exceptions[] = {};
				statement = "";
				priority = 2.1;
				icon = "\z\btc\addons\weight_calculator\data\btc_ace_actions_icon.paa";
				class GVAR(createDialog) {
					displayName = "Examine Gear Weight";
					condition = "true";
					exceptions[] = {};
					icon = "\z\btc\addons\weight_calculator\data\gwc_open.paa";
					statement = QUOTE([] call FUNC(createDialog));
				};
			};
		};
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

class Extended_PostInit_EventHandlers {
    class ADDON {
        init = QUOTE(call COMPILE_FILE(XEH_postInit));
    };
};
