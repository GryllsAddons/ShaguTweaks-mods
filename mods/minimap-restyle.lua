local module = ShaguTweaks:register({
  title = "Minimap Restyle",
  description = "Restyles the minimap",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "World & MiniMap",
  enabled = nil,
})

module.enable = function(self)    

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
                    MBB_MinimapButtonFrame:SetAlpha(0)
                    timerFrame:SetScript("OnUpdate", nil)
                end
            end)
        end

        MBB_MinimapButtonFrame:SetScript("OnLeave", hideButton)
    end
    
end
