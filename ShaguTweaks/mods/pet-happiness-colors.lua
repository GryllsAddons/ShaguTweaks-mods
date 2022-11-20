local module = ShaguTweaks:register({
  title = "Pet Happiness Colors",
  description = "Colors Hunter pet healthbar by happiness.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)
  local _, class = UnitClass("player")
  if not (class == "HUNTER") then return end

  local function color(unit)
    if (not UnitExists(unit)) or UnitIsDead(unit) or UnitIsGhost(unit) then return end
    -- credit to KoOz (https://github.com/Ko0z/UnitFramesImproved_Vanilla)
    local happiness = GetPetHappiness()
    if (happiness == 3) then
      PetFrameHealthBar:SetStatusBarColor(0,1,0)
    elseif (happiness == 2) then
      PetFrameHealthBar:SetStatusBarColor(1,1,0)
    else
      PetFrameHealthBar:SetStatusBarColor(1,0,0)
    end
  end

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("UNIT_PET", "player")
  events:RegisterEvent("UNIT_LOYALTY")
  events:RegisterEvent("UNIT_HAPPINESS")
  events:SetScript("OnEvent", function()
    color("pet")
  end)
end
