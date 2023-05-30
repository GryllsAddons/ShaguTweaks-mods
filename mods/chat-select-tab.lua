local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "General Tab on Login",
    description = "Selects the 'General' tab when logging in.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Social & Chat",
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
