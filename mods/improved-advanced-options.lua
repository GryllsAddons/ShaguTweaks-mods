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
end