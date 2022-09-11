local _G = _G or getfenv(0)
local Abbreviate = ShaguTweaks.Abbreviate
local GetColorGradient = ShaguTweaks.GetColorGradient
local vanilla = ShaguTweaks.GetExpansion() == "vanilla" or nil

local module = ShaguTweaks:register({
  title = "Pet Happiness Colors",
  description = "Colors the pet healthbar by happiness.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)
  local function happiness()
    local _, class = UnitClass("player")
    if not (class == "HUNTER") then return end

    local function color(arg1)
      if not (UnitIsDead(unit) or UnitIsGhost(unit)) then
          -- credit to KoOz (https://github.com/Ko0z/UnitFramesImproved_Vanilla)
          local happiness, damagePercentage, loyaltyRate = GetPetHappiness()
          if (happiness == 3) then
              HealthBar:SetStatusBarColor(0,1,0)
          elseif (happiness == 2) then
              HealthBar:SetStatusBarColor(1,1,0)
          else
              HealthBar:SetStatusBarColor(1,0,0)
          end
      end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("UNIT_HEALTH", "player")

    events:SetScript("OnEvent", function()
      color(arg1)
    end)
  end

  happiness()
end
