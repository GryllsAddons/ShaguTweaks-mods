local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
  title = "Pet Name Happiness",
  description = "Colors Hunter pet name by happiness level.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

module.enable = function(self)
  local function PetNameColor()
    local happiness = GetPetHappiness()
    local _, isHunterPet = HasPetUI();
    if ( not happiness or not isHunterPet ) then return end
      
    if (happiness == 1) then -- unhappy
      PetName:SetTextColor(1,0,0)
    elseif (happiness == 2) then -- content
      PetName:SetTextColor(1,1,0)
    elseif (happiness == 3) then -- happy
      PetName:SetTextColor(0,1,0)
    end
  end

  hooksecurefunc("PetFrame_SetHappiness", PetNameColor, true)
end