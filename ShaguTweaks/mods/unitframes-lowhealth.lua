local GetUnitData = ShaguTweaks.GetUnitData
local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
  title = "Unit Frame Low Health",
  description = "Changes the unitframe healthbar color when at 20% health or lower.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)
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
