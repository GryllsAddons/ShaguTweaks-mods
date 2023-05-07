local HookScript = ShaguTweaks.HookScript

local module = ShaguTweaks:register({
  title = "Improved Advanced Options",
  description = "Allows moving and scaling of the Advanced Options menu (drag to move, ctrl + mousewheel to scale).",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = nil,
  enabled = true,
})

module.enable = function(self)
  local function position()
    AdvancedSettingsGUI:SetScale(1)
    AdvancedSettingsGUI:ClearAllPoints()
    AdvancedSettingsGUI:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
  end

  if not this.hooked then
    this.hooked = true

    HookScript(AdvancedSettingsGUI, "OnShow", function()
      this:EnableMouseWheel(1)
      position()
    end)

    HookScript(AdvancedSettingsGUI, "OnMouseWheel", function()
      if IsControlKeyDown() then
        AdvancedSettingsGUI:SetScale(AdvancedSettingsGUI:GetScale() + arg1/10)
      end
    end)

    HookScript(AdvancedSettingsGUI, "OnMouseDown",function()
      AdvancedSettingsGUI:StartMoving()
    end)

    HookScript(AdvancedSettingsGUI, "OnMouseUp",function()
      AdvancedSettingsGUI:StopMovingOrSizing()
    end)
  end

  AdvancedSettingsGUI:SetMovable(true)
  AdvancedSettingsGUI:EnableMouse(true)
  position()  
end