local module = ShaguTweaks:register({
    title = "Central UI",
    description = "Moves the unit frames, castbar, buffs and minimap into a more central layout. This will overwrite 'Movable Unit Frames' positioning.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local function unitframes()    
        --[[ When scaling, the unit frame may move offscreen ]]
    
        -- Player / Target
        local scale = 1    
        local x = 20
        local y = -150
    
        -- Player
        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetScale(scale)
        PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -x, y)
    
        -- Target
        TargetFrame:ClearAllPoints()
        TargetFrame:SetScale(scale)
        TargetFrame:SetPoint("LEFT", UIParent, "CENTER", x, y)
    
        -- Party
        local scale = 1.2
        PartyMemberFrame1:ClearAllPoints()
        PartyMemberFrame1:SetScale(scale)
        PartyMemberFrame2:SetScale(scale)
        PartyMemberFrame3:SetScale(scale)
        PartyMemberFrame4:SetScale(scale)
        PartyMemberFrame1:SetPoint("RIGHT", UIParent, "CENTER", -200, 100)
        -- PartyMemberFrame2/3/4 moves with PartyMemberFrame1
    end
    
    local function castbar()
        local function lock(frame)
            frame.ClearAllPoints = function() end
            frame.SetAllPoints = function() end
            frame.SetPoint = function() end
        end

        CastingBarFrame:ClearAllPoints()
        CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -275)
        -- CastingBarFrame:SetPoint("BOTTOM", MainMenuBar, "TOP", 0, ActionButton1:GetHeight()+10)
        lock(CastingBarFrame)

        -- GryllsSwingTimer / zUI SwimgTimer support
        if SP_ST_Frame then
            SP_ST_Frame:ClearAllPoints()
            SP_ST_Frame:SetPoint("BOTTOM", CastingBarFrame, "TOP", 0, 14)
            lock(SP_ST_Frame)      
        end   
    end   
    
    local function minimap()
        if UIParent:GetRight() > 2513 then
            -- 3440
            local w = 400
            local x = MainMenuExpBar:GetLeft() - w - ActionButton1:GetWidth()*2
            local y = 10
            MinimapCluster:ClearAllPoints()
            MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -x, -y)
        end        
    end
    
    local function buffs()
        -- Buffs start with TemporaryEnchantFrame
        -- Debuffs are aligned underneath the TemporaryEnchantFrame    
        TemporaryEnchantFrame:ClearAllPoints()
        TemporaryEnchantFrame:SetPoint("TOPLEFT", MinimapCluster, -15, -28)
    
        -- prevent TemporaryEnchantFrame from moving
        TemporaryEnchantFrame.ClearAllPoints = function() end
        TemporaryEnchantFrame.SetPoint = function() end
    end
    
    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        unitframes()
        castbar()         
        minimap()
        buffs()
    end)
end
