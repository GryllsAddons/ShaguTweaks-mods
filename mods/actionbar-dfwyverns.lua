local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Gryphons to DF Wyverns"],
    description = T["Change the action bar gryphons to Dragonflight wyverns."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Action Bar"],
    enabled = nil,
})

module.enable = function(self)
    ShaguTweaks.dfwyverns = true
    for _, g in pairs({MainMenuBarLeftEndCap, MainMenuBarRightEndCap}) do
        g:SetTexture[[Interface\AddOns\ShaguTweaks-mods\img\df\wyvern]]  
    end
end