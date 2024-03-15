local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Central UI"],
    description = T["Moves unit frames, minimap, buffs and chat to a central layout."],
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
        local unmoved

        -- Player
        unmoved = nil
        local attachedPoint, _, _, xOfs, yOfs = PlayerFrame:GetPoint()
        if (attachedPoint == "TOPLEFT") and (xOfs < -18) and (xOfs > -20) and (yOfs == -4) then unmoved = true end
        if unmoved then
            -- DEFAULT_CHAT_FRAME:AddMessage("PlayerFrame is unmoved")
            PlayerFrame:SetClampedToScreen(true)
            PlayerFrame:ClearAllPoints()
            PlayerFrame:SetPoint("RIGHT", UIParent, "CENTER", -20, -150)
        -- else
        --     DEFAULT_CHAT_FRAME:AddMessage("PlayerFrame has moved")
        end

        -- Target
        unmoved = nil
        attachedPoint, _, _, xOfs, yOfs = TargetFrame:GetPoint()
        if (attachedPoint == "TOPLEFT") and (xOfs > 250) and (xOfs < 251) and (yOfs == -4) then unmoved = true end
        if unmoved then
            -- DEFAULT_CHAT_FRAME:AddMessage("TargetFrame is unmoved")
            TargetFrame:SetClampedToScreen(true)
            TargetFrame:ClearAllPoints()
            TargetFrame:SetPoint("LEFT", UIParent, "CENTER", 20, -150)
        -- else
        --     DEFAULT_CHAT_FRAME:AddMessage("TargetFrame has moved")
        end

        -- Party
        -- unmoved = nil
        -- local attachedPoint, _, _, xOfs, yOfs = PartyMemberFrame1:GetPoint()
        -- if (attachedPoint == "TOPLEFT") and (yOfs == -128) and (not xOfs) then unmoved = true end
        -- if unmoved then
        if not PartyMemberFrame1:IsUserPlaced() then
            -- DEFAULT_CHAT_FRAME:AddMessage("PartyMemberFrame1 is unmoved")
            local partyframes = { PartyMemberFrame1, PartyMemberFrame2, PartyMemberFrame3, PartyMemberFrame4 }
            local scale = 1.2
            for _, frame in pairs(partyframes) do
                frame:SetScale(scale)
            end

            PartyMemberFrame1:SetClampedToScreen(true)
            PartyMemberFrame1:ClearAllPoints()
            PartyMemberFrame1:SetPoint("RIGHT", UIParent, "CENTER", -200, 100)
        -- else
        --     DEFAULT_CHAT_FRAME:AddMessage("PartyMemberFrame1 has moved")
        end

        for i = 2, 4 do
            local frame = _G["PartyMemberFrame"..i]
            local fparent = _G["PartyMemberFrame"..(i-1).."PetFrame"]
            frame:ClearAllPoints()
            frame:SetPoint("TOPLEFT", fparent, "BOTTOMLEFT", -23, -10)
        end
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

