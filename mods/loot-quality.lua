local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Loot Quality"],
    description = T["Sets the loot frame color to the highest item quality."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Tooltip & Items"],
    enabled = nil,
})

module.enable = function(self)
    local loot = CreateFrame("Frame", nil, LootFrame)

    loot.border = LootFrame:CreateTexture(nil, "OVERLAY")
    loot.border:SetTexture("Interface\\LootFrame\\UI-LootPanel")

    loot.highlight = LootFrame:CreateTexture(nil, "OVERLAY")
    loot.highlight:SetTexture("Interface\\LootFrame\\UI-LootPanel")
    
    loot.border:SetPoint("TOPLEFT", LootFrame, "TOPLEFT", -4, 3)
    loot.border:SetPoint("BOTTOMRIGHT", LootFrame, "BOTTOMRIGHT", 5, -3)
    loot.highlight:SetAllPoints(loot.border)

    loot.border:SetDrawLayer("ARTWORK")
    loot.highlight:SetDrawLayer("ARTWORK")

    loot.highlight:SetBlendMode("ADD")

    local function lootShow()
        loot.border:Show()
        loot.highlight:Show()
    end

    local function lootHide()
        loot.border:Hide()
        loot.highlight:Hide()
    end

    local function lootTextColor(r,g,b)
        for _, region in pairs({LootFrame:GetRegions()}) do
            if region.GetText and region:GetText() == ITEMS then
                    region:SetTextColor(r,g,b)
                break
            end
        end
    end

    local function lootColor(r,g,b)
        loot.border:SetVertexColor(r,g,b)
        loot.highlight:SetVertexColor(r,g,b)
        lootShow()
        lootTextColor(r,g,b)
    end

    local function quality()
        lootHide()

        local minQuality = 2 -- uncommon/green
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

        if highestQuality >= minQuality then
            local color = ITEM_QUALITY_COLORS[highestQuality]        
            lootColor(color.r,color.g,color.b)
        else
            lootTextColor(1,.82,0)
        end
    end
    
    local loot = CreateFrame("Frame", nil, LootFrame)
    loot:RegisterEvent("LOOT_OPENED")
    loot:RegisterEvent("LOOT_SLOT_CLEARED")
    loot:SetScript("OnEvent", quality)
end