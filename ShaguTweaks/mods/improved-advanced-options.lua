local module = ShaguTweaks:register({
  title = "Improved Advanced Options",
  description = "Rescales the Advanced Options menu to fit the increased number of mods.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = nil,
  enabled = true,
})

module.enable = function(self)
  AdvancedSettingsGUI:SetPoint("TOP", UIParent, "TOP", 0, -10)
  AdvancedSettingsGUI:SetScale(0.88)
  AdvancedSettingsGUI:SetFrameStrata("DIALOG")

  -- local function hide()
  --   PlayerFrame:SetAlpha(0)
  --   TargetFrame:SetAlpha(0)
  --   PetActionBarFrame:Hide()
  --   MultiBarBottomRight:Hide()
  --   MultiBarBottomLeft:Hide()
  --   MultiBarRight:Hide()
  --   MultiBarLeft:Hide()
  --   MainMenuBar:Hide()
  -- end

  -- local function show()
  --   PlayerFrame:SetAlpha(1)
  --   TargetFrame:SetAlpha(1)
  --   PetActionBarFrame:Show()
  --   MultiBarBottomRight:Show()
  --   MultiBarBottomLeft:Show()
  --   MultiBarRight:Show()
  --   MultiBarLeft:Show()
  --   MainMenuBar:Show()
  -- end

  -- local f = CreateFrame("Frame", nil, AdvancedSettingsGUI)
  -- f:SetScript("OnShow", function()
  --   hide()
  -- end)

  -- f:SetScript("OnHide", function()
  --   show()
  -- end)
end