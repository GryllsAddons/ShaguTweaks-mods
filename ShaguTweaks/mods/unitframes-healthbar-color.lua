local GetUnitData = ShaguTweaks.GetUnitData
local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
  title = "Unit Frame Healthbar Colors",
  description = "Changes the unitframe and nameplate healthbar color when at 20% health or lower.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)
  local function GetUnitType(red, green, blue)
    if red > .9 and green < .2 and blue < .2 then
      return "ENEMY_NPC"
    elseif red > .9 and green > .9 and blue < .2 then
      return "NEUTRAL_NPC"
    elseif red < .2 and green < .2 and blue > 0.9 then
      return "FRIENDLY_PLAYER"
    elseif red < .2 and green > .9 and blue < .2 then
      return "FRIENDLY_NPC"
    end
  end

  local function nameplates()
    if ShaguPlates then return end  
    table.insert(ShaguTweaks.libnameplate.OnUpdate, function()      
  
      local hp = this.healthbar:GetValue()
      local hpmin, hpmax = this.healthbar:GetMinMaxValues()
      local percent = hp / hpmax
      local name = this.name:GetText()
      local _, _, _, player = GetUnitData(name, true)
  
      local red, green, blue = this.healthbar:GetStatusBarColor()
      local unittype = GetUnitType(red, green, blue) or "ENEMY_NPC"
      if player and unittype == "ENEMY_NPC" then unittype = "ENEMY_PLAYER" end
      
      if percent <= 0.2 then
        if unittype == "ENEMY_NPC" or "ENEMY_PLAYER" or "NEUTRAL_NPC" then        
          this.healthbar:SetStatusBarColor(255/255, 128/255, 0/255) -- legendary orange
        elseif unittype == "FRIENDLY_NPC" or "FRIENDLY_PLAYER" then
          this.healthbar:SetStatusBarColor(0/255, 204/255, 255/255) -- Blizzard blue
        end
      else
        this.healthbar:SetStatusBarColor(red, green, blue)
      end
    end)
  end

  local function healthbar()
    hooksecurefunc("UnitFrameHealthBar_Update", function(statusbar, unit)
      if (not statusbar) or (not unit) or (not UnitExists(unit)) or UnitIsDeadOrGhost(unit) or (not UnitIsConnected(unit)) then return end
      local red, green, blue = statusbar:GetStatusBarColor()
      local unittype = GetUnitType(red, green, blue) or "ENEMY_NPC"
      if UnitIsPlayer(unit) and unittype == "ENEMY_NPC" then unittype = "ENEMY_PLAYER" end

      if UnitHealth(unit) / UnitHealthMax(unit) <= 0.2 then -- percent
          if unittype == "ENEMY_NPC" or "ENEMY_PLAYER" or "NEUTRAL_NPC" then
            statusbar:SetStatusBarColor(255/255, 128/255, 0/255) -- legendary orange
          elseif unittype == "FRIENDLY_NPC" or "FRIENDLY_PLAYER" then
            statusbar:SetStatusBarColor(0/255, 204/255, 255/255) -- Blizzard blue
          end
      else
        statusbar:SetStatusBarColor(red, green, blue)
      end
    end, true)
  end

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:SetScript("OnEvent", function()      
    nameplates()
    healthbar()
  end)
end
