local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Unit Frame Low Health"],
  description = T["Changes the unitframe healthbar color when at 20% health or lower."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["Unit Frames"],
  enabled = nil,
})

module.enable = function(self)  
  local _Player_SetStatusBarColor = PlayerFrameHealthBar.SetStatusBarColor
  local _Target_SetStatusBarColor = TargetFrameHealthBar.SetStatusBarColor
  local bighealth 

  local HookUnitFrameHealthBar_Update = UnitFrameHealthBar_Update
  function UnitFrameHealthBar_Update(sb, unit)
    HookUnitFrameHealthBar_Update(sb, unit)
    if (unit == sb.unit) then
      local hp = UnitHealth(unit)
      local hpmax = UnitHealthMax(unit)
      local percent = hp / hpmax

      if bighealth then
        if unit == "player" and PlayerFrameNameBackground then
          local r, g, b = PlayerFrameNameBackground:GetVertexColor()
          PlayerFrameHealthBar:SetStatusBarColor(r, g, b)
        elseif unit == "target" and TargetFrameNameBackground then
          local r, g, b = TargetFrameNameBackground:GetVertexColor()
          TargetFrameHealthBar:SetStatusBarColor(r, g, b)
        end
      end

      if percent <= 0.2 then
        sb:SetStatusBarColor(255/255, 128/255, 0/255)
      end

    end
  end

  local function restore()
    if TargetFrameHealthBar._SetStatusBarColor then
      bighealth = true
      -- unitframes-bighealth
      -- restore original functions
      PlayerFrameHealthBar.SetStatusBarColor = _Player_SetStatusBarColor
      TargetFrameHealthBar.SetStatusBarColor = _Target_SetStatusBarColor
    end
  end

  local timer = CreateFrame("Frame")
  timer:Hide()
  timer:SetScript("OnUpdate", function()
    if GetTime() >= timer.time then
      timer.time = nil
      restore()
      this:Hide()
      this:SetScript("OnUpdate", nil)
    end
  end)

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("PLAYER_TARGET_CHANGED")
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:SetScript("OnEvent", function()
    if event == "PLAYER_TARGET_CHANGED" then
      UnitFrameHealthBar_Update(TargetFrameHealthBar, "target")
    else
      timer.time = GetTime() + 1
      timer:Show()
    end
  end)
end