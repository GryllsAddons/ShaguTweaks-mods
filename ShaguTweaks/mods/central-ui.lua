local module = ShaguTweaks:register({
    title = "Central UI",
    description = "Moves unit frames, minimap and buffs to a central layout.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local function unitframes()
        local scale, x, y = 1, 20, -150
    
        -- Player
        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetClampedToScreen(true)
        PlayerFrame:SetScale(scale)
        PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -x, y)
    
        -- Target
        TargetFrame:ClearAllPoints()
        TargetFrame:SetClampedToScreen(true)
        TargetFrame:SetScale(scale)
        TargetFrame:SetPoint("LEFT", UIParent, "CENTER", x, y)
    
        -- Party
        scale = 1.2
        PartyMemberFrame1:ClearAllPoints()
        PartyMemberFrame1:SetClampedToScreen(true)
        PartyMemberFrame1:SetScale(scale)
        PartyMemberFrame2:SetScale(scale)
        PartyMemberFrame3:SetScale(scale)
        PartyMemberFrame4:SetScale(scale)
        PartyMemberFrame1:SetPoint("RIGHT", UIParent, "CENTER", -200, 100)
        -- PartyMemberFrame2/3/4 moves with PartyMemberFrame1
    end
    
    local function minimap()
        local w = 400
        local x = MainMenuExpBar:GetLeft() - w - ActionButton1:GetWidth()*2
        local y = 10
        MinimapCluster:ClearAllPoints()
        MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -x, -y)

        -- if UIParent:GetRight() > 2513 then
        --    -- 3440
        -- end        
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
        minimap()
        buffs()
    end)
end