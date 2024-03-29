local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Hide Combat Tooltip"],
  description = T["Hides the tooltip while in combat. While in combat, holding shift will show the tooltip."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["Tooltip & Items"],
  enabled = nil,
})

module.enable = function(self)
    local combatTooltip = CreateFrame("Frame", nil, UIParent)
    local inCombat = false

    local function ShowTooltip()
        GameTooltip:SetAlpha(1)
    end

    local function HideTooltip()
        GameTooltip:SetAlpha(0)
    end

    local function tooltipToggle(inCombat)
        if inCombat then
            local modifierDown = IsShiftKeyDown() -- IsControlKeyDown() or IsAltKeyDown() can be used instead
            if modifierDown then
                ShowTooltip()
            else
                HideTooltip()
            end
        else
            ShowTooltip()
        end
    end

    local function tooltipSetScript(inCombat)
        if inCombat then
            combatTooltip:SetScript("OnUpdate", function()
                tooltipToggle(inCombat)
            end)
        else
            combatTooltip:SetScript("OnUpdate", nil)
        end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_REGEN_ENABLED") -- out of combat
    events:RegisterEvent("PLAYER_REGEN_DISABLED") -- in combat

    events:SetScript("OnEvent", function()
        if event == "PLAYER_REGEN_DISABLED" then
            inCombat = true
        elseif event == "PLAYER_REGEN_ENABLED" then
            inCombat = false
        end
        tooltipSetScript(inCombat)
    end)
end