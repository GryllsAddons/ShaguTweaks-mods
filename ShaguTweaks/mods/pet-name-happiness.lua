local module = ShaguTweaks:register({
  title = "Pet Name Happiness",
  description = "Colors Hunter pet name by happiness level.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)
  local _, class = UnitClass("player")
  if not (class == "HUNTER") then return end

  local function PetColor()
    if not UnitExists("pet") then return end

    local happiness = GetPetHappiness()
    if (happiness == 3) then
      PetName:SetTextColor(0,1,0)
    elseif (happiness == 2) then
      PetName:SetTextColor(1,1,0)
    else
      PetName:SetTextColor(1,0,0)
    end
  end

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("UNIT_PET", "player")
  events:RegisterEvent("UNIT_LOYALTY")
  events:RegisterEvent("UNIT_HAPPINESS")
  events:SetScript("OnEvent", function()
    PetColor()
  end)
end
