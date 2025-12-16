/* #Vyqavo
$[
	1.063,
	["btc_dialog_box",[["(safeZoneX)","(safeZoneY + safeZoneH - (((safeZoneW / safeZoneH) min 1.2) / 1.2))","((safeZoneW / safeZoneH) min 1.2)","(((safeZoneW / safeZoneH) min 1.2) / 1.2)"],"(((safeZoneW / safeZoneH) min 1.2) / 40)","((((safeZoneW / safeZoneH) min 1.2) / 1.2) / 25)","GUI_GRID"],0,0,0],
	[1200,"",[1,"#(argb,8,8,3)color(1,1,1,1)",["0.340313 * safezoneW + safezoneX","0.032 * safezoneH + safezoneY","0.0433125 * safezoneW","0.077 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1801,"",[1,"INCOMING TRASMISSION",["0.340313 * safezoneW + safezoneX","0.01 * safezoneH + safezoneY","0.303187 * safezoneW","0.022 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]],
	[1000,"",[1,"INSERT TEXT HERE",["0.383625 * safezoneW + safezoneX","0.032 * safezoneH + safezoneY","0.259875 * safezoneW","0.077 * safezoneH"],[-1,-1,-1,-1],[-1,-1,-1,-1],[-1,-1,-1,-1],"","-1"],[]]
]
*/
#include "\a3\ui_f\hpp\definecommoncolors.inc"
#include "\a3\ui_f\hpp\defineResincl.inc"
#include "\a3\ui_f\hpp\definecommongrids.inc"

class RscPicture;
class RscFrame;
class RscTextMulti;

class RscTitles {
	class btc_dialog_RscDialogBox {
		idd = 6661;
		movingEnable = 1;
		fadeIn = "true";
		fadeOut = "true";
		duration = 1e+11;
		onload = "uiNamespace setVariable ['btc_dialog_RscDialogBox', _this select 0]";
		onunload = "";
		class ControlsBackground {
			class RscPicture_1200: RscPicture {
				idc = 1200;
				text = "";
				x = "0.340313 * safezoneW + safezoneX";
				y = "0.032 * safezoneH + safezoneY";
				w = "0.0433125 * safezoneW";
				h = "0.077 * safezoneH";
			};
			class RscFrame_1801: RscFrame {
				idc = 1801;
				text = "$STR_BTC_DIALOG_INCOMING_TRANS";
				x = "0.340313 * safezoneW + safezoneX";
				y = "0.01 * safezoneH + safezoneY";
				w = "0.303187 * safezoneW";
				h = "0.022 * safezoneH";
			};
			class RscText_1000: RscTextMulti {
				idc = 1000;
				text = "";
				sizeEx = 0.027;
				colorBackground[] = {0, 0, 0, 0.5};
				x = "0.383625 * safezoneW + safezoneX";
				y = "0.032 * safezoneH + safezoneY";
				w = "0.259875 * safezoneW";
				h = "0.077 * safezoneH";
			};
		};
	};
};
