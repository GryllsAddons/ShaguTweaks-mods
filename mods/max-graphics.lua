local module = ShaguTweaks:register({
    title = "Max Graphics",
    description = "Tunes the game's graphics to the max!",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Graphics",
    enabled = nil,
})
  
module.enable = function(self)
    -- https://forum.nostalrius.org/viewtopic.php?t=1100
    SlashCmdList["CONSOLE"]("anisotropic 16")
    SlashCmdList["CONSOLE"]("baseMip 0")
    SlashCmdList["CONSOLE"]("detailDoodadAlpha 100")
    SlashCmdList["CONSOLE"]("DistCull 888") -- 888 / 500
    SlashCmdList["CONSOLE"]("doodadAnim 1")
    SlashCmdList["CONSOLE"]("farclip 777")
    SlashCmdList["CONSOLE"]("ffx 1")
    SlashCmdList["CONSOLE"]("ffxDeath 1")
    SlashCmdList["CONSOLE"]("ffxGlow 1")
    SlashCmdList["CONSOLE"]("ffxRectangle 1")
    SlashCmdList["CONSOLE"]("footstepBias 1.0") -- 1 / 0.125
    SlashCmdList["CONSOLE"]("frillDensity 256")
    SlashCmdList["CONSOLE"]("gxColorBits 24")
    SlashCmdList["CONSOLE"]("gxDepthBits 24")    
    SlashCmdList["CONSOLE"]("horizonfarclip 2112")
    SlashCmdList["CONSOLE"]("lod 0")
    SlashCmdList["CONSOLE"]("lodDist 250")
    SlashCmdList["CONSOLE"]("mapObjLightLOD 2")
    SlashCmdList["CONSOLE"]("mapObjOverbright 1")
    SlashCmdList["CONSOLE"]("mapShadows 1")
    SlashCmdList["CONSOLE"]("MaxLights 4")
    SlashCmdList["CONSOLE"]("maxLOD 3")
    SlashCmdList["CONSOLE"]("nearClip 0.33")
    SlashCmdList["CONSOLE"]("occlusion 1")
    SlashCmdList["CONSOLE"]("particleDensity 1")
    SlashCmdList["CONSOLE"]("pixelShaders 1")
    SlashCmdList["CONSOLE"]("shadowLevel 0")
    SlashCmdList["CONSOLE"]("showfootprints 1")
    SlashCmdList["CONSOLE"]("showLowDetail 0")
    SlashCmdList["CONSOLE"]("showShadow 1")
    SlashCmdList["CONSOLE"]("showSimpleDoodads 0")
    SlashCmdList["CONSOLE"]("SkyCloudLOD 1")
    SlashCmdList["CONSOLE"]("SkySunGlare 1")
    SlashCmdList["CONSOLE"]("SmallCull 0.01")
    SlashCmdList["CONSOLE"]("specular 1")
    SlashCmdList["CONSOLE"]("spellEffectLevel 2")
    SlashCmdList["CONSOLE"]("texLodBias -1")
    SlashCmdList["CONSOLE"]("textureLodDist 777")
    SlashCmdList["CONSOLE"]("trilinear 1")
    SlashCmdList["CONSOLE"]("unitDrawDist 1000") -- 1000 / 300
    SlashCmdList["CONSOLE"]("waterLOD 0")
    SlashCmdList["CONSOLE"]("waterParticulates 1")
    SlashCmdList["CONSOLE"]("waterRipples 1")
    SlashCmdList["CONSOLE"]("waterSpecular 1")
    SlashCmdList["CONSOLE"]("waterWaves 1")
    SlashCmdList["CONSOLE"]("weatherDensity 3")
    SlashCmdList["CONSOLE"]("gxMultisample 8") -- (1 is no anti-alising, 2 is 2x, 4 is 4x, 8 is 8x)
    SlashCmdList["CONSOLE"]("gxMultisampleQuality 1")
    SlashCmdList["CONSOLE"]("showCull")
end