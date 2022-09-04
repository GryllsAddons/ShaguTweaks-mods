local module = ShaguTweaks:register({
    title = "Unit Frame Name Class Colors",
    description = "Adds name class colors to the player, pet, target, tot and party unit frames.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
})

module.enable = function(self)
    local _G = _G or getfenv(0)

    local function partycolors()
        for id = 1, MAX_PARTY_MEMBERS do
            local name = _G['PartyMemberFrame'..id..'Name']
            local _, class = UnitClass("party" .. id)
            local class = RAID_CLASS_COLORS[class] or { r = 255/255, g = 210/255, b = 0/255, a = 1 }
            name:SetTextColor(class.r, class.g, class.b, 1)
        end
    end

    local function playercolor()
        local name = PlayerFrame.name
        local _, class = UnitClass("player")
	    local class = RAID_CLASS_COLORS[class]
        name:SetTextColor(class.r, class.g, class.b, 1)
    end

    local function playerpetcolor()
        local name = PetName
        local _, class = UnitClass("player")
	    local class = RAID_CLASS_COLORS[class]
        name:SetTextColor(class.r, class.g, class.b, 1)
    end

    local function targetcolor(unit)
        local name
        if unit == "target" then
            name = TargetFrame.name
        elseif unit == "targettarget" then
            name = TargetofTargetName
        end
        if not name then return end
        
        if UnitIsPlayer(unit) then            
            local _, class = UnitClass(unit)
            local class = RAID_CLASS_COLORS[class]
            name:SetTextColor(class.r, class.g, class.b, 1)
        else
            if UnitIsFriend("player", unit) then
                local creatureType = UnitCreatureType(unit)
                local class = { r = 255/255, g = 210/255, b = 0/255, a = 1 }
                if creatureType == "Demon" then
                    class = RAID_CLASS_COLORS["WARLOCK"]                    
                elseif creatureType == "Beast" then
                    class = RAID_CLASS_COLORS["HUNTER"]
                end
                name:SetTextColor(class.r, class.g, class.b, 1)
            else
                local r,g,b = GameTooltip_UnitColor(unit)
                name:SetTextColor(r,g,b)
            end 
        end
    end

    local targeting = CreateFrame("Frame", nil, UIParent)
    local name
    local function totcolor()
        if UnitExists("target") then        
            targeting:SetScript("OnUpdate", function()
                if UnitExists("targettarget") then        
                    if GetUnitName("targettarget") ~= name then
                        name = GetUnitName("targettarget")
                        targetcolor("targettarget")
                    end
                end
            end)
        else
            targeting:SetScript("OnUpdate", nil)
        end
    end    

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")    
    events:RegisterEvent("PLAYER_TARGET_CHANGED")
    events:RegisterEvent("PARTY_MEMBERS_CHANGED")
    events:RegisterEvent("UNIT_PET", "player")

    events:SetScript("OnEvent", function()
        if (event == "PLAYER_ENTERING_WORLD") then        
            playercolor()
            playerpetcolor()
            partycolors()
        elseif (event == "PLAYER_TARGET_CHANGED") then
            targetcolor("target")
            totcolor()
        elseif (event == "UNIT_PET") then
            playerpetcolor()
        elseif (event == "PARTY_MEMBERS_CHANGED") then
            partycolors()
        end
    end)
end
