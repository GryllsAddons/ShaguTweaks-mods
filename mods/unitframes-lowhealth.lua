local _G = _G or getfenv(0)
local GetUnitData = ShaguTweaks.GetUnitData

local module = ShaguTweaks:register({
  title = "Low Health",
  description = "Changes the nameplate health bar and unitframe healthbar colors when at 20% health or lower. Also adds Hunter pet healthbar coloring by happiness.",
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)

  local function lowhealth_ShaguPlates()
    if ShaguPlates then return end

    table.insert(ShaguTweaks.libnameplate.OnUpdate, function()
      local function GetUnitType(red, green, blue)
        if red > .9 and green < .2 and blue < .2 then
          return "ENEMY_NPC"
        elseif red > .9 and green > .9 and blue < .2 then
          return "NEUTRAL_NPC"
        elseif red < .2 and green < .2 and blue > 0.9 then
          return "FRIENDLY_PLAYER"
        elseif red < .2 and green > .9 and blue < .2 then
          return "FRIENDLY_NPC"
        end
      end

      local hp = this.healthbar:GetValue()
      local hpmin, hpmax = this.healthbar:GetMinMaxValues()
      local percent = hp / hpmax
      local name = this.name:GetText()
      local _, _, _, player = GetUnitData(name, true)

      local red, green, blue = this.healthbar:GetStatusBarColor()
      local unittype = GetUnitType(red, green, blue) or "ENEMY_NPC"
      if player and unittype == "ENEMY_NPC" then unittype = "ENEMY_PLAYER" end
      
      if percent <= 0.2 then
        if unittype == "ENEMY_NPC" or "ENEMY_PLAYER" or "NEUTRAL_NPC" then        
          this.healthbar:SetStatusBarColor(255/255, 128/255, 0/255) -- legendary orange
        elseif unittype == "FRIENDLY_NPC" or "FRIENDLY_PLAYER" then
          this.healthbar:SetStatusBarColor(0/255, 204/255, 255/255) -- Blizzard Blue
        end
      else
        this.healthbar:SetStatusBarColor(red, green, blue)
      end
    end)
  end

  local function lowhealth_healthbar(unit)

    local HealthBar = null
    -- color health bar based on health
    if unit == "player" then
        HealthBar = PlayerFrameHealthBar
    elseif unit == "pet" then
        HealthBar = PetFrameHealthBar
    elseif unit == "target" then
        HealthBar = TargetFrameHealthBar
    elseif unit == "targettarget" then
        HealthBar = TargetofTargetHealthBar
    elseif unit == "party1" then
        HealthBar = PartyMemberFrame1HealthBar
    elseif unit == "party2" then
        HealthBar = PartyMemberFrame2HealthBar
    elseif unit == "party3" then
        HealthBar = PartyMemberFrame3HealthBar
    elseif unit == "party4" then
        HealthBar = PartyMemberFrame4HealthBar
    elseif unit == "partypet1" then
        HealthBar = PartyMemberFrame1PetFrameHealthBar
    elseif unit == "partypet2" then
        HealthBar = PartyMemberFrame2PetFrameHealthBar
    elseif unit == "partypet3" then
        HealthBar = PartyMemberFrame3PetFrameHealthBar
    elseif unit == "partypet4" then
        HealthBar = PartyMemberFrame4PetFrameHealthBar
    else
        -- unit not found
    end

    if HealthBar ~= null then
        if not (UnitIsDead(unit) or UnitIsGhost(unit)) then
            if unit == "pet" then
                -- credit to KoOz (https://github.com/Ko0z/UnitFramesImproved_Vanilla) for code below
                -- pet health bar happiness coloring
                local _, class = UnitClass("player")
                if class == 'HUNTER' then
                    local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
                    if (happiness == 3) then
                        HealthBar:SetStatusBarColor(0,1,0)
                    elseif (happiness == 2) then
                        HealthBar:SetStatusBarColor(1,1,0)
                    else
                        HealthBar:SetStatusBarColor(1,0,0)
                    end
                end
            else
                -- credit to Shagu (https://github.com/shagu/ShaguPlates) for code below
                local function GetUnitType(red, green, blue)
                    if red > .9 and green < .2 and blue < .2 then
                    return "ENEMY_NPC"
                    elseif red > .9 and green > .9 and blue < .2 then
                    return "NEUTRAL_NPC"
                    elseif red < .2 and green < .2 and blue > 0.9 then
                    return "FRIENDLY_PLAYER"
                    elseif red < .2 and green > .9 and blue < .2 then
                    return "FRIENDLY_NPC"
                    end
                end

                local hp = UnitHealth(unit)
                local hpmax = UnitHealthMax(unit)
                local percent = hp / hpmax
                local player = UnitIsPlayer(unit)

                local red, green, blue = HealthBar:GetStatusBarColor()
                local unittype = GetUnitType(red, green, blue) or "ENEMY_NPC"
                if player and unittype == "ENEMY_NPC" then unittype = "ENEMY_PLAYER" end

                if percent <= 0.2 then
                    if unittype == "ENEMY_NPC" or "ENEMY_PLAYER" or "NEUTRAL_NPC" then
                        HealthBar:SetStatusBarColor(255/255, 128/255, 0/255) -- legendary orange
                    elseif unittype == "FRIENDLY_NPC" or "FRIENDLY_PLAYER" then
                        HealthBar:SetStatusBarColor(0/255, 204/255, 255/255) -- Blizzard blue
                    end
                else
                    HealthBar:SetStatusBarColor(red, green, blue)
                end
            end
        end
    end
  end

  local lowhealth = CreateFrame("Frame", nil, UIParent)
  lowhealth:RegisterEvent("PLAYER_ENTERING_WORLD")    
  lowhealth:RegisterEvent("UNIT_HEALTH")

  lowhealth:SetScript("OnEvent", function()
      if event == "PLAYER_ENTERING_WORLD" then
        lowhealth_ShaguPlates()
      elseif event == "UNIT_HEALTH" then
        lowhealth_healthbar(arg1)
      end
  end)

end