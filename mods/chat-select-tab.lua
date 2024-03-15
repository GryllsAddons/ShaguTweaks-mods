local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["General Tab on Login"],
    description = T["Selects the 'General' tab when logging in."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Social & Chat"],
    enabled = nil,
})

module.enable = function(self)
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            FCF_SelectDockFrame(ChatFrame1)
        end
    end)
end
