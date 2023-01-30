local _G = ShaguTweaks.GetGlobalEnv()
local ChatFrameWorld
local ChatFrameLeftWorld

local module = ShaguTweaks:register({
    title = "World Chat Hider",
    description = "Looks for world chat in the chat frames and hides it while in an instance.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Social & Chat",
    enabled = nil,
})

local function WorldChat(inInstance)
	local findChannel = function(ChatFrame, name)  
		for index, value in ChatFrame.channelList do
			if (strupper(name) == strupper(value)) then
				return true
			end
		end
		return false
	end

	-- if we have left world channel previously, join the previous chatframe
	if ChatFrameLeftWorld then
		ChatFrameWorld = ChatFrameLeftWorld
	else
		-- look for world channel in chat frames
		local id, name = GetChannelName("world")
		if not name then return end
		for i = 1, NUM_CHAT_WINDOWS do
			local ChatFrame = _G["ChatFrame"..i]			
			if findChannel(ChatFrame, name) then
				ChatFrameWorld = ChatFrame
				break
			end
		end
	end
	
	if ChatFrameWorld then
		if (inInstance == 1) then
			ChatFrame_RemoveChannel(ChatFrameWorld, "world")
			-- DEFAULT_CHAT_FRAME:AddMessage("Left world on chatframe "..ChatFrameWorld:GetName())
			ChatFrameLeftWorld = ChatFrameWorld
		else
			JoinChannelByName("world", nil, ChatFrameWorld:GetID())
			-- DEFAULT_CHAT_FRAME:AddMessage("Joined world on chatframe "..ChatFrameWorld:GetName())
			ChatFrameLeftWorld = nil
		end
	end
end

module.enable = function(self)
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("WORLD_MAP_UPDATE")

    events.timer = CreateFrame("Frame", nil, UIParent)
    events.timer:SetScript("OnUpdate", function()
        if GetTime() >= events.timer.time then
			local inInstance, instanceType = IsInInstance() or 0, "NONE"
			-- DEBUG:
			-- DEFAULT_CHAT_FRAME:AddMessage("inInstance: "..inInstance..", instanceType: "..instanceType)
			WorldChat(inInstance)
			this:Hide()
        end
    end)

    events:SetScript("OnEvent", function()
        events.timer.time = GetTime()+.25
        events.timer:Show()       
    end)    
end
