local module = ShaguTweaks:register({
    title = "Improved Exp Bar",
    description = "Shows detailed exp, rested exp and rep values on mouseover.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Tooltip & Items",
    enabled = nil,
  })

local function round(input, places)
    if not places then places = 0 end
    if type(input) == "number" and type(places) == "number" then
        local pow = 1
        for i = 1, places do pow = pow * 10 end
        return floor(input * pow + 0.5) / pow
    end
end

local exp = CreateFrame("Frame", "exp", UIParent)

local function expStrings()
    exp:SetFrameStrata("HIGH")
    local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
    exp.expstring = exp:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    exp.expstring:SetFont(font, size, outline)
    exp.expstring:ClearAllPoints()
    exp.expstring:SetPoint("CENTER", MainMenuExpBar, "CENTER", 0, 2)
    exp.expstring:SetJustifyH("CENTER")
    exp.expstring:SetTextColor(1,1,1)

    exp.repstring = exp:CreateFontString(nil, "OVERLAY", "GameFontWhite")
    exp.repstring:SetFont(font, size, outline)
    exp.repstring:ClearAllPoints()
    exp.repstring:SetPoint("CENTER", ReputationWatchBar, "CENTER", 0, 2)
    exp.repstring:SetJustifyH("CENTER")
    exp.repstring:SetTextColor(1,1,1)
end
    
local function updateExp()
    local playerlevel = UnitLevel("player")
    local function ExpText(xp, xpmax, exh, xp_perc, remaining, remaining_perc, playerlevel)
        if playerlevel < 60 then
            if exh ~= 0 then
                local exh_perc = round(exh / xpmax * 100) or 0
                return "Level "..playerlevel.." - "..remaining.." ("..remaining_perc.."%) remaining - "..exh.." ("..exh_perc.."%) rested"
            else
                return "Level "..playerlevel.." - "..remaining.." ("..remaining_perc.."%) remaining"
            end
        end
    end

    local xp, xpmax, exh = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion() or 0
    local xp_perc = round(xp / xpmax * 100)
    local remaining = xpmax - xp
    local remaining_perc = round(remaining / xpmax * 100)  

    -- set exp text
    exp.expstring:SetText(ExpText(xp, xpmax, exh, xp_perc, remaining, remaining_perc, playerlevel))
end

local function updateRep()
    local name, standing, min, max, value = GetWatchedFactionInfo()
    local max = max - min
    local value = value - min
    local remaining = max - value
    local percent = (value / max) * 100
    local percentFloor = floor(percent + 0.5)
    local repvalues = { "Hated", "Hostile", "Unfriendly", "Neutral", "Friendly", "Honored", "Revered", "Exalted" }
    local level = UnitLevel("player")

    if name then -- watching a faction
        exp.repstring:SetText(name .. " (" .. repvalues[standing] .. ") " .. percentFloor .. "% - "  .. round(remaining) .. " remaining")
    else
        exp.repstring:SetText("")
    end
end

local function exp_mouseShow()
    exp.expstring:Show()
end

local function exp_mouseHide()
    exp.expstring:Hide()
end

local function exp_mouseOver()
    exp_Mouse = CreateFrame("Frame")
    exp_Mouse:SetAllPoints(MainMenuExpBar)
    exp_Mouse:SetFrameStrata("HIGH")
    exp_Mouse:EnableMouse(true)
    exp_Mouse:SetScript("OnEnter", exp_mouseShow)
    exp_Mouse:SetScript("OnLeave", exp_mouseHide)
end

local function rep_mouseShow()
    exp.repstring:Show()
end

local function rep_mouseHide()
    exp.repstring:Hide()
end

local function rep_mouseOver()
    rep_Mouse = CreateFrame("Frame")
    rep_Mouse:SetAllPoints(ReputationWatchBar)
    rep_Mouse:SetFrameStrata("HIGH")
    rep_Mouse:EnableMouse(true)
    rep_Mouse:SetScript("OnEnter", rep_mouseShow)
    rep_Mouse:SetScript("OnLeave", rep_mouseHide)
end

module.enable = function(self)
    
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("UPDATE_EXHAUSTION")
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("PLAYER_XP_UPDATE")
    events:RegisterEvent("UPDATE_FACTION")

    events:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            expStrings()
            MainMenuBarOverlayFrame:Hide()       
            exp_mouseOver()
            updateExp()
            exp.expstring:Hide()          
            rep_mouseOver()
            updateRep()            
            exp.repstring:Hide()
        elseif event == "UPDATE_EXHAUSTION" then
            updateExp()
        elseif event == "PLAYER_XP_UPDATE" then
            updateExp()
        elseif event == "UPDATE_FACTION" then
            updateRep()
        end
    end)

end