local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Gryphons to DF Wyverns",
    description = "Change the action bar gryphons to Dragonflight wyverns.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    ShaguTweaks.dfwyverns = true
    for _, g in pairs({MainMenuBarLeftEndCap, MainMenuBarRightEndCap}) do
        g:SetTexture[[Interface\AddOns\ShaguTweaks-mods\img\df\wyvern]]  
    end
end