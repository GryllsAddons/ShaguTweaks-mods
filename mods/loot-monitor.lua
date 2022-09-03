local module = ShaguTweaks:register({
    title = "Loot Monitor",
    description = "Display recent loot messages.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    local loot = CreateFrame("ScrollingMessageFrame")
    loot:SetPoint("TOP", UIParent, "TOP", 0, -150)
    -- loot:SetFontObject(GameTooltipTextSmall)
    loot.text = loot:CreateFontString(nil, "HIGH", "GameFontWhite")
    local font, size, opts = loot.text:GetFont()
    loot:SetFont(font, size, "OUTLINE")

    loot:SetJustifyH("CENTER")
    loot:SetHeight(100)
    loot:SetWidth(300)

    local function AddLootMessage(msg)
        local GetUnitData = ShaguTweaks.GetUnitData
        -- local rgbhex = ShaguTweaks.rgbhex
        local strsplit = ShaguTweaks.strsplit
        local class
        local lootYou = "You receive loot"
        local lootOther = " receives loot"

        if string.find(msg, lootYou) then
            class = GetUnitData(GetUnitName("player"))
            msg = string.gsub(msg, lootYou, "You")
        elseif string.find(msg, lootOther) then
            local real, _ = strsplit(" ", msg) -- get first word (player name)
            class = GetUnitData(real)
            msg = string.gsub(msg, real..lootOther, real)
        end

        if class and class ~= UNKNOWN then
            -- color = rgbhex(RAID_CLASS_COLORS[class])
            local color = RAID_CLASS_COLORS[class]
            msg = string.sub(msg, 1, -2) -- remove last character (".")
            loot:AddMessage(msg, color.r, color.g, color.b)
        end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("CHAT_MSG_LOOT")

    events:SetScript("OnEvent", function()
        AddLootMessage(arg1)
    end)
end