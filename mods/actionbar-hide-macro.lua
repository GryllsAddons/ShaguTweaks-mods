local module = ShaguTweaks:register({
    title = "Hide Macro Text",
    description = "Hides macro text",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})
  
module.enable = function(self)
    local _G = ShaguTweaks.GetGlobalEnv()

    local function hidemacros(button)
        if not button then return end

        local macro = _G[button:GetName().."Name"]  
        if macro then
            macro:SetAlpha(0)
        end
    end
    
    for i = 1, 24 do
        local button = _G['BonusActionButton'..i]
        if button then
            hidemacros(button)
        end
    end

    for i = 1, 12 do
        for _, button in pairs(
                {
                _G['ActionButton'..i],
                _G['MultiBarRightButton'..i],
                _G['MultiBarLeftButton'..i],
                _G['MultiBarBottomLeftButton'..i],
                _G['MultiBarBottomRightButton'..i],
            }
        ) do
            hidemacros(button)
        end
    end
end
