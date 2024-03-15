local _G = ShaguTweaks.GetGlobalEnv()
local L, T = ShaguTweaks.L, ShaguTweaks.T
local rgbhex = ShaguTweaks.rgbhex

local module = ShaguTweaks:register({
    title = T["Chat Bubble Tweaks"],
    description = T["Shows sender names on chat bubbles and removes the background."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Social & Chat"],
    enabled = nil,
})

module.enable = function(self)
    local message, sender
    local playerdb = ShaguTweaks_cache["players"]
    local font, size, outline = "Fonts\\FRIZQT__.TTF", 14, "OUTLINE"

    local chat = CreateFrame("Frame", nil, UIParent)
    chat:RegisterEvent("CHAT_MSG_SAY")
    chat:RegisterEvent("CHAT_MSG_YELL")
    chat:RegisterEvent("CHAT_MSG_PARTY")
    chat:RegisterEvent("CHAT_MSG_PARTY_LEADER")
    chat:RegisterEvent("CHAT_MSG_MONSTER_SAY")
    chat:RegisterEvent("CHAT_MSG_MONSTER_YELL")
    chat:RegisterEvent("CHAT_MSG_MONSTER_PARTY")

    chat:SetScript("OnEvent", function()
      chat:SetScript("OnUpdate", chat.ScanBubbles)
    end)

    function chat:IsBubble(f)
        if f:GetName() then return end
        if not f:GetRegions() then return end
        return f:GetRegions().GetTexture and f:GetRegions():GetTexture() == "Interface\\Tooltips\\ChatBubble-Background"
    end

    function chat:ProcessBubble(f)
      f.text:Hide()
      f.text:SetFont(font, size * UIParent:GetScale(), outline)
      local r,g,b,a = f.text:GetTextColor()
      local text = f.text:GetText()
      f.frame.text:SetText(text)
      f.frame.text:SetTextColor(r,g,b,a)

      if text == message then
        if playerdb[sender] then
            local level = playerdb[sender].level
            local class = playerdb[sender].class
            local ccolor = RAID_CLASS_COLORS[L["class"][class]] or { 1, 1, 1 }
            local lcolor = GetDifficultyColor(tonumber(level)) or { 1, 1, 1 }
            local cname = rgbhex(ccolor) .. sender .. "|r"
            local clevel = rgbhex(lcolor) .. level .. "|r"
            f.frame.player:SetText(cname .. " " .. clevel)
        else
            f.frame.player:SetTextColor(r,g,b,a)
            f.frame.player:SetText(sender)
        end
      end
    end

    function chat:ScanBubbles()
      local childs = { WorldFrame:GetChildren() }
      for _, f in pairs(childs) do
          if not f.frame and chat:IsBubble(f) then
            local textures = {f:GetRegions()}
            for _, object in pairs(textures) do
              if object:GetObjectType() == "Texture" then
                object:SetTexture('')
              elseif object:GetObjectType() == 'FontString' then
                f.text = object
              end
            end

            f.frame = CreateFrame("Frame", nil, f)
            f.frame:SetScale(UIParent:GetScale())
            f.frame:SetAllPoints(f)

            f.frame.text = f.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            f.frame.text:SetFont(font, size, outline)
            f.frame.text:SetJustifyH("LEFT")
            f.frame.text:SetJustifyV("LEFT")
            f.frame.text:SetAllPoints(f.frame)

            f.frame.player = f.frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
            f.frame.player:SetFont(font, size, outline)
            f.frame.player:SetJustifyH("LEFT")
            f.frame.player:SetJustifyV("LEFT")
            f.frame.player:SetPoint("TOPLEFT", f.frame.text, "TOPLEFT", 0, -8)

            chat:ProcessBubble(f)

            f:SetScript("OnShow", function()
              chat:ProcessBubble(this)
            end)
          end
      end

      chat:SetScript("OnUpdate", nil)
    end

    local HookChatFrame_OnEvent = ChatFrame_OnEvent
    function ChatFrame_OnEvent(event)
        if (event == "CHAT_MSG_SAY") or (event == "CHAT_MSG_YELL") or (event == "CHAT_MSG_PARTY") or (event == "CHAT_MSG_PARTY_LEADER") or (event == "CHAT_MSG_MONSTER_SAY") or (event == "CHAT_MSG_MONSTER_YELL") or (event == "CHAT_MSG_MONSTER_PARTY") then
            -- arg1: Message that was sent/received.
            -- arg2: Name of the player/monster who sent the message.
            message = arg1
            sender = arg2
        end
        HookChatFrame_OnEvent(event)
    end
end
