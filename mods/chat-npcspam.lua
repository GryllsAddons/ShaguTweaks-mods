local module = ShaguTweaks:register({
    title = "Block NPC Spam",
    description = "Blocks spam messages from NPCs.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Social & Chat",
    enabled = nil,
})
  
module.enable = function(self)
    local msg

    local events = {
        ["CHAT_MSG_MONSTER_SAY"] = true,
        ["CHAT_MSG_MONSTER_YELL"] = true,
        -- ["CHAT_MSG_MONSTER_EMOTE"] = true,
        -- ["CHAT_MSG_MONSTER_WHISPER"] = true,
        -- ["CHAT_MSG_RAID_BOSS_EMOTE"] = true,
    }

    local npcs = {
        "Tansy Sparkpen",
        "Fara Boltbreaker",
        "Shellcoin Promoter",
    }

    local blocks = {
        { "shellcoin", "invest" },
        { "shells", "trade" },
        { "shells", "money" },    
    }

    local prepare = function(msg)
        msg = string.gsub(msg, "[^A-Za-z0-9]", "")
        return msg
    end

    local _ChatFrame_OnEvent = ChatFrame_OnEvent
    function ChatFrame_OnEvent(event)
        if events[event] and arg2 and arg1 then
            msg = prepare(arg1)

            for _, npc in pairs(npcs) do
                local matched = true
                
                if not (string.lower(npc) == string.lower(arg2)) then
                    matched = false
                end

                if matched == true then
                    -- DEFAULT_CHAT_FRAME:AddMessage("blocked npc "..arg2)
                    return true
                end
            end

            for _, data in pairs(blocks) do
                local matched = true

                for _, str in pairs(data) do
                    if not strfind(string.lower(msg), string.lower(str)) then
                    matched = false
                    end
                end

                if matched == true then
                    -- DEFAULT_CHAT_FRAME:AddMessage("blocked msg "..arg1.." from "..arg2)
                    return true
                end
            end
        end

        _ChatFrame_OnEvent(event)
    end
end