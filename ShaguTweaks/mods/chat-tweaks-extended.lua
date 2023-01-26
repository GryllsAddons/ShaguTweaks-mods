local _G = ShaguTweaks.GetGlobalEnv()
local scrollspeed = 1
local gfind = string.gmatch or string.gfind
local strsplit = ShaguTweaks.strsplit

local module = ShaguTweaks:register({
    title = "Chat Tweaks Extended",
    description = 'Extends "Chat Tweaks". Removes chat buttons, shortens channel names, shows item links on mouseover, adds Alt click chat names to invite and Ctrl click chat names to target.',
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Social & Chat",
    enabled = nil,
})

local function chatbuttons()
    for i=1, NUM_CHAT_WINDOWS do
        -- hide buttons
        _G["ChatFrame" .. i .. "UpButton"]:Hide()
        _G["ChatFrame" .. i .. "UpButton"].Show = function() return end
        _G["ChatFrame" .. i .. "DownButton"]:Hide()
        _G["ChatFrame" .. i .. "DownButton"].Show = function() return end
        _G["ChatFrame" .. i .. "BottomButton"]:Hide()
        _G["ChatFrameMenuButton"]:Hide()
        _G["ChatFrameMenuButton"].Show = function() return end

        -- hide BottomButton on click
        _G["ChatFrame" .. i .. "BottomButton"]:SetScript("OnClick", function()
            this:GetParent():ScrollToBottom()
            this:Hide()
        end)

    end

    -- Hook FCF_DockUpdate
    if not HookFCF_DockUpdate then
        local HookFCF_DockUpdate = FCF_DockUpdate
        function _G.FCF_DockUpdate() 
            for i=1, NUM_CHAT_WINDOWS do
                if not _G["ChatFrame" .. i].scroll then
                    _G["ChatFrame" .. i]:ScrollToBottom()
                    _G["ChatFrame" .. i .. "BottomButton"]:Hide()
                end             
            end
            HookFCF_DockUpdate()
        end
    end
end

local function ChatOnMouseWheel()
    if arg1 > 0 then
      if IsShiftKeyDown() then
        this:ScrollToTop()
      else
        for i=1, scrollspeed do
          this:ScrollUp()
        end
      end
    elseif arg1 < 0 then
      if IsShiftKeyDown() then
        this:ScrollToBottom()
      else
        for i=1, scrollspeed do
          this:ScrollDown()          
        end
      end
    end    
    if ( this:AtBottom() ) then
        _G[this:GetName().."BottomButton"]:Hide()
        this.scroll = nil
    else
        this.scroll = true
        _G[this:GetName().."BottomButton"]:Show()
    end
end

local function chatscroll()
    for i=1, NUM_CHAT_WINDOWS do
        -- enable mouse wheel scrolling
        _G["ChatFrame" .. i]:EnableMouseWheel(true)
        _G["ChatFrame" .. i].scroll = nil
        _G["ChatFrame" .. i]:SetScript("OnMouseWheel", ChatOnMouseWheel)
    end
end

local function mouseoverlinks()
    for i=1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame" .. i]   
        frame:SetScript("OnHyperlinkEnter", function()
            local _, _, linktype = string.find(arg1, "^(.-):(.+)$")
            if linktype == "item" then
            GameTooltip:SetOwner(this, "ANCHOR_CURSOR")
            GameTooltip:SetHyperlink(arg1)
            GameTooltip:Show()
            end
        end)
        frame:SetScript("OnHyperlinkLeave", function()
            GameTooltip:Hide()
        end)
    end
end

local function clicklinks()
    for i=1, NUM_CHAT_WINDOWS do
        local frame = _G["ChatFrame" .. i]   
        frame:SetScript("OnHyperlinkClick", function()
            local _, _, playerLink = string.find(arg1, "(player:.+)")
            if playerLink then
                local _, player = strsplit(":", playerLink)
                if IsAltKeyDown() then
                    InviteByName(player)
                elseif IsControlKeyDown() then
                    TargetByName(player, true)
                else
                    ChatFrame_OnHyperlinkShow(arg1, arg2, arg3);
                end
            else
                ChatFrame_OnHyperlinkShow(arg1, arg2, arg3);
            end
        end)
    end
end

local function channelindicators()
    local left = "["
    local right = "]"
    -- shorten chat channel indicators
    local default = " " .. "%s" .. "|r:" .. "\32"
    _G.CHAT_CHANNEL_GET = "%s" .. "|r:" .. "\32"
    _G.CHAT_GUILD_GET = left .. "G" .. right .. default
    _G.CHAT_OFFICER_GET = left .. "O" .. right .. default
    _G.CHAT_PARTY_GET = left .. "P" .. right .. default
    _G.CHAT_RAID_GET = left .. "R" .. right .. default
    _G.CHAT_RAID_LEADER_GET = left .. "RL" .. right .. default
    _G.CHAT_RAID_WARNING_GET = left .. "RW" .. right .. default
    _G.CHAT_BATTLEGROUND_GET = left .. "BG" .. right .. default
    _G.CHAT_BATTLEGROUND_LEADER_GET = left .. "BL" .. right .. default
    _G.CHAT_SAY_GET = left .. "S" .. right .. default
    _G.CHAT_YELL_GET = left .. "Y" .. right ..default
    _G.CHAT_WHISPER_GET = '[From]' .. default
    _G.CHAT_WHISPER_INFORM_GET = '[To]' .. default
end

module.enable = function(self)
    -- load after chat tweaks / chat links
    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        chatscroll()
        chatbuttons()
        mouseoverlinks()
        clicklinks()
        channelindicators()
    end)
end
