local module = ShaguTweaks:register({
    title = "Max Camera Distance",
    description = "Increases the maximum zoom out distance of the camera.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    SlashCmdList["CONSOLE"]("cameraDistanceMax 50")
end