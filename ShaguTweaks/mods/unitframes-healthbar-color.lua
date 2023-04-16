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
  if not ShaguPlates then
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

  local HookUnitFrameHealthBar_Update = UnitFrameHealthBar_Update
  function UnitFrameHealthBar_Update(sb, unit)
    HookUnitFrameHealthBar_Update(sb, unit)
    if (unit == sb.unit) then
      local hp = UnitHealth(unit)
      local hpmax = UnitHealthMax(unit)
      local percent = hp / hpmax

      if percent <= 0.2 then
        if UnitCanAssist("player", unit) then
          sb:SetStatusBarColor(0/255, 204/255, 255/255)
        else
          sb:SetStatusBarColor(255/255, 128/255, 0/255)
        end
      end
    end
  end
end
