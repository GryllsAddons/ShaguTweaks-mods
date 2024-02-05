local T = ShaguTweaks.T
local GetUnitData = ShaguTweaks.GetUnitData
local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
  title = T["Nameplate Low Health"],
  description = T["Changes the nameplate healthbar color when at 20% health or lower."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  enabled = nil,
})

module.enable = function(self)
  if ShaguPlates then return end

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

  table.insert(ShaguTweaks.libnameplate.OnUpdate, function()
    local hp = this.healthbar:GetValue()
    local _, hpmax = this.healthbar:GetMinMaxValues()
    local percent = hp / hpmax

    if percent <= 0.2 then
      local red, green, blue = this.healthbar:GetStatusBarColor()
      local unittype = GetUnitType(red, green, blue) or "ENEMY_NPC"

      if unittype == ("FRIENDLY_NPC" or "FRIENDLY_PLAYER") then
        this.healthbar:SetStatusBarColor(0/255, 204/255, 255/255)
      else
        this.healthbar:SetStatusBarColor(255/255, 128/255, 0/255)
      end
    end
  end)
end
