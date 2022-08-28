local _G = _G or getfenv(0)
local GetUnitData = ShaguTweaks.GetUnitData

local module = ShaguTweaks:register({
  title = "Nameplate Low Health",
  description = "Changes the nameplate health bar color when under 20% health.",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  enabled = nil,
})

module.enable = function(self)
  if ShaguPlates then return end

  table.insert(ShaguTweaks.libnameplate.OnUpdate, function()
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
        this.healthbar:SetStatusBarColor(0/255, 204/255, 255/255) -- Blizzard Blue
      end
    else
      this.healthbar:SetStatusBarColor(red, green, blue)
    end
  end)
end