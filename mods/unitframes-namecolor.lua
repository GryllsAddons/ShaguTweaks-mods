local module = ShaguTweaks:register({
  title = "Unit Frame Name Colors",
  description = "Adds class and player pet coloring to the unitframes.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

local function colorName(unit)
    local name
    if unit == "player" then
        name = PlayerFrame.name
    elseif unit == "pet" then
        name = PetName
    elseif unit == "target" then
        name = TargetFrame.name
    elseif unit == "targettarget" then
        name = TargetofTargetName
    elseif unit == "party1" then
        name = PartyMemberFrame1.name
    elseif unit == "party2" then
        name = PartyMemberFrame2.name
    elseif unit == "party3" then
        name = PartyMemberFrame3.name
    elseif unit == "party4" then
        name = PartyMemberFrame4.name
    elseif unit == "partypet1" then
        name = PartyMemberFrame1PetFrame.name
    elseif unit == "partypet2" then
        name = PartyMemberFrame2PetFrame.name
    elseif unit == "partypet3" then
        name = PartyMemberFrame3PetFrame.name
    elseif unit == "partypet4" then
        name = PartyMemberFrame4PetFrame.name
    end

    if name then       
        local r,g,b
        if UnitIsPlayer(unit) then
            -- color by class
            local _, class = UnitClass(unit)
            if class == "SHAMAN" then
                r, g, b = 0/255, 112/255, 221/255 -- blue shamans
            else
                local color = RAID_CLASS_COLORS[class]
                r,g,b = color.r, color.g, color.b
            end
        else
            -- not a player
            local creatureType = UnitCreatureType(unit)
            local friend = UnitIsFriend("player", unit)
            if friend then
                if creatureType == "Demon" then -- friendly Warlock pet
                    r,g,b = 148/255, 130/255, 201/255
                elseif creatureType == "Beast" then -- friendly Hunter pet
                    r,g,b = 171/255, 212/255, 115/255
                else
                    r,g,b = 255/255, 210/255, 0/255  -- default color
                end
            else
                -- enemy
                -- color name by reaction
                r,g,b = GameTooltip_UnitColor(unit)
            end
        end

        name:SetTextColor(r,g,b)
    end
end

local targeting = CreateFrame("Frame", nil, UIParent)
local name

local function colorToT()
    if UnitExists("target") then        
        targeting:SetScript("OnUpdate", function()
            if UnitExists("targettarget") then        
                if GetUnitName("targettarget") ~= name then
                    name = GetUnitName("targettarget")
                    colorName("targettarget")
                end
            end
        end)
    else
        targeting:SetScript("OnUpdate", nil)
    end
end

module.enable = function(self)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")    
    events:RegisterEvent("PLAYER_TARGET_CHANGED")
    events:RegisterEvent("PARTY_MEMBERS_CHANGED")
    events:RegisterEvent("UNIT_PET")
    events:RegisterEvent("UNIT_COMBAT", "target")

    events:SetScript("OnEvent", function()
        if (event == "PLAYER_ENTERING_WORLD") then
            colorName("player")
            colorName("pet")
        elseif (event == "PLAYER_TARGET_CHANGED") then
            colorName("target")
            colorToT()
        elseif (event == "PARTY_MEMBERS_CHANGED") then
            if (arg1 == "party1") then
                colorName("party1")
            elseif (arg1 == "party2") then
                colorName("party2")
            elseif (arg1 == "party3") then
                colorName("party3")
            elseif (arg1 == "party4") then
                colorName("party4")
            end
        elseif (event == "UNIT_PET") then
            if (arg1 == "pet") then
                colorName("pet")
            elseif (arg1 == "partypet1") then
                colorName("partypet1")
            elseif (arg1 == "partypet2") then
                colorName("partypet2")
            elseif (arg1 == "partypet3") then
                colorName("partypet3")
            elseif (arg1 == "partypet4") then
                colorName("partypet4")
            end
        end
    end)
    
    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")    
    events:RegisterEvent("UNIT_HEALTH")

    events:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            ShaguPlates()
        elseif event == "UNIT_HEALTH" then
            Healthbar(arg1)
        end
    end)

end