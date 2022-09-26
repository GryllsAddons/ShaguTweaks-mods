local _G = _G or getfenv(0)
local scrollspeed = 1
local strsplit = ShaguTweaks.strsplit

local module = ShaguTweaks:register({
    title = "Chat Tweaks Extended",
    description = 'Extends "Chat Tweaks". Removes chat buttons, shows item links on hover, adds Alt click chat names to invite and Ctrl click chat names to target.',
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
    else
        _G[this:GetName().."BottomButton"]:Show()
    end
end

local function chatscroll()
    for i=1, NUM_CHAT_WINDOWS do
        -- enable mouse wheel scrolling
        _G["ChatFrame" .. i]:EnableMouseWheel(true)
        _G["ChatFrame" .. i]:SetScript("OnMouseWheel", ChatOnMouseWheel)
    end
end

local function hoverlinks()
    for i=1, NUM_CHAT_WINDOWS do        
        _G["ChatFrame" .. i]:SetScript("OnHyperlinkEnter", function()
            local _, _, itemLink = string.find(arg1, "(item:%d+:%d+:%d+:%d+)")
            if itemLink then
                GameTooltip:SetOwner(GameTooltip, "ANCHOR_CURSOR")
                GameTooltip:SetHyperlink(itemLink)
                GameTooltip:Show()
            end
        end)
        _G["ChatFrame" .. i]:SetScript("OnHyperlinkLeave", function()
            GameTooltip:Hide()
        end)
    end
end

local function clicklinks()
    for i=1, NUM_CHAT_WINDOWS do
        _G["ChatFrame" .. i]:SetScript("OnHyperlinkClick", function()
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

module.enable = function(self)
    -- load after chat tweaks
    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        chatbuttons()
        chatscroll()
        hoverlinks()
        clicklinks()
    end)
end