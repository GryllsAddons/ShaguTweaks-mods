local module = ShaguTweaks:register({
  title = "Unit Frame Name Colors",
  description = "Adds class and pet coloring (if Warlock or Hunter pet) to the unitframes.",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)

    local function colorName(unit)
        local frame
        if unit == "player" then
            frame = PlayerFrame
        elseif unit == "pet" then
            frame = PetFrame
        elseif unit == "target" then
            frame = TargetFrame
        elseif unit == "targettarget" then
            frame = TargetofTargetFrame
        elseif unit == "party1" then
            frame = PartyMemberFrame1
        elseif unit == "party2" then
            frame = PartyMemberFrame2
        elseif unit == "party3" then
            frame = PartyMemberFrame3
        elseif unit == "party4" then
            frame = PartyMemberFrame4
        elseif unit == "partypet1" then
            frame = PartyMemberFrame1PetFrame
        elseif unit == "partypet2" then
            frame = PartyMemberFrame2PetFrame
        elseif unit == "partypet3" then
            frame = PartyMemberFrame3PetFrame
        elseif unit == "partypet4" then
            frame = PartyMemberFrame4PetFrame
        else
            -- unit not found
            frame = null
        end

        if frame ~= null then
            local name -- implicit name = nil
            -- set name to the frame name
            if (unit == "targettarget") then
                name = TargetofTargetName
            elseif (unit == "pet") then
                name = PetName
            else
                name = frame.name
            end

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
    
    

    local namecolor = CreateFrame("Frame", nil, UIParent)
    namecolor:RegisterEvent("PLAYER_ENTERING_WORLD")    
    namecolor:RegisterEvent("PLAYER_TARGET_CHANGED")
    namecolor:RegisterEvent("PARTY_MEMBERS_CHANGED")
    namecolor:RegisterEvent("UNIT_PET", "player")

    namecolor:SetScript("OnEvent", function()
        if (event == "PLAYER_ENTERING_WORLD") then
            colorName("player")
        elseif (event == "PLAYER_TARGET_CHANGED") then
            colorName("target")
            colorName("targettarget")
            -- update targettarget color on mana bar value changed
            TargetofTargetManaBar:SetScript("OnValueChanged", function()        
                colorName("targettarget")
                -- TargetofTargetHealthBar:SetScript("OnValueChanged", nil)
            end)
        elseif (event == "PARTY_MEMBERS_CHANGED") then
            if (arg1 == "pet") then
                colorName("pet")
            elseif (arg1 == "party1") then
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

end