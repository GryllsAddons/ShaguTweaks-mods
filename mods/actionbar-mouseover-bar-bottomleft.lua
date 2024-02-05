local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Mouseover Bottom Left"],
    description = T["Hide the Bottom Left ActionBar and show on mouseover."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Action Bar"],
    enabled = nil,
})

module.enable = function(self)
    ShaguTweaks.MouseoverBottomLeft = true
    local _G = ShaguTweaks.GetGlobalEnv()

    local timer = CreateFrame("Frame", nil, UIParent)
    local mouseOverBar
    local mouseOverButton

    local function positionExtraBars()
        -- DEFAULT_CHAT_FRAME:AddMessage("mouseover bottom left")
        -- will only trigger when mouseover bottom left bar
        if MainMenuExpBar:GetWidth() > 512 then
            -- if not reduced action bar
            -- move pet actionbar above other actionbars
            PetActionBarFrame:ClearAllPoints()
            local anchor = MainMenuBarArtFrame
            anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
            PetActionBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 36, 3);

            -- ShapeshiftBarFrame
            ShapeshiftBarFrame:ClearAllPoints()
            local offset = 0
            local anchor = ActionButton1
            anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor

            offset = anchor == ActionButton1 and ( MainMenuExpBar:IsVisible() or ReputationWatchBar:IsVisible() ) and 6 or 0
            offset = anchor == ActionButton1 and offset + 6 or offset
            ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 8, 2 + offset)
        else
            -- if reduced action bar
            -- move pet actionbar above other actionbars
            PetActionBarFrame:ClearAllPoints()
            local anchor = MainMenuBarArtFrame
            anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
            anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
            PetActionBarFrame:SetPoint("BOTTOM", anchor, "TOP", 35, 3)

            -- ShapeshiftBarFrame
            ShapeshiftBarFrame:ClearAllPoints()
            local offset = 0
            local anchor = ActionButton1
            anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
            anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor

            offset = anchor == ActionButton1 and ( MainMenuExpBar:IsVisible() or ReputationWatchBar:IsVisible() ) and 6 or 0
            offset = anchor == ActionButton1 and offset + 6 or offset
            ShapeshiftBarFrame:SetPoint("BOTTOMLEFT", anchor, "TOPLEFT", 8, 2 + offset)

            -- move castbar ontop of other bars
            local anchor = MainMenuBarArtFrame
            anchor = MultiBarBottomLeft:IsVisible() and MultiBarBottomLeft or anchor
            anchor = MultiBarBottomRight:IsVisible() and MultiBarBottomRight or anchor
            local pet_offset = PetActionBarFrame:IsVisible() and 40 or 0
            CastingBarFrame:SetPoint("BOTTOM", anchor, "TOP", 0, 10 + pet_offset)
        end

        -- SP_SwingTimer / zUI SwingTimer / GryllsSwingTimer support
        if SP_ST_Frame then
            SP_ST_Frame:ClearAllPoints()
            SP_ST_Frame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 14)
        end
    end
        
    local function hide(bar)
        bar:Hide()
        positionExtraBars()
    end
    
    local function show(bar)
        bar:Show()    
        positionExtraBars()
    end
    
    local function mouseover(bar, upd)
        local function setTimer()
            timer.time = GetTime() + 2
            timer:SetScript("OnUpdate", function()
                if GetTime() >= timer.time then
                    hide(bar)
                    timer:SetScript("OnUpdate", nil)
                end
            end)
        end
    
        if (mouseOverButton or mouseOverBar) then
            timer:SetScript("OnUpdate", nil)
            show(bar)
        elseif (not mouseOverBar) and (not mouseOverButton) or upd then
            setTimer()
        end
    end
    
    local function barEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverBar = true
            mouseover(bar)
        end)
    end
    
    local function barLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverBar = nil     
            mouseover(bar)
        end)
    end
    
    local function buttonEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverButton = true
            frame:EnableMouse(nil)
            mouseover(bar)        
        end)
    end
    
    local function buttonLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverButton = nil
            frame:EnableMouse(true)
            mouseover(bar)
        end)
    end
    
    local function mouseoverButton(button, bar)
        button.mouseover = CreateFrame("Frame", nil, UIParent)
        button.mouseover:SetAllPoints(button)
        button.mouseover:EnableMouse(true)
        button.mouseover:SetFrameStrata("DIALOG")
        buttonEnter(button.mouseover, bar)
        buttonLeave(button.mouseover, bar)
    end
    
    local function mouseoverBar(bar)
        bar.mouseover = CreateFrame("Frame", nil, UIParent)
        bar.mouseover:SetAllPoints(bar)
        bar.mouseover:EnableMouse(true)
        barEnter(bar.mouseover, bar) 
        barLeave(bar.mouseover, bar)
    end
    
    local function setup(bar)
        if not bar:IsVisible() then return end
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                mouseoverButton(button, bar)
            end
        end
        mouseoverBar(bar)        
        hide(bar)
    end
    
    local function reset(bar)
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                if button.mouseover then
                    button.mouseover:Hide()
                end
            end
        end
        
        if bar.mouseover then
            bar.mouseover:Hide()
        end
    end

    local function hideart()
        -- general function to hide textures and frames
        local function hide(frame, texture)
            if not frame then return end

            if texture and texture == 1 and frame.SetTexture then
            frame:SetTexture("")
            elseif texture and texture == 2 and frame.SetNormalTexture then
            frame:SetNormalTexture("")
            else
            frame:ClearAllPoints()
            frame.Show = function() return end
            frame:Hide()
            end
        end

        -- textures that shall be set empty
        local textures = {
            SlidingActionBarTexture0, SlidingActionBarTexture1,
            -- PetActionBarFrame
            SlidingActionBarTexture0, SlidingActionBarTexture1,
            -- ShapeshiftBarFrame
            ShapeshiftBarLeft, ShapeshiftBarMiddle, ShapeshiftBarRight,
          }

        -- button textures that shall be set empty
        local normtextures = {
            ShapeshiftButton1, ShapeshiftButton2,
            ShapeshiftButton3, ShapeshiftButton4,
            ShapeshiftButton5, ShapeshiftButton6,
        }

        -- clear textures
        for id, frame in pairs(textures) do hide(frame, 1) end
        for id, frame in pairs(normtextures) do hide(frame, 2) end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("CVAR_UPDATE")    

    events:SetScript("OnEvent", function()
        local bar = MultiBarBottomLeft
        this.enabled = SHOW_MULTI_ACTIONBAR_1 -- MultiBarBottomLeft
        
        if not this.enabled then
            reset(bar)
            return
        else
            if not this.loaded then
                this.loaded = true
                hideart()
                setup(bar)
                mouseover(bar, true)
            end
    
            if event == "CVAR_UPDATE" then
                mouseover(bar, true)
            end
        end
    end)
end
