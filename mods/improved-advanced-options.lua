local module = ShaguTweaks:register({
  title = "Improved Advanced Options",
  description = "Advanced Options menu tweaks.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = nil,
  enabled = true,
})

module.enable = function(self)
  AdvancedSettingsGUI:SetPoint("TOP", UIParent, "TOP", 0, -25)
  AdvancedSettingsGUI:SetScale(0.9)
  AdvancedSettingsGUI:SetFrameStrata("DIALOG")  
end