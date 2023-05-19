local module = ShaguTweaks:register({
  title = "Unit Frame Low Health",
  description = "Changes the unitframe healthbar color when at 20% health or lower.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)  
  -- Big Health Support
  local _TargetFrame_CheckFaction = TargetFrame_CheckFaction  
  local _Player_SetStatusBarColor = PlayerFrameHealthBar.SetStatusBarColor
  local _Target_SetStatusBarColor = TargetFrameHealthBar.SetStatusBarColor

  -- player
  if PlayerFrameNameBackground then
    local pr, pg, pb, pa = PlayerFrameNameBackground:GetVertexColor()
  end
  -- target
  local tr, tg, tb, ta = TargetFrameNameBackground:GetVertexColor()

  local HookUnitFrameHealthBar_Update = UnitFrameHealthBar_Update
  function UnitFrameHealthBar_Update(sb, unit)
    HookUnitFrameHealthBar_Update(sb, unit)
    if (unit == sb.unit) then
      local hp = UnitHealth(unit)
      local hpmax = UnitHealthMax(unit)
      local percent = hp / hpmax

      if percent <= 0.2 then
          sb:SetStatusBarColor(255/255, 128/255, 0/255)
      end
    end
  end

  local function restore()
    TargetFrame_CheckFaction = _TargetFrame_CheckFaction
    -- player
    PlayerFrameHealthBar.SetStatusBarColor = _Player_SetStatusBarColor
    if PlayerFrameNameBackground then
      PlayerFrameHealthBar:SetStatusBarColor(pr, pg, pb, pa)
    end
    -- target
    TargetFrameHealthBar.SetStatusBarColor = _Target_SetStatusBarColor
    TargetFrameHealthBar:SetStatusBarColor(tr, tg, tb, ta)
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

  local wait = CreateFrame("Frame")
  wait:RegisterEvent("PLAYER_ENTERING_WORLD")
  wait:SetScript("OnEvent", function()
    timer.time = GetTime() + 1
    timer:Show()
  end)
end
