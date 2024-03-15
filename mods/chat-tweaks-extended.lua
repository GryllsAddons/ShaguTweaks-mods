local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local scrollspeed = 1
local gfind = string.gmatch or string.gfind
local strsplit = ShaguTweaks.strsplit
local rgbhex = ShaguTweaks.rgbhex
local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
    title = T["Chat Tweaks Extended"],
    description = T['Extends "Chat Tweaks". Shortens channel names, shows item links on mouseover, adds an ignore on right click, adds Alt click chat names to invite and Ctrl click chat names to target.'],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Social & Chat"],
    enabled = nil,
})

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
    -- shorten chat channels
    local left = "["
    local right = "]"

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


    local timecolor = .8,.8,.8,1
    local timecolorhex = rgbhex(timecolor)

    local function AddMessage(frame, text, a1, a2, a3, a4, a5)
        if not text then return end

        if ShaguTweaks.ChatTimestamps then
            -- show timestamp in chat
            text = timecolorhex .. left .. date("%H:%M:%S") .. right .. "|r " .. text
        end

        -- reduce channel name to number
        local channel = string.gsub(text, ".*%[(.-)%]%s+(.*|Hplayer).+", "%1")
        if string.find(channel, "%d+%. ") then
          channel = string.gsub(channel, "(%d+)%..*", "channel%1")
          channel = string.gsub(channel, "channel", "")
          text = string.gsub(text, "%[%d+%..-%]%s+(.*|Hplayer)", left .. channel .. right .. " %1")
        end

        frame:HookAddMessage(text, a1, a2, a3, a4, a5)
    end

    for i=1,NUM_CHAT_WINDOWS do
        _G["ChatFrame"..i].AddMessage = AddMessage
    end
end

local function ignore()
    -- add dropdown menu button to ignore player
    UnitPopupButtons["IGNORE_PLAYER"] = { text = "Ignore", dist = 0 }
    for index,value in ipairs(UnitPopupMenus["FRIEND"]) do
        if value == "GUILD_LEAVE" then
            table.insert(UnitPopupMenus["FRIEND"], index+1, "IGNORE_PLAYER")
        end
    end

    hooksecurefunc("UnitPopup_OnClick", function(self)
        if this.value == "IGNORE_PLAYER" then
            AddIgnore(_G[UIDROPDOWNMENU_INIT_MENU].name)
        end
    end)
end

module.enable = function(self)
    ShaguTweaks.ChatTweaksExtended = true
    -- load after chat tweaks / chat links /timestamps
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            chatscroll()
            mouseoverlinks()
            clicklinks()
            channelindicators()
            ignore()
        end
    end)
end
