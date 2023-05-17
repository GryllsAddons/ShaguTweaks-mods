local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Gryphons to Lions",
    description = "Change the action bar gryphons to lions",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    for _, g in pairs({MainMenuBarLeftEndCap, MainMenuBarRightEndCap}) do
    g:SetTexture[[Interface\MainMenuBar\UI-MainMenuBar-EndCap-Human]]  
    end
end
