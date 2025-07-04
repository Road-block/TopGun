--    FILE: StatFrameGUI.lua
--    DATE: 19-10-19
--  AUTHOR: Vitruvius
-- PURPOSE: Create Stat Frame GUI
local addonName, TG = ...

--______________________________________________________________________________________________________
local GetCoinTextureString = function(...)
   if _G.GetCoinTextureString then
      return _G.GetCoinTextureString(...)
   elseif C_CurrencyInfo and C_CurrencyInfo.GetCoinTextureString then
      return C_CurrencyInfo.GetCoinTextureString(...)
   end
end
--______________________________________________________________________________________________________

local function ReturnFormattedTime(time)

   local timeString = "";
   local hours = 0;
   local minutes = 0;
   local seconds = 0;

   if (time > 60) then

      if (time > 3600) then

         hours = floor(time / 3600);
         minutes = floor((time % 3600) / 60);
         seconds = floor(time % 60);

         timeString = hours .. "h " .. minutes .. "m " .. seconds .. "s";

      else

         minutes = floor(time / 60);
         seconds = floor(time % 60);

         timeString = minutes .. "m " .. seconds .. "s";

      end 

   else 

      seconds = floor(time);

      timeString = seconds .. "s";

   end

   return timeString;

end -- ReturnFormattedTime()

local function TOPGUN_CreateStatFrameGUI() 

   local frame = CreateFrame("Frame",nil,UIParent,"BasicFrameTemplateWithInset");

   -- register for scrolls
   frame:EnableMouse(true);

   -- dimensions
   frame:SetWidth(338);
   frame:SetHeight(150); -- correct height
   frame:SetPoint("CENTER",0,0);
   frame:SetFrameStrata("MEDIUM");

   -- heading
   frame.Heading = frame:CreateFontString(nil,nil,"GameFontNormalSmall");
   frame.Heading:SetPoint("TOP",frame,"TOP",0,-6);
   frame.Heading:SetText("General Statistics");

   -- total flights lbl
   frame.TotalFlightsLbl = frame:CreateFontString(nil,nil,"GameFontNormal");
   frame.TotalFlightsLbl:SetPoint("TOPLEFT",frame,"TOPLEFT",15,-35);
   frame.TotalFlightsLbl:SetText("Total Flights Taken: ");

   -- total flights txt
   frame.TotalFlightsTxt = frame:CreateFontString(nil,nil,"GameFontWhite");
   frame.TotalFlightsTxt:SetPoint("LEFT",frame.TotalFlightsLbl,"RIGHT",0,0);
   frame.TotalFlightsTxt:SetText("ERROR");

   -- total gold lbl
   frame.TotalGoldLbl = frame:CreateFontString(nil,nil,"GameFontNormal");
   frame.TotalGoldLbl:SetPoint("TOPLEFT",frame.TotalFlightsLbl,"TOPLEFT",0,-20);
   frame.TotalGoldLbl:SetText("Total Gold Spent: ");
   frame.TotalGoldLbl:SetJustifyH("LEFT");

   -- total gold txt
   frame.TotalGoldTxt = frame:CreateFontString(nil,nil,"GameFontWhite");
   frame.TotalGoldTxt:SetPoint("LEFT",frame.TotalGoldLbl,"RIGHT",0,0);
   frame.TotalGoldTxt:SetText(GetCoinTextureString(0));

   -- average gold lbl
   frame.AvgGoldLbl = frame:CreateFontString(nil,nil,"GameFontNormal");
   frame.AvgGoldLbl:SetPoint("TOPLEFT",frame.TotalGoldLbl,"TOPLEFT",0,-20);
   frame.AvgGoldLbl:SetText("Average Flight Cost: ");
   frame.AvgGoldLbl:SetJustifyH("LEFT");

   -- average gold txt
   frame.AvgGoldTxt = frame:CreateFontString(nil,nil,"GameFontWhite");
   frame.AvgGoldTxt:SetPoint("LEFT",frame.AvgGoldLbl,"RIGHT",0,0);
   frame.AvgGoldTxt:SetText(GetCoinTextureString(734));

   -- total time lbl
   frame.TotalTimeLbl = frame:CreateFontString(nil,nil,"GameFontNormal");
   frame.TotalTimeLbl:SetPoint("TOPLEFT",frame.AvgGoldLbl,"TOPLEFT",0,-20);
   frame.TotalTimeLbl:SetText("Total Flying Time: ");
   frame.TotalTimeLbl:SetJustifyH("LEFT");

   -- total time txt
   frame.TotalTimeTxt = frame:CreateFontString(nil,nil,"GameFontWhite");
   frame.TotalTimeTxt:SetPoint("LEFT",frame.TotalTimeLbl,"RIGHT",0,0);
   frame.TotalTimeTxt:SetText("ERROR");

   -- average time lbl
   frame.AvgTimeLbl = frame:CreateFontString(nil,nil,"GameFontNormal");
   frame.AvgTimeLbl:SetPoint("TOPLEFT",frame.TotalTimeLbl,"TOPLEFT",0,-20);
   frame.AvgTimeLbl:SetText("Average Flight Duration: ");
   frame.AvgTimeLbl:SetJustifyH("LEFT");

   -- average time txt
   frame.AvgTimeTxt = frame:CreateFontString(nil,nil,"GameFontWhite");
   frame.AvgTimeTxt:SetPoint("LEFT",frame.AvgTimeLbl,"RIGHT",0,0);
   --frame.AvgTimeTxt:SetText("3m 34s");

   -- last flight lbl
   frame.AvgTimeLbl = frame:CreateFontString(nil,nil,"GameFontNormal");
   frame.AvgTimeLbl:SetPoint("TOPLEFT",frame.TotalTimeLbl,"TOPLEFT",0,-20);
   frame.AvgTimeLbl:SetText("Average Flight Duration: ");
   frame.AvgTimeLbl:SetJustifyH("LEFT");

   -- total time txt
   frame.AvgTimeTxt = frame:CreateFontString(nil,nil,"GameFontWhite");
   frame.AvgTimeTxt:SetPoint("LEFT",frame.AvgTimeLbl,"RIGHT",0,0);
   frame.AvgTimeTxt:SetText("3m 34s");

   --______________________________________________________________

   frame.Toggle = function(self)
     if (frame:IsVisible()) then
       frame:Hide();
     else
       frame:Update(frame);
       frame:Show();
     end
   end

   --______________________________________________________________

   frame.SetToTaxi = function(self)

      -- show the flight list
      local anchor = TG.taxiMapFrame or TaxiFrame
      frame.Toggle();
      frame:ClearAllPoints();
      frame:SetPoint("TOPLEFT",anchor,"BOTTOMLEFT",-4,-2);-- 13,75);
      frame:SetPoint("TOPRIGHT",anchor,"BOTTOMRIGHT",4,-2);-- -35,75);

   end

   --______________________________________________________________

   frame.SetToStandalone = function(self)

      -- show the flight list

      frame.Toggle();
      frame:ClearAllPoints();
      frame:SetPoint("TOPLEFT",TOPGUN_StandaloneGUI,"BOTTOMLEFT",0,0);
      frame:SetPoint("TOPRIGHT",TOPGUN_StandaloneGUI,"BOTTOMRIGHT",0,0);

   end

   --______________________________________________________________

   frame:Hide();

   return frame;

end -- TOPGUN_CreateStatFrameGUI

--______________________________________________________________________________________________________

TOPGUN_StatFrameGUI = TOPGUN_CreateStatFrameGUI();

--______________________________________________________________________________________________________

TOPGUN_StatFrameGUI.Update = function (self)

   -- do averages calculation etc

   local averageCost;
   local averageDuration;
   -- check we're not dividing by zero, to prevent explosion
   if (TOPGUN_FlightData.TotalFlights > 0) then
      averageCost = TOPGUN_FlightData.TotalSpent / TOPGUN_FlightData.TotalFlights;
      averageDuration = floor(TOPGUN_FlightData.TotalTime / TOPGUN_FlightData.TotalFlights);
   else 
      averageCost = 0;
      averageDuration = 0;
   end

   -- update the stats!

   self.TotalFlightsTxt:SetText(TOPGUN_FlightData.TotalFlights);
   self.TotalGoldTxt:SetText(GetCoinTextureString(TOPGUN_FlightData.TotalSpent));
   self.AvgGoldTxt:SetText(GetCoinTextureString(averageCost));
   self.AvgTimeTxt:SetText(ReturnFormattedTime(averageDuration));
   self.TotalTimeTxt:SetText(ReturnFormattedTime(TOPGUN_FlightData.TotalTime));

end -- .Update

--______________________________________________________________________________________________________