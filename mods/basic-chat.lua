local module = ShaguTweaks:register({
    title = "Basic Chat",
    description = "Creates non-configurable General, Combat Log and Loot & Spam chat boxes",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Social & Chat",
    enabled = nil,
  })
  
  module.enable = function(self)
    
    local function SetupChat()
        
        local fontsize = 14 -- chat font size
        local lines = 8 -- number of chat lines
        local h = (fontsize * lines)
        local w = 400
        -- local x = 448
        local x = MainMenuExpBar:GetRight()+(MultiBarLeft:GetWidth()*2)
        local y = (MultiBarLeft:GetWidth()*2)

        local function setChatFrame(chatframe)
            FCF_SetLocked(chatframe, 1)
            FCF_SetWindowColor(chatframe, 0, 0, 0)
            FCF_SetWindowAlpha(chatframe, 0)
            FCF_SetChatWindowFontSize(chatframe, fontsize)
            
            chatframe:SetWidth(w)
            chatframe:SetHeight(h)
            chatframe:ClearAllPoints()
            chatframe:SetUserPlaced(1)
        end

        setChatFrame(ChatFrame1)
        FCF_SetWindowName(ChatFrame1, GENERAL)

        setChatFrame(ChatFrame2)
        FCF_DockFrame(ChatFrame2)
        FCF_SetWindowName(ChatFrame2, COMBAT_LOG)

        ChatFrame3:Show()
        FCF_UnDockFrame(ChatFrame3)
        FCF_SetTabPosition(ChatFrame3, 0)
        setChatFrame(ChatFrame3)
        FCF_SetWindowName(ChatFrame3, "Loot & Spam")              
        
        ChatFrame1:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMRIGHT", -x, y)        
        ChatFrame2:SetAllPoints(ChatFrame1)
        ChatFrame3:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
        

        FCF_DockUpdate()
    end

    function SetupChannels()
        ChatFrame_RemoveAllMessageGroups(ChatFrame1)
        ChatFrame_RemoveAllMessageGroups(ChatFrame2)
        ChatFrame_RemoveAllMessageGroups(ChatFrame3)
    
        ChatFrame_RemoveAllChannels(ChatFrame1)
        ChatFrame_RemoveAllChannels(ChatFrame2)
        ChatFrame_RemoveAllChannels(ChatFrame3)
    
        local normalg = { "SYSTEM", "SAY", "YELL", "WHISPER", "PARTY", "GUILD", "GUILD_OFFICER", "CREATURE", "CHANNEL", "EMOTE", "RAID", "RAID_LEADER", "RAID_WARNING", "BATTLEGROUND", "BATTLEGROUND_LEADER", "MONSTER_SAY", "MONSTER_EMOTE", "MONSTER_YELL", "MONSTER_WHISPER", "MONSTER_BOSS_EMOTE", "MONSTER_BOSS_WHISPER" }
        for _,group in pairs(normalg) do
          ChatFrame_AddMessageGroup(ChatFrame1, group)
        end
    
        ChatFrame_ActivateCombatMessages(ChatFrame2)
    
        
        local spamg = { "COMBAT_XP_GAIN", "COMBAT_HONOR_GAIN", "COMBAT_FACTION_CHANGE", "SKILL", "LOOT" }
        for _,group in pairs(spamg) do
        ChatFrame_AddMessageGroup(ChatFrame3, group)
        end

        for _, chan in pairs({EnumerateServerChannels()}) do
        ChatFrame_AddChannel(ChatFrame3, chan)
        ChatFrame_RemoveChannel(ChatFrame1, chan)
        end

        JoinChannelByName("World")
        ChatFrame_AddChannel(ChatFrame3, "World")
    end

    local chatFrame = CreateFrame("Frame", nil, UIParent)	
    chatFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

    chatFrame:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            SetupChat()
            SetupChannels()
        end
    end)

end