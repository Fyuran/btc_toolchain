#include "script_component.hpp"

class CfgPatches { 
	class ADDON {
		name = "=BTC= IFA - Pak40Base Fix";
		units[] = {};
		weapons[] = {};
		requiredAddons[] = {"cba_xeh", "WW2_Assets_c_Vehicles_StaticWeapons_c", "fow_cannons_c"};
		url = "https://www.blacktemplars.it/";
		author = "=BTC= Black Templars Clan";
        authors[] = {"=BTC= Fyuran"};
		requiredVersion = "0.1";
	};
}; 

class CfgVehicles {
 	class All;
	class AllVehicles: All {
		class ViewOptics;
		class NewTurret {
			class ViewGunner;
		};
	};
	class Land: AllVehicles{};
	class LandVehicle: Land {
		class ViewPilot;
		class CommanderOptics;
	};
    class StaticWeapon: LandVehicle {
		class NewTurret;
		class Turrets {
			class MainTurret;
			class CommanderOptics: CommanderOptics {};
			class ViewOptics: ViewOptics {};
		};
	};
	class StaticCannon: StaticWeapon {
		class Turrets: Turrets {
			class MainTurret;
		};
	};
};