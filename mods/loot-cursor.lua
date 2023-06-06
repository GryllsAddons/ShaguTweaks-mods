local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Loot Cursor",
    description = "Moves the loot frame under the mouse cursor.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Tooltip & Items",
    enabled = nil,
})

module.enable = function(self)
    local function cursor()
        local button = _G["LootButton1"]
        if button:IsVisible() then
            local x, y = GetCursorPosition()
            local scale = LootFrame:GetEffectiveScale()                
            local p = button:GetWidth() / 2
            button:ClearAllPoints()
            button:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x/scale - p, y/scale + p)
            LootFrame:ClearAllPoints()
            LootFrame:SetPoint("TOPLEFT", button, "BOTTOMLEFT", -24, 118)                
        end
    end
    
    local loot = CreateFrame("Frame", nil, LootFrame)
    loot:RegisterEvent("LOOT_OPENED")
    loot:RegisterEvent("LOOT_SLOT_CLEARED")
    loot:SetScript("OnEvent", cursor)
end

