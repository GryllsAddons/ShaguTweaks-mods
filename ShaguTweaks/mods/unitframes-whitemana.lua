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
        if (not unitFrame) or (not UnitExists(unitFrame.unit)) or UnitIsDeadOrGhost(unitFrame.unit) or (not UnitIsConnected(unitFrame.unit)) then return end
        if UnitPowerType(unitFrame.unit) == 0 then unitFrame.manabar:SetStatusBarColor(1, 1, 1) end
    end, true)
end