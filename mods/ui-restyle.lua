
local _G = _G or getfenv(0)

local module = ShaguTweaks:register({
    title = "UI Restyle",
    description = "Restyles minimap, buff/debuffs, unitframe names and buttons.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

local modLoaded

local function buffs()
    -- Buff font
    local font, size, outline = "Fonts\\FRIZQT__.TTF", 9, "OUTLINE"
    local yoffset = 3
    local f = CreateFrame("Frame", nil, GryllsMinimap)
    f:SetFrameStrata("HIGH")

    local function buffText(buffButton)
        -- remove spaces from buff durations
        local duration = getglobal(buffButton:GetName().."Duration");
        local durationtext = duration:GetText()
        if durationtext ~= nil then
            local timer = string.gsub(durationtext, "%s+", "")
            duration:SetText(timer)
        end
    end

    for i = 0, 2 do
        for _, v in pairs(
                {
                _G['TempEnchant'..i..'Duration'],
            }
        ) do
            local b = _G['TempEnchant'..i]
            v:SetFont(font, size, outline)
            v:ClearAllPoints()
            v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
            v:SetParent(f)            

            local f = CreateFrame("Frame", nil, b)
            f:SetScript("OnUpdate", function()
                buffText(b)
            end)
        end
    end

    for i = 0, 23 do
        for _, v in pairs(
                {
                _G['BuffButton'..i..'Duration'],
            }
        ) do
            local b = _G['BuffButton'..i]
            v:SetFont(font, size, outline)
            v:ClearAllPoints()
            v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
            v:SetParent(f)            

            local f = CreateFrame("Frame", nil, b)
            f:SetScript("OnUpdate", function()
                buffText(b)
            end)
        end
    end
end

local function buttons()
    local function restyle(button)
        if not button then return end        

        local hotkey = _G[button:GetName().."HotKey"]
        if hotkey then
            local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
            hotkey:SetFont(font, size, outline)
        end

        local macro = _G[button:GetName().."Name"]  
        if macro then
            local font, size, outline = "Fonts\\skurri.TTF", 12, "OUTLINE"
            macro:SetFont(font, size, outline)   
        end

        local count = _G[button:GetName()..'Count']
        if count then
            local font, size, outline = "Fonts\\frizqt__.TTF", 14, "OUTLINE"
            count:SetFont(font, size, outline)   
        end

    end
    
    for i = 1, 24 do
        local button = _G['BonusActionButton'..i]
        if button then
            restyle(button)
        end
    end

    for i = 1, 12 do
        for _, button in pairs(
                {
                _G['ActionButton'..i],
                _G['MultiBarRightButton'..i],
                _G['MultiBarLeftButton'..i],
                _G['MultiBarBottomLeftButton'..i],
                _G['MultiBarBottomRightButton'..i],
            }
        ) do
            restyle(button)
        end        
    end 

    for i = 1, 10 do
        for _, button in pairs(
            {
                _G['ShapeshiftButton'..i],
                _G['PetActionButton'..i]
            }
        ) do
            restyle(button)
        end
    end
end

local function minimap()
    -- Move minimap elements
    local styleFrame = CreateFrame("Frame", nil, MinimapCluster)
    styleFrame:SetPoint("TOP", Minimap, "BOTTOM")
    styleFrame:SetHeight(16)
    styleFrame:SetWidth(Minimap:GetWidth())

    -- Zone Text
    MinimapZoneText:ClearAllPoints()
    MinimapZoneText:SetPoint("TOP", Minimap, 0, 13)
    MinimapZoneText:SetFont("Fonts\\skurri.TTF", 14, "OUTLINE")
    MinimapZoneText:SetDrawLayer("OVERLAY", 7)        
    MinimapZoneText:SetParent(styleFrame)

    local function removeBackdrop(frame)
        frame:SetBackdropBorderColor(0,0,0,0)
        frame:SetBackdropColor(0,0,0,0)
    end

    -- ShaguTweaks clock
    if MinimapClock then
        removeBackdrop(MinimapClock)
        MinimapClock:ClearAllPoints()
        MinimapClock:SetPoint("CENTER", styleFrame, "CENTER")
    end

    -- ShaguTweaks fps
    if MinimapFPS then
        removeBackdrop(MinimapFPS)
        MinimapFPS:ClearAllPoints()
        MinimapFPS:SetPoint("LEFT", styleFrame, "LEFT")
    end

    -- ShaguTweaks ms
    if MinimapMS then
        removeBackdrop(MinimapMS)
        MinimapMS:ClearAllPoints()
        MinimapMS:SetPoint("RIGHT", styleFrame, "RIGHT")
    end

    if Minimap.border then -- if using square minimap
        -- Tracking
        MiniMapTrackingFrame:ClearAllPoints()
        MiniMapTrackingFrame:SetPoint("TOPLEFT", Minimap, "TOPLEFT", -2, 1)
        MiniMapTrackingFrame:SetScale(0.9)
        MiniMapTrackingBorder:SetTexture(nil)

        -- Mail
        MiniMapMailFrame:ClearAllPoints()
        MiniMapMailFrame:SetPoint("TOPRIGHT", Minimap, "TOPRIGHT", 4, 2)
        MiniMapMailFrame:SetScale(1.2)
        MiniMapMailBorder:SetTexture(nil)

        -- PVP
        MiniMapBattlefieldFrame:ClearAllPoints()
        MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, -2)
    end

    -- MinimapButtonFrame    
    if MBB_MinimapButtonFrame then
        -- reposition MBB to the bottom of the styleFrame (under the minimap)
        -- show the button OnEnter and hide when OnLeave

        MBB_MinimapButtonFrame:ClearAllPoints()
        MBB_MinimapButtonFrame.ClearAllPoints = function() end

        if MinimapClock.text then -- if Clock module is enabled
            MBB_MinimapButtonFrame:SetPoint("TOP", styleFrame, "BOTTOM", 0, 0)
        else
            MBB_MinimapButtonFrame:SetPoint("TOP", Minimap, "BOTTOM", 0, 0)
        end

        MBB_MinimapButtonFrame.SetPoint = function() end
        MBB_MinimapButtonFrame:SetAlpha(0)        

        -- show
        local function showButton()
            MBB_MinimapButtonFrame:SetAlpha(1)  
        end

        MBB_MinimapButtonFrame:SetScript("OnEnter", showButton)

        -- hide
        local timerFrame = CreateFrame("Frame", nil, UIParent)
        local function hideButton()
            local hideTime = GetTime() + 5 -- hides in 5 seconds
            timerFrame:SetScript("OnUpdate", function()
                if GetTime() >= hideTime then
                    MBB_HideButtons() -- MBB function to hide buttons
                    MBB_MinimapButtonFrame:SetAlpha(0)
                    timerFrame:SetScript("OnUpdate", nil)
                end
            end)
        end

        MBB_MinimapButtonFrame:SetScript("OnLeave", hideButton)
    end
end

local function names()
    local function nameFont(name)
        local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
        name:SetFont(font, size, outline)
    end

    nameFont(PlayerFrame.name)
    nameFont(PetName)
    nameFont(TargetFrame.name)
    nameFont(TargetofTargetName)
    nameFont(PartyMemberFrame1.name)
    nameFont(PartyMemberFrame2.name)
    nameFont(PartyMemberFrame3.name)
    nameFont(PartyMemberFrame4.name)
    nameFont(PartyMemberFrame1PetFrame.name)
    nameFont(PartyMemberFrame2PetFrame.name)
    nameFont(PartyMemberFrame3PetFrame.name)
    nameFont(PartyMemberFrame4PetFrame.name)
end
  
module.enable = function(self)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not modLoaded then
            modLoaded = true
            buffs()
            buttons()
            minimap()
            names()
        end
    end)
    
end
