local module = ShaguTweaks:register({
    title = "Central UI",
    description = "Moves the unit frames, castbar, buffs and minimap into a more central layout. This will overwrite 'Movable Unit Frames' positioning.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "UI",
    enabled = nil,
  })
  
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
    local scale = 1.4
    PartyMemberFrame1:ClearAllPoints()
    PartyMemberFrame1:SetScale(scale)
    PartyMemberFrame2:SetScale(scale)
    PartyMemberFrame3:SetScale(scale)
    PartyMemberFrame4:SetScale(scale)
    PartyMemberFrame1:SetPoint("RIGHT", UIParent, "CENTER", -200, 100)
    -- PartyMemberFrame2/3/4 moves with PartyMemberFrame1
end

local function castbar()
    if IsAddOnLoaded("GryllsSwingTimer") then
        CastingBarFrame:SetPoint("TOP", SP_ST_Frame, "BOTTOM", 0, -14)
    else
        CastingBarFrame:SetPoint("CENTER", UIParent, "CENTER", 0, -214)
    end
end   

local function minimap()
    -- local x = 448
    local x = (MultiBarLeft:GetWidth()*2)+400+MultiBarLeft:GetWidth()
    local y = 10
    MinimapCluster:ClearAllPoints()
    -- MinimapCluster:SetPoint("TOPLEFT", UIParent, x, 0)
    MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -x, -y)
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

module.enable = function(self)
    
    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        unitframes()
        castbar()         
        minimap()
        buffs()
    end)

end
  
