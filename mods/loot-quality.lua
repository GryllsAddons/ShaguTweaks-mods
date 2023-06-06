local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Loot Quality",
    description = "Sets the loot frame color to the highest item quality.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Tooltip & Items",
    enabled = nil,
})

module.enable = function(self)
    local function quality()
        local highestQuality = 0
        
        for i = 1, LOOTFRAME_NUMBUTTONS do
            local button = _G["LootButton"..i]
            if LootSlotIsItem(i) then
                local _, _, _, quality = GetLootSlotInfo(i)
                if quality > highestQuality then
                    highestQuality = quality
                end
            end            
        end
        local color = ITEM_QUALITY_COLORS[highestQuality]

        -- LootFramePortraitOverlay:SetVertexColor(color.r, color.g, color.b)
        for _, region in pairs({LootFrame:GetRegions()}) do
            if region.SetVertexColor and region:GetObjectType() == "Texture" then
                region:SetVertexColor(color.r, color.g, color.b)
            end
        end
    end   
    
    local loot = CreateFrame("Frame", nil, LootFrame)
    loot:RegisterEvent("LOOT_OPENED")
    loot:RegisterEvent("LOOT_SLOT_CLEARED")
    loot:SetScript("OnEvent", quality)
end

