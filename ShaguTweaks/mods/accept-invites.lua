local module = ShaguTweaks:register({
    title = "Accept Group Invites",
    description = "Accept group invites from friends and guildies.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    local events = CreateFrame("Frame", nil, UIParent)

    local function isFriend(name)
        for i = 1, GetNumFriends() do
            if GetFriendInfo(i) == name then
                return true
            end
        end
        return nil
    end
    
    local function isGuildy(name)
        if IsInGuild() then
            for i=1, GetNumGuildMembers() do
                if GetGuildRosterInfo(i) == name then
                  return true
                end
            end
        end
        return nil
    end
    
    events:RegisterEvent("PARTY_INVITE_REQUEST")

    events:SetScript("OnEvent", function()
        if isFriend(arg1) or isGuildy(arg1) then
            AcceptGroup()
            StaticPopup_Hide("PARTY_INVITE")
        end        
    end)
end