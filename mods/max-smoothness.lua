local module = ShaguTweaks:register({
    title = "Max Smoothness",
    description = "Optimise the game engine for smoother gameplay. Note that this will permanently add settings to the Config.wtf file.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Graphics",
    enabled = nil,
})
  
module.enable = function(self)
    -- https://forum.nostalrius.org/viewtopic.php?t=1100&f=32#
    SlashCmdList["CONSOLE"]("bspcache 1")
    SlashCmdList["CONSOLE"]("gxTripleBuffer 1")
    SlashCmdList["CONSOLE"]("M2UsePixelShaders 1")
    SlashCmdList["CONSOLE"]("M2UseZFill 1")
    SlashCmdList["CONSOLE"]("M2UseClipPlanes 1")
    SlashCmdList["CONSOLE"]("M2UseThreads 1")
    SlashCmdList["CONSOLE"]("M2UseShaders 1")
    SlashCmdList["CONSOLE"]("M2BatchDoodads 1")
end