#include "script_component.hpp"
class CfgPatches {
	class ADDON {
		name = "=BTC= Toolchain functions";
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
