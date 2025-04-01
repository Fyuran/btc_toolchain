#include "script_macros.hpp"
#define true 1
#define false 0

class CfgPatches {
    class ADDON {
        name = "=BTC= Toolchain main";
        units[] = {};
        weapons[] = {};
        requiredVersion = 0.1;
        requiredAddons[] = {"cba_main", "ace_medical_feedback", "ace_interaction"};
        author = "=BTC= Black Templars Clan";
        authors[] = {"=BTC=Fyuran"};
        url = "https://www.blacktemplars.it/";
        VERSION_CONFIG;
    };
};

class CfgMods {
    class PREFIX {
        dir = "@btc_toolchain";
        name = "=BTC= Toolchain";
        picture = "A3\Ui_f\data\Logos\arma3_expansion_alpha_ca.paa";
        hidePicture = true;
        hideName = true;
        actionName = "Website";
        action = "https://www.blacktemplars.it/";
        description = "Issue Tracker = https://github.com/Fyuran/btc/issues";
    };
};
