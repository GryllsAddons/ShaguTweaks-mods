local module = ShaguTweaks:register({
  title = "Color Names",
  description = "Adds class and pet coloring to the unitframes",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)

    local function colorNames(unit)
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

    local colornames = CreateFrame("Frame", nil, UIParent)
    colornames:RegisterEvent("PLAYER_ENTERING_WORLD")    
    colornames:RegisterEvent("PLAYER_TARGET_CHANGED")
    colornames:RegisterEvent("PARTY_MEMBERS_CHANGED")
    colornames:RegisterEvent("UNIT_PET", "player")

    colornames:SetScript("OnEvent", function()
        if (event == "PLAYER_ENTERING_WORLD") then
            colorNames("player")
        elseif (event == "PLAYER_TARGET_CHANGED") then
            colorNames("target")
            colorNames("targettarget")
            -- update targettarget color on mana bar value changed
            TargetofTargetManaBar:SetScript("OnValueChanged", function()        
                colorNames("targettarget")
                -- TargetofTargetHealthBar:SetScript("OnValueChanged", nil)
            end)
        elseif (event == "PARTY_MEMBERS_CHANGED") then
            if (arg1 == "pet") then
                colorNames("pet")
            elseif (arg1 == "party1") then
                colorNames("party1")
            elseif (arg1 == "party2") then
                colorNames("party2")
            elseif (arg1 == "party3") then
                colorNames("party3")
            elseif (arg1 == "party4") then
                colorNames("party4")
            end
        elseif (event == "UNIT_PET") then
            if (arg1 == "pet") then
                colorNames("pet")
            elseif (arg1 == "partypet1") then
                colorNames("partypet1")
            elseif (arg1 == "partypet2") then
                colorNames("partypet2")
            elseif (arg1 == "partypet3") then
                colorNames("partypet3")
            elseif (arg1 == "partypet4") then
                colorNames("partypet4")
            end      
        end
    end)

end