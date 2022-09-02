local module = ShaguTweaks:register({
    title = "Unit Frame Energy Tick",
    description = "Adds an energy tick to the player frame.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
  })

local modLoaded

local function UpdateTick()
    -- code based on EnergyWatch v2
    local energy = UnitMana("player")
    local time = GetTime()
    local sparkPosition = 1
    local powerType = UnitPowerType("player")

    Energy_Tick.tickRate = 2 -- tick once every 2 seconds
    if ( energy > Energy_Tick.energy or time >= Energy_Tick.timerEnd ) then
        Energy_Tick.energy = energy
        Energy_Tick.timerStart = time
        Energy_Tick.timerEnd = time + Energy_Tick.tickRate
    else
        if( energy ~= Energy_Tick.energy ) then
            energy = Energy_Tick.energy
        end
        sparkPosition = ((time - Energy_Tick.timerStart) / (Energy_Tick.timerEnd - Energy_Tick.timerStart)) * Energy_Tick.sparkSize
    end

    Energy_Tick.StatusBar:SetMinMaxValues(Energy_Tick.timerStart, Energy_Tick.timerEnd)
    Energy_Tick.StatusBar:SetValue(time)

    if ( sparkPosition < 1 ) then
        sparkPosition = 1
    end

    Energy_TickSpark.Spark:SetPoint("CENTER", Energy_Tick.StatusBar, "LEFT", sparkPosition, 0)
end

local function CreateTick()
    if not Energy_Tick then
        local Energy_Tick = CreateFrame("Frame", "Energy_Tick", PlayerFrame)
        local Energy_TickSpark = CreateFrame("Frame", "Energy_TickSpark", PlayerFrame)

        local function powerColor()
            local r,g,b
            local powerType = UnitPowerType("player") -- 0 = mana, 1 = rage, 3 = energy
            -- color power text based on power type
            if powerType == 0 then -- mana
                r,g,b = 0/255, 204/255, 255/255 -- Blizzard Blue
            elseif powerType == 1 then -- rage
                r,g,b = 255/255, 107/255, 107/255 -- light Red
            elseif powerType == 2 then -- focus
                r,g,b = 1, 0.5, 0.25
            elseif powerType == 3 then -- energy
                r,g,b = 230/255, 204/255, 128/255 -- artifact gold
            end
            return r,g,b
        end

        Energy_Tick:SetFrameStrata("BACKGROUND")
        Energy_Tick:SetFrameLevel(PlayerFrameManaBar:GetFrameLevel()-1)

        Energy_Tick.StatusBar = CreateFrame("StatusBar", "Energy_TickStatusBar", PlayerFrame)
        Energy_Tick.StatusBar:SetFrameLevel(PlayerFrameManaBar:GetFrameLevel()-1)
        Energy_Tick.StatusBar:SetStatusBarTexture("Interface\\Tooltips\\UI-Tooltip-Background")
        Energy_Tick.StatusBar:SetAllPoints(PlayerFrameManaBar)
        Energy_Tick.StatusBar:SetStatusBarColor(powerColor())
        Energy_Tick.StatusBar:SetAlpha(0.5) -- set to 0 to hide

        Energy_TickSpark.Spark = Energy_TickSpark:CreateTexture(nil, "OVERLAY")
        Energy_TickSpark.Spark:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
        Energy_TickSpark.Spark:SetHeight(12)
        Energy_TickSpark.Spark:SetWidth(32)
        Energy_TickSpark.Spark:SetBlendMode("ADD")
        Energy_TickSpark.Spark:SetVertexColor(powerColor())

        Energy_Tick.timerStart = 0
        Energy_Tick.timerEnd = 0
        Energy_Tick.sparkSize = PlayerFrameManaBar:GetWidth()
        Energy_Tick.energy = UnitMana("player")

        local powerType = UnitPowerType("player")
        if powerType == 0 then -- mana
            Energy_Tick.enabled = true
        elseif powerType == 3 then -- energy
            Energy_Tick.enabled = true
        else
            Energy_Tick.enabled = false
        end
        
        Energy_Tick:Show()
        Energy_TickSpark:Show()
        Energy_Tick:SetScript("OnUpdate", UpdateTick)
    end
end
  
module.enable = function(self)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            if not modLoaded then
                modLoaded = true
                CreateTick()
            end
        end
    end)

end
