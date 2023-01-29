local HookScript = ShaguTweaks.HookScript

local module = ShaguTweaks:register({
  title = "Improved Advanced Options",
  description = "Allows moving and scaling of the Advanced Options menu to fit the increased number of mods (CTRL + Mousewheel to scale).",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = nil,
  enabled = true,
})

module.enable = function(self)
  AdvancedSettingsGUI.iaotext = AdvancedSettingsGUI:CreateFontString(nil, "DIALOG", "GameFontHighlightSmall")
  AdvancedSettingsGUI.iaotext:SetText("(Drag to move, CTRL + Mousewheel to scale)")
  AdvancedSettingsGUI.iaotext:SetPoint("TOP", AdvancedSettingsGUITtitle, "BOTTOM", 0, 27)

  local function position()
    AdvancedSettingsGUI:SetScale(.88)
    AdvancedSettingsGUI:ClearAllPoints()
    AdvancedSettingsGUI:SetPoint("TOP", UIParent, "TOP", 0, -10)
    AdvancedSettingsGUI:SetFrameStrata("DIALOG")    
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