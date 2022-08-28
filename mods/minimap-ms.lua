local tarMS = 150 -- change to your target MS

local module = ShaguTweaks:register({
  title = "MiniMap MS",
  description = "Adds a small MS display to the mini map.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "World & MiniMap",
  enabled = nil,
})

MinimapMS = CreateFrame("Frame", "MS", Minimap)
MinimapMS:Hide()
MinimapMS:SetFrameLevel(64)
MinimapMS:SetPoint("BOTTOMRIGHT", MinimapCluster, "BOTTOMRIGHT", -24, 18)
MinimapMS:SetWidth(42)
MinimapMS:SetHeight(23)
MinimapMS:SetBackdrop({
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 16,
  insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
MinimapMS:SetBackdropBorderColor(.9,.8,.5,1)
MinimapMS:SetBackdropColor(.4,.4,.4,1)

module.enable = function(self)

    local function round(input, places)
        if not places then places = 0 end
        if type(input) == "number" and type(places) == "number" then
            local pow = 1
            for i = 1, places do pow = pow * 10 end
            return floor(input * pow + 0.5) / pow
        end
    end

    local _r, _g, _b, _a
    local function rgbhex(r, g, b, a)
        if type(r) == "table" then
            if r.r then
            _r, _g, _b, _a = r.r, r.g, r.b, (r.a or 1)
            elseif table.getn(r) >= 3 then
            _r, _g, _b, _a = r[1], r[2], r[3], (r[4] or 1)
            end
        elseif tonumber(r) then
            _r, _g, _b, _a = r, g, b, (a or 1)
        end

        if _r and _g and _b and _a then
            -- limit values to 0-1
            _r = _r + 0 > 1 and 1 or _r + 0
            _g = _g + 0 > 1 and 1 or _g + 0
            _b = _b + 0 > 1 and 1 or _b + 0
            _a = _a + 0 > 1 and 1 or _a + 0
            return string.format("|c%02x%02x%02x%02x", _a*255, _r*255, _g*255, _b*255)
        end

        return ""
    end

    -- color gradient
    local gradientcolors = {}
    function GetColorGradient(perc)
    perc = perc > 1 and 1 or perc
    perc = perc < 0 and 0 or perc
    perc = floor(perc*100)/100

    local index = perc
    if not gradientcolors[index] then
        local r1, g1, b1, r2, g2, b2

        if perc <= 0.5 then
        perc = perc * 2
        r1, g1, b1 = 1, 0, 0
        r2, g2, b2 = 1, 1, 0
        else
        perc = perc * 2 - 1
        r1, g1, b1 = 1, 1, 0
        r2, g2, b2 = 0, 1, 0
        end

        local r = round(r1 + (r2 - r1) * perc, 4)
        local g = round(g1 + (g2 - g1) * perc, 4)
        local b = round(b1 + (b2 - b1) * perc, 4)
        local h = rgbhex(r,g,b)

        gradientcolors[index] = {}
        gradientcolors[index].r = r
        gradientcolors[index].g = g
        gradientcolors[index].b = b
        gradientcolors[index].h = h
    end

    return gradientcolors[index].r,
        gradientcolors[index].g,
        gradientcolors[index].b,
        gradientcolors[index].h
    end

    MinimapMS:Show()
    MinimapMS:EnableMouse(true)
    
    local currMS = 0
    local lowMS = 1000
    local highMS = 0

    MinimapMS.text = MinimapMS:CreateFontString("Status", "LOW", "GameFontNormal")
    MinimapMS.text:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
    MinimapMS.text:SetAllPoints(MinimapMS)
    MinimapMS.text:SetFontObject(GameFontWhite)
    MinimapMS:SetScript("OnUpdate", function()
        if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + 1 end
            local _, _, MS = GetNetStats()
            currMS = MS

            if MS <= tarMS then -- show if MS exceeds the target value
                this:Hide()
            else
                this:Show()
                local _, _, _, MShex = GetColorGradient(tarMS/MS)
                MS = MShex .. MS .. "|r"
                this.text:SetText(MS.."ms")
            end

            -- check for high / low fps
            if ( highMS < currMS ) then
                highMS = currMS
            end

            if ( lowMS > currMS ) then
                lowMS = currMS
            end
    end)

    MinimapMS:SetScript("OnEnter", function()
        GameTooltip:ClearLines()
        GameTooltip:SetOwner(this, ANCHOR_BOTTOMLEFT)

        GameTooltip:AddLine("MS")
        GameTooltip:AddDoubleLine("High", highMS, 1,1,1,1,1,1)
        GameTooltip:AddDoubleLine("Low", lowMS, 1,1,1,1,1,1)
        GameTooltip:Show()
    end)

    MinimapMS:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)
end