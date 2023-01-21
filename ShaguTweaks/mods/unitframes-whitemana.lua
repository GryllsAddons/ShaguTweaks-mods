local module = ShaguTweaks:register({
    title = "Unit Frame White Mana",
    description = "Changes unit frame mana color to white.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
})

module.enable = function(self)
    local function colormana(frame)
        local f = CreateFrame("Frame", nil, frame)
        f:SetScript("OnUpdate", function()
            if not UnitExists(frame.unit) and UnitHealth(frame.unit) > 0 and UnitIsConnected(frame.unit) then return end
            if UnitPowerType(frame.unit) == 0 then frame.manabar:SetStatusBarColor(1, 1, 1) end
        end)
    end

    local events = CreateFrame("Frame")
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:SetScript("OnEvent", function()
        colormana(PlayerFrame)     
        colormana(TargetFrame)
        colormana(PetFrame)
        colormana(TargetofTargetFrame)
        colormana(PartyMemberFrame1)
        colormana(PartyMemberFrame2)
        colormana(PartyMemberFrame3)
        colormana(PartyMemberFrame4)
        colormana(PartyMemberFrame1PetFrame)
        colormana(PartyMemberFrame2PetFrame)
        colormana(PartyMemberFrame3PetFrame)
        colormana(PartyMemberFrame4PetFrame)        
    end) 
end