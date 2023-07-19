local module = ShaguTweaks:register({
    title = "Restyle UI",
    description = "Restyles supported addons and the minimap. Changes fonts for units, buffs, buttons & chat.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local _G = ShaguTweaks.GetGlobalEnv()
    local restyle = CreateFrame("Frame", nil, UIParent)

    function restyle:addons()
        --[[
            Supported Addons:
            SP_SwingTimer (Vanilla/Turtle),
            MinimapButtonBag (Vanilla/Turtle)
        ]]

        local function lock(frame)
            frame.ClearAllPoints = function() end
            frame.SetAllPoints = function() end
            frame.SetPoint = function() end         
        end

        -- SP_SwingTimer
        if IsAddOnLoaded("SP_SwingTimer") and (not IsAddOnLoaded("GryllsSwingTimer")) then
            local addonpath = "Interface\\AddOns\\ShaguTweaks-mods"

            local sections  = {
                'TOPLEFT', 'TOPRIGHT', 'BOTTOMLEFT', 'BOTTOMRIGHT', 'TOP', 'BOTTOM', 'LEFT', 'RIGHT'
            }

            local function skin(f, offset)
                local t = {}
                offset = offset or 0
                    
                for i = 1, 8 do
                    local section = sections[i]
                    local x = f:CreateTexture(nil, 'OVERLAY', nil, 1)
                    x:SetTexture(addonpath..'\\img\\borders\\'..'border-'..section..'.tga')
                    t[sections[i]] = x
                end

                t.TOPLEFT:SetWidth(8)
                t.TOPLEFT:SetHeight(8)
                t.TOPLEFT:SetPoint('BOTTOMRIGHT', f, 'TOPLEFT', 4 + offset, -4 - offset)

                t.TOPRIGHT:SetWidth(8)
                t.TOPRIGHT:SetHeight(8)
                t.TOPRIGHT:SetPoint('BOTTOMLEFT', f, 'TOPRIGHT', -4 - offset, -4 - offset)

                t.BOTTOMLEFT:SetWidth(8)
                t.BOTTOMLEFT:SetHeight(8)
                t.BOTTOMLEFT:SetPoint('TOPRIGHT', f, 'BOTTOMLEFT', 4 + offset, 4 + offset)

                t.BOTTOMRIGHT:SetWidth(8)
                t.BOTTOMRIGHT:SetHeight(8)
                t.BOTTOMRIGHT:SetPoint('TOPLEFT', f, 'BOTTOMRIGHT', -4 - offset, 4 + offset)

                t.TOP:SetHeight(8)
                t.TOP:SetPoint('TOPLEFT', t.TOPLEFT, 'TOPRIGHT', 0, 0)
                t.TOP:SetPoint('TOPRIGHT', t.TOPRIGHT, 'TOPLEFT', 0, 0)

                t.BOTTOM:SetHeight(8)
                t.BOTTOM:SetPoint('BOTTOMLEFT', t.BOTTOMLEFT, 'BOTTOMRIGHT', 0, 0)
                t.BOTTOM:SetPoint('BOTTOMRIGHT', t.BOTTOMRIGHT, 'BOTTOMLEFT', 0, 0)

                t.LEFT:SetWidth(8)
                t.LEFT:SetPoint('TOPLEFT', t.TOPLEFT, 'BOTTOMLEFT', 0, 0)
                t.LEFT:SetPoint('BOTTOMLEFT', t.BOTTOMLEFT, 'TOPLEFT', 0, 0)

                t.RIGHT:SetWidth(8)
                t.RIGHT:SetPoint('TOPRIGHT', t.TOPRIGHT, 'BOTTOMRIGHT', 0, 0)
                t.RIGHT:SetPoint('BOTTOMRIGHT', t.BOTTOMRIGHT, 'TOPRIGHT', 0, 0)

                f.borderTextures = t
                f.SetBorderColor = SetBorderColor
                f.GetBorderColor = GetBorderColor
            end

            local function skinColor(f, r, g, b, a)
                local t = f.borderTextures
                if not  t then return end
                for  _, v in pairs(t) do
                    v:SetVertexColor(r or 1, g or 1, b or 1, a or 1)
                end
            end

            -- local w, h, b = 200, 14, 6
            local h, b = 14, 6
            -- set mainhand
            -- SP_ST_Frame:SetWidth(w)
            SP_ST_Frame:SetHeight(h)
            -- SP_ST_Frame:SetScale(1)
            -- SP_ST_Frame:SetAlpha(1)
            -- -- set oh
            -- SP_ST_FrameOFF:SetWidth(w)
            SP_ST_FrameOFF:SetHeight(h)
            -- SP_ST_FrameOFF:SetScale(1)
            -- SP_ST_FrameOFF:SetAlpha(1)
            -- set position
            SP_ST_Frame:ClearAllPoints()
            SP_ST_FrameOFF:ClearAllPoints()

            SP_ST_Frame:SetPoint("CENTER", 0, -250)
            SP_ST_FrameOFF:SetPoint("TOP", "SP_ST_Frame", "BOTTOM", 0, -2);

            SP_ST_FrameTime:ClearAllPoints()
            SP_ST_FrameTime2:ClearAllPoints()            
            
            SP_ST_FrameTime:SetPoint("CENTER", "SP_ST_Frame", "CENTER")
            SP_ST_FrameTime2:SetPoint("CENTER", "SP_ST_FrameOFF", "CENTER")
            -- set time
            -- SP_ST_FrameTime:SetWidth(w)
            SP_ST_FrameTime:SetHeight(h-b)

            -- SP_ST_FrameTime2:SetWidth(w)
            SP_ST_FrameTime2:SetHeight(h-b)
            -- hide icons
            SP_ST_mainhand:SetTexture(nil)
            SP_ST_mainhand:SetWidth(0)

            SP_ST_offhand:SetTexture(nil)
            SP_ST_offhand:SetWidth(0)

            SP_ST_mainhand:Hide()
            SP_ST_offhand:Hide()
            -- hide timers
            SP_ST_maintimer:Hide()
            SP_ST_offtimer:Hide()
            -- hide oh
            -- SP_ST_FrameOFF:Hide()
            -- SP_ST_FrameTime2:Hide()       
            
            local i = 2
            skin(SP_ST_Frame, i)
            skinColor(SP_ST_Frame, 0.4, 0.4, 0.4)
            skin(SP_ST_FrameOFF, i)
            skinColor(SP_ST_FrameOFF, 0.4, 0.4, 0.4)

            SP_ST_Frame:SetBackdrop({
                bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
                insets = { left = i, right = i, top = i, bottom = i }
            })
            SP_ST_FrameOFF:SetBackdrop({
                bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
                insets = { left = i, right = i, top = i, bottom = i }
            })
        end

        -- MinimapButtonFrame    
        if MBB_MinimapButtonFrame then
            -- reposition MBB to the bottom of the styleFrame (under the minimap)
            -- show the button OnEnter and hide when OnLeave
            
            if IsAddOnLoaded("MinimapButtonBag-TurtleWoW") then
                MBB_MinimapButtonFrame_Texture:SetTexture("Interface\\Icons\\Inv_misc_bag_10_green")
            else
                MBB_MinimapButtonFrame_Texture:SetTexture("Interface\\Icons\\Inv_misc_bag_10")
            end            

            MBB_MinimapButtonFrame:ClearAllPoints()
            MBB_MinimapButtonFrame:SetPoint("CENTER", Minimap, "BOTTOMLEFT", 0, 0)
            lock(MBB_MinimapButtonFrame)           
            
            local function showButton(button)
                button:SetAlpha(1)
            end

            local function hideButton(button)
                button:SetAlpha(0)  
            end            

            hideButton(MBB_MinimapButtonFrame)
            local hide = CreateFrame("BUTTON", nil, MBB_MinimapButtonFrame)
            hide:SetAllPoints(hide:GetParent())

            hide:SetScript("OnEnter", function()
                showButton(MBB_MinimapButtonFrame)
            end)

            hide:SetScript("OnLeave", function()
                hide.timer = GetTime() + 6
                hide:SetScript("OnUpdate", function()            
                    if (GetTime() > hide.timer) then
                        MBB_HideButtons() -- MBB function to hide buttons
                        hideButton(MBB_MinimapButtonFrame)
                        hide:SetScript("OnUpdate", nil)
                    end
                end)
            end)
            
            hide:RegisterForClicks("LeftButtonDown","RightButtonDown")
            hide:SetScript("OnClick", function()
                MBB_OnClick(arg1)
            end)
        end
    end

    function restyle:buffs()
        local font, size, outline = "Fonts\\FRIZQT__.TTF", 9, "OUTLINE"
        local yoffset = -5
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

    function restyle:buttons()
        local function style(button)
            if not button then return end        

            local hotkey = _G[button:GetName().."HotKey"]
            if hotkey then
                local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
                hotkey:SetFont(font, size, outline)
            end

            local macro = _G[button:GetName().."Name"]  
            if macro then
                local font, size, outline = "Fonts\\frizqt__.TTF", 9, "OUTLINE"
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
                style(button)
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
                style(button)
            end        
        end 

        for i = 1, 10 do
            for _, button in pairs(
                {
                    _G['ShapeshiftButton'..i],
                    _G['PetActionButton'..i]
                }
            ) do
                style(button)
            end
        end
    end

    function restyle:minimap()
        -- Move minimap elements
        local styleFrame = CreateFrame("Frame", nil, MinimapCluster)        
        styleFrame:SetFrameStrata("HIGH")    
        styleFrame:SetPoint("CENTER", Minimap, "BOTTOM")
        styleFrame:SetHeight(16)
        styleFrame:SetWidth(Minimap:GetWidth())

        -- Zone Text
        MinimapZoneTextButton:ClearAllPoints()
        MinimapZoneTextButton:SetPoint("TOP", Minimap, 0, 15)
        MinimapZoneText:SetFont("Fonts\\skurri.TTF", 15, "OUTLINE")
        MinimapZoneText:SetDrawLayer("OVERLAY", 7)   
        MinimapZoneText:SetParent(styleFrame)
        -- MinimapZoneText:Hide()

        -- Minimap:SetScript("OnEnter", function()
        --     MinimapZoneText:Show()
        -- end)

        -- Minimap:SetScript("OnLeave", function()
        --     MinimapZoneText:Hide()
        -- end)

        -- ShaguTweaks clock
        if MinimapClock then
            MinimapClock:ClearAllPoints()
            MinimapClock:SetPoint("CENTER", styleFrame, "CENTER", -1, 0)
        end

        -- ShaguTweaks-Mods fps
        if MinimapFPS then
            MinimapFPS:ClearAllPoints()
            MinimapFPS:SetPoint("LEFT", styleFrame, "LEFT")
        end

        -- ShaguTweaks-Mods ms
        if MinimapMS then
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
            MiniMapBattlefieldFrame:SetPoint("BOTTOMLEFT", Minimap, "BOTTOMLEFT", 2, 8)
        end        
    end

    function restyle:unitnames()
        local names = {
            PlayerFrame.name,
            PetName,
            TargetFrame.name,
            TargetofTargetName,
            PartyMemberFrame1.name,
            PartyMemberFrame2.name,
            PartyMemberFrame3.name,
            PartyMemberFrame4.name,
            PartyMemberFrame1PetFrame.name,
            PartyMemberFrame2PetFrame.name,
            PartyMemberFrame3PetFrame.name,
            PartyMemberFrame4PetFrame.name
        }

        local font, size, outline = "Fonts\\frizqt__.TTF", 12, "OUTLINE"
        for _, name in pairs(names) do
            name:SetFont(font, size, outline)
        end
    end

    function restyle:chatframes()
        local font = "Fonts\\frizqt__.TTF"
        local tabfont = "Fonts\\skurri.TTF"

        local frames = {
            ChatFrame1,
            ChatFrame2,
            ChatFrame3,
            ChatFrame4
        }

        local elements = {
            "Background",
            "ResizeTopLeftTexture",
            "ResizeTopRightTexture",
            "ResizeBottomLeftTexture",
            "ResizeBottomRightTexture",
            "ResizeTopTexture",
            "ResizeBottomTexture",
            "ResizeLeftTexture",
            "ResizeRightTexture",

            "TabLeft",
            "TabMiddle",
            "TabRight",
        }

        for _, frame in pairs(frames) do
            local _, size, outline = frame:GetFont()
            frame:SetFont(font, size, outline)
            _G[frame:GetName().."Tab"]:SetFont(tabfont, 14, outline)
            _G[frame:GetName().."Tab"]:SetHighlightTexture(nil)

            for _, element in pairs(elements) do
                _G[frame:GetName()..element]:SetTexture(nil)
            end
        end
    end

    function restyle:nameplates()
        if ShaguPlates then return end

        local font, size, outline = "Fonts\\frizqt__.TTF", 16, "OUTLINE"
        table.insert(ShaguTweaks.libnameplate.OnUpdate, function()            
            this.name:SetFont(font, size, outline)
            this.level:SetFont(font, size, outline)
        end)
    end
    
    restyle:RegisterEvent("PLAYER_ENTERING_WORLD")
    restyle:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            restyle:addons()           
            restyle:buffs()
            restyle:buttons()
            restyle:minimap()
            restyle:unitnames()
            restyle:chatframes()
            restyle:nameplates()
        end           
    end)
end
