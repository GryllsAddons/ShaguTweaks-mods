local module = ShaguTweaks:register({
  title = "Hide Combat Tooltip",
  description = "Hides the tooltip while in combat. While in combat, holding shift while mousing over a new target will show the tooltip.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Tooltip & Items",
  enabled = nil,
})

local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_REGEN_ENABLED") -- out of combat
    events:RegisterEvent("PLAYER_REGEN_DISABLED") -- in combat

local inCombat = false

local function tooltipToggle(inCombat)
    if inCombat then
        local modifierDown = IsShiftKeyDown() -- IsControlKeyDown() or IsAltKeyDown() can be used instead
        if modifierDown then            
            GameTooltip:Show()
        else
            GameTooltip:Hide()
        end
    else
        GameTooltip:Show()
    end
end

local function tooltipSetScript(inCombat)
    if inCombat then
        events:SetScript("OnUpdate", function()
            tooltipToggle(inCombat)
        end)
    else
        events:SetScript("OnUpdate", nil)
    end
end

module.enable = function(self)

    events:SetScript("OnEvent", function()
        if event == "PLAYER_REGEN_DISABLED" then
            inCombat = true            
        elseif event == "PLAYER_REGEN_ENABLED" then
            inCombat = false
        end
        tooltipSetScript(inCombat)
    end)

end
