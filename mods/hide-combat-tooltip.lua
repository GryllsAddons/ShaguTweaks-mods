local module = ShaguTweaks:register({
  title = "Hide Combat Tooltip",
  description = "Hides the tooltip while in combat. While in combat, holding shift while mousing over a new target will show the tooltip.",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "Tooltip & Items",
  enabled = nil,
})

module.enable = function(self)    
    
    local combatFrame = CreateFrame("Frame", nil, UIParent)	
    combatFrame:RegisterEvent("PLAYER_REGEN_ENABLED") -- out of combat
    combatFrame:RegisterEvent("PLAYER_REGEN_DISABLED") -- in combat

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
            combatFrame:SetScript("OnUpdate", function()
                tooltipToggle(inCombat)
            end)
        else
            combatFrame:SetScript("OnUpdate", nil)
        end
    end

    combatFrame:SetScript("OnEvent", function()
        if event == "PLAYER_REGEN_DISABLED" then
            inCombat = true
            tooltipSetScript(inCombat)
        elseif event == "PLAYER_REGEN_ENABLED" then
            inCombat = false
            tooltipSetScript(inCombat)
        end
    end)

end
