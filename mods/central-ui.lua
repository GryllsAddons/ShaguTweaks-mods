local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Central UI",
    description = "Moves unit frames, minimap, buffs and chat to a central layout.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local resolution = GetCVar("gxResolution")
    local _, _, screenwidth, screenheight = strfind(resolution, "(.+)x(.+)")
    screenwidth = tonumber(screenwidth)
    -- screenheight = tonumber(screenheight)
    -- local res = screenwidth/screenheight
    -- local uw
    -- if res > 1.78 then uw = true end
    
    local function unitframes()    
        -- Player        
        PlayerFrame:SetClampedToScreen(true)
        PlayerFrame:ClearAllPoints()
        PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -20, -150)
    
        -- Target        
        TargetFrame:SetClampedToScreen(true)
        TargetFrame:ClearAllPoints()
        TargetFrame:SetPoint("LEFT", UIParent, "CENTER", 20, -150)
    
    
        -- Party
        local scale = 1.2        
        PartyMemberFrame1:SetClampedToScreen(true)
        PartyMemberFrame1:SetScale(scale)
        PartyMemberFrame2:SetScale(scale)
        PartyMemberFrame3:SetScale(scale)
        PartyMemberFrame4:SetScale(scale)

        PartyMemberFrame1:ClearAllPoints()
        PartyMemberFrame1:SetPoint("RIGHT", UIParent, "CENTER", -200, 100)
        -- PartyMemberFrame2/3/4 moves with PartyMemberFrame1
    end
    
    local function minimap()
        local x = screenwidth/8
        local y = -10
        MinimapCluster:SetClampedToScreen(true)
        MinimapCluster:ClearAllPoints()
        MinimapCluster:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -x, -y)
        MinimapCluster.ClearAllPoints = function() end
        MinimapCluster.SetPoint = function() end
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

    local function chat()
        local _, fontsize = ChatFrame1:GetFont()
        -- local lines = 9 -- number of desired chat lines
        -- local h = (fontsize * (lines*1.1))
        local h = 120
        local w = 400
        -- local x = 32
        -- if uw then x = screenwidth/9 end
        local x = screenwidth/9
        local y = 115

        ChatFrame1:SetClampedToScreen(true)
        ChatFrame1:SetWidth(w)
        ChatFrame1:SetHeight(h)
        ChatFrame1:ClearAllPoints()
        ChatFrame1:SetPoint("BOTTOMLEFT", "UIParent", "BOTTOMLEFT", x, y)

        local found
        local frame

        for i= NUM_CHAT_WINDOWS, 1, -1 do
            frame = _G["ChatFrame"..i]
            local tab = _G["ChatFrame"..i.."Tab"]
            local name = tab:GetText()
            -- check for "Loot & Spam" chat frame
            if name == "Loot & Spam" then
                found = true                
                break
            end
        end

        if found then
            FCF_UnDockFrame(ChatFrame3)
            FCF_SetTabPosition(ChatFrame3, 0)

            ChatFrame3:ClearAllPoints()
            ChatFrame3:SetPoint("BOTTOMRIGHT", "UIParent", "BOTTOMRIGHT", -x, y)
            ChatFrame3:SetWidth(w)
            ChatFrame3:SetHeight(h)
            ChatFrame3Tab:Hide()
            FCF_SetButtonSide(ChatFrame3, "right")
            ChatFrame3:Show()
        end

        FCF_SelectDockFrame(ChatFrame1)
    end
    
    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            unitframes()
            minimap()
            buffs()
            chat()
        end
    end)
end

