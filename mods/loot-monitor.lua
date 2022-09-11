local module = ShaguTweaks:register({
    title = "Loot Monitor",
    description = "Display recent loot messages in a central scrolling window. Hold ALT while using the mouse wheel over the window to scroll. Hold ALT and SHIFT then scroll down to go to the bottom of the window. The window will auto scroll back to the bottom after 10 seconds.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    local loot = CreateFrame("ScrollingMessageFrame")
    loot:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 0, 0)
    loot:SetWidth(400)
    loot:SetHeight(70) -- 5 lines
    
    -- loot:SetFontObject(GameTooltipTextSmall)
    loot.text = loot:CreateFontString(nil, "HIGH", "GameTooltipTextSmall")
    local font, size, opts = loot.text:GetFont()
    loot:SetFont(font, size, "OUTLINE")
    loot:SetJustifyH("CENTER")

    local timer = CreateFrame("FRAME", nil, loot)
    timer:Hide()

    local scrollspeed = 1
    local function ChatOnMouseWheel()
        if arg1 > 0 then
          if IsShiftKeyDown() then
            this:ScrollToTop()
          else
            for i=1, scrollspeed do
              this:ScrollUp()
            end
          end
        elseif arg1 < 0 then
          if IsShiftKeyDown() then
            this:ScrollToBottom()
          else
            for i=1, scrollspeed do
              this:ScrollDown()
            end
          end
        end
    end
    
    loot:EnableMouseWheel(true)
    loot:SetScript("OnMouseWheel", function()
        if IsAltKeyDown() then
            ChatOnMouseWheel()
        end   
        
        timer:Show()
        timer.time = GetTime() + 10

        timer:SetScript("OnUpdate", function()
            if GetTime() > timer.time then
                loot:ScrollToBottom()
                timer:Hide()
            end
        end)             
    end)

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
