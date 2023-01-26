local module = ShaguTweaks:register({
    title = "Hide Hotkey Text",
    description = "Hides hotkey text",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})
  
module.enable = function(self)
    local _G = ShaguTweaks.GetGlobalEnv()
    
    local function hidehotkeys(button)
        if not button then return end

        local hotkey = _G[button:GetName().."HotKey"]
        if hotkey then
            hotkey:SetAlpha(0)
        end
    end
    
    for i = 1, 24 do
        local button = _G['BonusActionButton'..i]
        if button then
            hidehotkeys(button)
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
            hidehotkeys(button)
        end        
    end 

    for i = 1, 10 do
        for _, button in pairs(
            {
                _G['ShapeshiftButton'..i],
                _G['PetActionButton'..i]
            }
        ) do
            hidehotkeys(button)
        end
    end
end
