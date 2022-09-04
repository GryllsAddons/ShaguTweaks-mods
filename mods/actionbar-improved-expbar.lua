local module = ShaguTweaks:register({
    title = "Improved Exp Bar",
    description = "Show detailed exp, rested exp and rep values on mouseover. Bar shows rested precent while resting and changes green when 150% rested.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    local function round(input, places)
        if not places then places = 0 end
        if type(input) == "number" and type(places) == "number" then
            local pow = 1
            for i = 1, places do pow = pow * 10 end
            return floor(input * pow + 0.5) / pow
        end
    end
    
    local exp = CreateFrame("Frame", "exp", UIParent)
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
    
    local function updateExp()
        local playerlevel = UnitLevel("player")
        local xp, xpmax, exh = UnitXP("player"), UnitXPMax("player"), GetXPExhaustion() or 0
        local xp_perc = round(xp / xpmax * 100)
        local exh_perc = round(exh / xpmax * 100) or 0
        local remaining = xpmax - xp
        local remaining_perc = round(remaining / xpmax * 100)

        if playerlevel < 60 then
            if IsResting() then
                exp.expstring:SetText(exh_perc.."% rested")
            else            
                if (exh == 0) then
                    exp.expstring:SetText("Level "..playerlevel.." - "..remaining.." ("..remaining_perc.."%) remaining")            
                else
                    exp.expstring:SetText("Level "..playerlevel.." - "..remaining.." ("..remaining_perc.."%) remaining - "..exh.." ("..exh_perc.."%) rested")
                end
            end
        end

        local rested  = GetRestState();
		if (rested == 1) then
            if (exh_perc == 150) then
                MainMenuExpBar:SetStatusBarColor(0, 1, 0.6, 1)
            else
			    MainMenuExpBar:SetStatusBarColor(0.0, 0.39, 0.88, 1.0)
            end
		elseif (rested == 2) then
			MainMenuExpBar:SetStatusBarColor(0.58, 0.0, 0.55, 1.0)
        end
        
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
    
    local function expShow()
        updateExp()
        exp.expstring:Show()
    end
    
    local function expHide()
        if not IsResting() then
            exp.expstring:Hide()
        end
    end
    
    local function mouseoverExp()
        local expMouse = CreateFrame("Frame")
        expMouse:SetAllPoints(MainMenuExpBar)
        expMouse:SetFrameStrata("HIGH")
        expMouse:EnableMouse(true)
        expMouse:SetScript("OnEnter", expShow)
        expMouse:SetScript("OnLeave", expHide)
    end
    
    local function repShow()
        exp.repstring:Show()
    end
    
    local function repHide()
        exp.repstring:Hide()
    end
    
    local function mouseoverRep()
        local repMouse = CreateFrame("Frame")
        repMouse:SetAllPoints(ReputationWatchBar)
        repMouse:SetFrameStrata("HIGH")
        repMouse:EnableMouse(true)
        repMouse:SetScript("OnEnter", repShow)
        repMouse:SetScript("OnLeave", repHide)
    end

    local function updateResting()
        if IsResting() then
            updateExp()
            expShow()
        else
            expHide()
        end
    end
    
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("PLAYER_UPDATE_RESTING")
    events:RegisterEvent("UPDATE_EXHAUSTION")
    events:RegisterEvent("PLAYER_XP_UPDATE")    
    events:RegisterEvent("UPDATE_FACTION")

    events:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            MainMenuBarOverlayFrame:Hide()       
            mouseoverExp()
            mouseoverRep()            
            updateExp()
            updateRep()
            expHide()
            repHide()
        elseif event == "PLAYER_UPDATE_RESTING" then
            updateResting()
        else
            updateExp()       
        end
    end)
end