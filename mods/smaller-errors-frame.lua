local module = ShaguTweaks:register({
  title = "Smaller Error Frame",
  description = "Resizes the error frame to 1 line instead of 3.",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  enabled = nil,
})

module.enable = function(self)
    UIErrorsFrame:SetHeight(UIErrorsFrame:GetHeight() / 3)
end