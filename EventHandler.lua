--    FILE: EventHandler.lua
--    DATE: 19-10-19
--  AUTHOR: Vitruvius
-- PURPOSE: Handle Events...
local addonName, TG = ...
local TOPGUN_Version = 1.5;
local TOPGUN_SubVersion = 1;

local prefix = "\124cFFFF0066[TopGun] \124cFFFFFFFF";

local TopGunEventFrame = CreateFrame("Frame",nil,UIParent); -- for events

--______________________________________________________________________________________________________

local Event_Handler = function(self,event,...)

   if (event == "ADDON_LOADED") and (... == addonName) then

      EventUtil.ContinueOnAddOnLoaded("Blizzard_UIPanels_Game",function()
         TG.taxiMapFrame = TaxiRouteMap or TaxiFrame
      end)

      -- check for saved data

      if not TOPGUN_FlightData then

         -- create the database

         TOPGUN_FlightData = {};

         TOPGUN_FlightData.Version = TOPGUN_Version;
         TOPGUN_FlightData.SubVersion = TOPGUN_SubVersion;

         TOPGUN_FlightData.TotalSpent = 0;
         TOPGUN_FlightData.TotalFlights = 0;
         TOPGUN_FlightData.TotalTime = 0;
         TOPGUN_FlightData.IsFlying = false;

         TOPGUN_FlightData.Flights = {};
         TOPGUN_FlightData.ZoneStats = {};

      else

         TOPGUN_FlightData.Version = TOPGUN_Version;
         TOPGUN_FlightData.SubVersion = TOPGUN_SubVersion;

      end -- NO TOPGUN_FlightData

      if not TOPGUN_GlobalData then

         TOPGUN_GlobalData = {};

         TOPGUN_GlobalData.Settings = {};

         TOPGUN_GlobalData.Settings.TimerWidth = 200;
         TOPGUN_GlobalData.Settings.TimerX = GetScreenWidth() / 2 - 100;
         TOPGUN_GlobalData.Settings.TimerY = GetScreenHeight() / 2 - 100;
         TOPGUN_GlobalData.Settings.TimerTexture = [[Interface\TargetingFrame\UI-StatusBar]]; -- default bar texture
         TOPGUN_GlobalData.Settings.TimerTextureName = "default";         
         TOPGUN_GlobalData.Settings.TimerColour = {r = 0,g = 1,b = 0,a = 1}; -- default bar colour (green)
         TOPGUN_GlobalData.Settings.TimerFont = 0;
         TOPGUN_GlobalData.Settings.TimerFontName = "default";
         TOPGUN_GlobalData.Settings.TimerFontColour = {r = 1,g = 1,b = 1,a = 1}; -- default font colour (white)

         TOPGUN_GlobalData.Settings.ShowFlightList = true;
         TOPGUN_GlobalData.Settings.ShowStats = true;
         TOPGUN_GlobalData.Settings.ShowPrevious = true;
         TOPGUN_GlobalData.Settings.ShowFlavour = true;
         TOPGUN_GlobalData.Settings.ShowTimer = true;
         TOPGUN_GlobalData.Settings.ShowLearningBar = true;

         TOPGUN_FlightData.Settings = nil; -- DELETE THE OLD SETTINGS

         -- get their flight data

         TOPGUN_GlobalData.FlightTimes = {};

         if TOPGUN_FlightData.FlightTimes then

            for k,v in pairs(TOPGUN_FlightData.FlightTimes) do

               TOPGUN_GlobalData.FlightTimes[k] = {};

               for l,b in pairs(v) do

                  TOPGUN_GlobalData.FlightTimes[k][l] = b;

               end -- l,b

            end -- k,v

         TOPGUN_FlightData.FlightTimes = nil; -- DELETE THE OLD WAY WE USED TO SAVE FLIGHT TIMES

         end -- existing flight times

      end -- UPDATE 

      -- everything loaded
      print(prefix .. "Welcome to TopGun v" .. TOPGUN_Version .. "." .. TOPGUN_SubVersion);
      print(prefix .. "Type /topgun or /tg to open");
      TopGunEventFrame:UnregisterEvent("ADDON_LOADED")
   end -- VARIABLES_LOADED

   --____________________________________________________________

   if (event == "TAXIMAP_OPENED") then

      -- close the standalone in case its open

      TOPGUN_StandaloneGUI:Hide();

      -- open the frames

      if (TOPGUN_GlobalData.Settings.ShowFlightList) then

         TOPGUN_FlightListGUI.SetToTaxi();

      end

      if (TOPGUN_GlobalData.Settings.ShowStats) then

         TOPGUN_StatFrameGUI.SetToTaxi();

      end

      if (TOPGUN_GlobalData.Settings.ShowPrevious) then

         TOPGUN_PreviousFlightGUI.SetToTaxi();

      end

      TOPGUN_SettingsGUI.SetToTaxi();

   end -- TAXIMAP_OPENED  

   --____________________________________________________________

   if (event == "TAXIMAP_CLOSED") then

      -- forcibly close the GUI

      TOPGUN_FlightListGUI:Hide();
      TOPGUN_StatFrameGUI:Hide();
      TOPGUN_PreviousFlightGUI:Hide();
      TOPGUN_SettingsGUI:Hide();

   end -- TAXIMAP_CLOSED 

   --____________________________________________________________

   if (event == "PLAYER_LOGOUT") then

      -- update saved variables

      _G["TOPGUN_FlightData"] = TOPGUN_FlightData;

   end -- PLAYER_LOGOUT

end -- Event_Handler()

--______________________________________________________________________________________________________

TopGunEventFrame:RegisterEvent("ADDON_LOADED")
TopGunEventFrame:RegisterEvent("TAXIMAP_OPENED");
TopGunEventFrame:RegisterEvent("TAXIMAP_CLOSED");
TopGunEventFrame:RegisterEvent("PLAYER_LOGOUT");

TopGunEventFrame:SetScript("OnEvent",Event_Handler)

--______________________________________________________________________________________________________