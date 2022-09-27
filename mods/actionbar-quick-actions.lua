local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
    title = "Quick Actions",
    description = "Action buttons will be activated on key down.",
    expansions = { ["vanilla"] = true, ["tbc"] = true },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    hooksecurefunc("ActionButtonDown", function(id)
        ActionButtonUp(id)
        if ( BonusActionBarFrame:IsShown() ) then
            local button = getglobal("BonusActionButton"..id)            
            button:SetChecked(1)
        end
        local button = getglobal("ActionButton"..id)        
        button:SetChecked(1)
    end, true)

    hooksecurefunc("ActionButtonUp", function(id)
        if ( BonusActionBarFrame:IsShown() ) then
            local button = getglobal("BonusActionButton"..id)
            button:SetChecked(0)
        end
        local button = getglobal("ActionButton"..id)    
        button:SetChecked(0)
    end, true)

    hooksecurefunc("MultiActionButtonDown", function(bar, id)
        MultiActionButtonUp(bar, id)
        local button = getglobal(bar.."Button"..id)
        button:SetChecked(1)
    end, true)

    hooksecurefunc("MultiActionButtonUp", function(bar, id, onSelf)
        local button = getglobal(bar.."Button"..id)
        button:SetChecked(0)
    end, true)

    hooksecurefunc("PetActionButtonDown", function(id)
        local button = getglobal("PetActionButton"..id)
        if ( button:GetButtonState() == "NORMAL" ) then
            button:SetButtonState("PUSHED")
            CastPetAction(id)
        end
    end)

    hooksecurefunc("PetActionButtonUp", function(id)
        local button = getglobal("PetActionButton"..id)
        if ( button:GetButtonState() == "PUSHED" ) then
            button:SetButtonState("NORMAL")
        end
    end)
end