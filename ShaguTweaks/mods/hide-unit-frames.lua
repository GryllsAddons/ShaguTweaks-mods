local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Hide Unit Frames",
    description = "Hide the player and pet frame if full health & mana, happy, no target and out of combat. Show on mouseover.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
})

module.enable = function(self)
    local frames = { PlayerFrame, PetFrame }

    local function ShowFrames()
        for _, frame in pairs(frames) do
            frame:Show()
        end
    end

    local function HideFrames()
        for _, frame in pairs(frames) do
            frame:Hide()
        end
    end

    local function isCasting()
        if CastingBarFrame.casting or CastingBarFrame.channeling then return true end
    end

    local function FullHealth(unit)
        if UnitHealth(unit) == UnitHealthMax(unit) then return true end
    end

    local function FullMana(unit)
        local powerType = UnitPowerType(unit)
        if not (powerType == 0 or powerType == 3) then return true end  -- 0 = mana, 3 = energy
        if UnitMana(unit) == UnitManaMax(unit) then return true end
    end

    local function HappyPet()
        if (UnitCreatureType("pet") == "Beast") and (GetPetHappiness() > 1) then return true end
    end

    local function PetConditions()
        if not UnitExists("pet") then return true end
        if HappyPet() and FullHealth("pet") then return true end
    end

    local function PlayerConditions()
        local fullhealth = FullHealth("player")
        local fullmana = FullMana("player")
        local notcasting = not isCasting()
        local ooc = not UnitAffectingCombat("player")

        if fullhealth and fullmana and notcasting and ooc then return true end
    end

    local function CheckConditions()
        local notarget = not UnitExists("target")
        local player = PlayerConditions()
        local pet = PetConditions()

        if notarget and player and pet then 
            HideFrames()
        else
            ShowFrames()
        end
    end

    local function overlay(parent)
        local f = CreateFrame("Button")
        f:SetAllPoints(parent)
        f:EnableMouse(true)
        f:RegisterForClicks('LeftButtonUp', 'RightButtonUp',
        'MiddleButtonUp', 'Button4Up', 'Button5Up')

        f:SetScript("OnEnter", function()
            parent:Show()
        end)

        f:SetScript("OnLeave", function()
            this:Show()
            CheckConditions()       
        end)

        f:SetScript("OnClick", function()
            this:Hide()
            _G[parent:GetName().."_OnClick"](arg1)
        end)
    end

    for _, frame in pairs(frames) do
        overlay(frame)
    end

    local events = CreateFrame("Frame", nil, UIParent)	
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("PLAYER_TARGET_CHANGED")
    events:RegisterEvent("UNIT_HEALTH", "player")
    events:RegisterEvent("UNIT_HEALTH", "pet")
    events:RegisterEvent("UNIT_MANA", "player")
    events:RegisterEvent("UNIT_ENERGY", "player")
    events:RegisterEvent("SPELLCAST_START")
    events:RegisterEvent("SPELLCAST_CHANNEL_START")
    events:RegisterEvent("SPELLCAST_STOP")
    events:RegisterEvent("SPELLCAST_FAILED")
    events:RegisterEvent("SPELLCAST_INTERRUPTED")
    events:RegisterEvent("SPELLCAST_CHANNEL_STOP")
    events:RegisterEvent("PLAYER_REGEN_DISABLED") -- in combat
    events:RegisterEvent("PLAYER_REGEN_ENABLED") -- out of combat
    events:RegisterEvent("UNIT_PET")    

    events:SetScript("OnEvent", function()
        CheckConditions()
    end)
end