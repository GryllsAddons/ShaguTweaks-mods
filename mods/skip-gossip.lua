local module = ShaguTweaks:register({
    title = "Skip Gossip Text",
    description = "Skip gossip text when interacting with NPCs unless holding shift.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    local actions = CreateFrame("Frame", nil, UIParent)

    local professions = {
        "battlemaster",
        "taxi",
        "trainer",
        "vendor"
    }

    local phrases = {
        "Teleport me to the Molten Core",
        -- Turtle WoW
        "Please open a portal to Alah'Thalas",
        "Please open a portal to Stormwind"
    }

    function actions:Gossip()        
        if actions.gossip then
            local GossipOptions = {}
            local title
            title,GossipOptions[1],_,GossipOptions[2],_,GossipOptions[3],_,GossipOptions[4],_,GossipOptions[5] = GetGossipOptions()            

            for i = 1, 5 do
                if not GossipOptions[i] then break end              
                if GossipOptions[i] == "gossip" then
                    title = string.gsub(title, "%W", "")
                    for _, phrase in pairs(phrases) do
                        phrase = string.gsub(phrase, "%W", "")                        
                        if phrase == title then
                            SelectGossipOption(i)
                            break
                        end
                    end
                else
                    for _, profession in pairs(professions) do
                        if profession == GossipOptions[i] then
                            SelectGossipOption(i)
                            break
                        end
                    end
                end
            end
        end
    end

    actions:RegisterEvent("GOSSIP_SHOW")
    actions:RegisterEvent("GOSSIP_CLOSED")

    actions:SetScript("OnEvent", function()
        if (event == "GOSSIP_SHOW") then
            actions.gossip = true
            if not IsShiftKeyDown() then
                actions:Gossip()
            end
        elseif (event == "GOSSIP_CLOSED") then
            actions.gossip = nil        
        end
    end)    
end