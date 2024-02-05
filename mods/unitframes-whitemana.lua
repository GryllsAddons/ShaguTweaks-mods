local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Unit Frame White Mana"],
    description = T["Changes unit frame mana color to white."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Unit Frames"],
    enabled = nil,
})

module.enable = function(self)
    local HookUnitFrame_UpdateManaType = UnitFrame_UpdateManaType
    function UnitFrame_UpdateManaType(uf)
        HookUnitFrame_UpdateManaType(uf)
        if not uf then uf = this end
        local mb = uf.unit and uf.manabar
        if not mb then return end

        if (UnitPowerType(uf.unit) == 0) then
            mb:SetStatusBarColor(1, 1, 1)
        end
    end
end