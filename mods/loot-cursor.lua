local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Loot Cursor"],
    description = T["Moves the loot frame under the mouse cursor."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Tooltip & Items"],
    enabled = nil,
})

module.enable = function(self)
    local loot = CreateFrame("Frame", "ShaguTweaksLoot", LootFrame)
    loot:SetScript("OnUpdate", function()
    if GetNumLootItems() == 0 then HideUIPanel(LootFrame) return end

    local x, y = GetCursorPosition()
        local s = LootFrame:GetEffectiveScale()
        x, y  = x / s, y / s

        for i = 1, LOOTFRAME_NUMBUTTONS, 1 do
            local button = getglobal("LootButton"..i)
            if button:IsVisible() then

            if loot.last_button ~= button then
                local button_offset = (i-1) * button:GetHeight()
            LootFrame:ClearAllPoints()
                LootFrame:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", x - 40, y + 100 + button_offset)
                loot.last_button = button
            end

            return
            end
        end
    end)

    loot:SetScript("OnShow", function()
    loot.last_button = nil
    end)
end

