local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["Pet Name Happiness"],
  description = T["Colors Hunter pet name by happiness level."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["Unit Frames"],
  enabled = nil,
})

module.enable = function(self)
  local HookPetFrame_SetHappiness = PetFrame_SetHappiness
  function PetFrame_SetHappiness()
    HookPetFrame_SetHappiness()
    local happiness = GetPetHappiness()
    local _, isHunterPet = HasPetUI()
    if ( not happiness or not isHunterPet ) then return end
      
    if (happiness == 1) then -- unhappy
      PetName:SetTextColor(1,0,0)
    elseif (happiness == 2) then -- content
      PetName:SetTextColor(1,1,0)
    elseif (happiness == 3) then -- happy
      PetName:SetTextColor(0,1,0)
    end
  end
end