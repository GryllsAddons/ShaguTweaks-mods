local _G = ShaguTweaks.GetGlobalEnv()
local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
    title = "Quick Actions",
    description = "Action buttons will be activated on key down.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    hooksecurefunc("ActionButtonDown", function(id)
        ActionButtonUp(id)
        if ( BonusActionBarFrame:IsShown() ) then
            local button = _G["BonusActionButton"..id]      
            button:SetChecked(1)
        end
        local button = _G["ActionButton"..id]      
        button:SetChecked(1)
    end, true)

    hooksecurefunc("ActionButtonUp", function(id)
        if ( BonusActionBarFrame:IsShown() ) then
            local button = _G["BonusActionButton"..id]
            button:SetChecked(0)
        end
        local button = _G["ActionButton"..id]    
        button:SetChecked(0)
    end, true)

    hooksecurefunc("MultiActionButtonDown", function(bar, id)
        MultiActionButtonUp(bar, id)
        local button = _G[bar.."Button"..id]
        button:SetChecked(1)
    end, true)

    hooksecurefunc("MultiActionButtonUp", function(bar, id, onSelf)
        local button = _G[bar.."Button"..id]
        button:SetChecked(0)
    end, true)

    hooksecurefunc("PetActionButtonDown", function(id)
        local button = _G["PetActionButton"..id]
        if ( button:GetButtonState() == "NORMAL" ) then
            button:SetButtonState("PUSHED")
            CastPetAction(id)
        end
    end)

    hooksecurefunc("PetActionButtonUp", function(id)
        local button = _G["PetActionButton"..id]
        if ( button:GetButtonState() == "PUSHED" ) then
            button:SetButtonState("NORMAL")
        end
    end)
end
