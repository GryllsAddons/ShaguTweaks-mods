local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Max Camera Distance"],
    description = T["Increases the maximum zoom out distance of the camera and makes zooming faster."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    SlashCmdList["CONSOLE"]("cameraDistanceMax 50")
    SlashCmdList["CONSOLE"]("cameraDistanceMaxFactor 5")
    SlashCmdList["CONSOLE"]("cameraDistanceMoveSpeed 50")
    SlashCmdList["CONSOLE"]("cameraDistanceSmoothSpeed 1")
end