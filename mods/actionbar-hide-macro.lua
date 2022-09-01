
local _G = _G or getfenv(0)

local module = ShaguTweaks:register({
    title = "Hide Macro Text",
    description = "Hides macro text",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
  })

-- Based on zUI skinning (https://github.com/Ko0z/zUI)
-- Credit to Ko0z (https://github.com/Ko0z/)

local function macros()
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
  
module.enable = function(self)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        macros()
    end)
    
end