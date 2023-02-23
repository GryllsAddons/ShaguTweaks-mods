local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
    title = "Unit Frame White Mana",
    description = "Changes unit frame mana color to white.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
})

module.enable = function(self)    
    hooksecurefunc("UnitFrame_UpdateManaType", function(unitFrame)
        if not unitFrame then return end
        if not UnitExists(unitFrame.unit) and UnitHealth(unitFrame.unit) > 0 and UnitIsConnected(unitFrame.unit) then return end
        if UnitPowerType(unitFrame.unit) == 0 then unitFrame.manabar:SetStatusBarColor(1, 1, 1) end
    end, true)
end