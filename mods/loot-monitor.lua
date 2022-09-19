local module = ShaguTweaks:register({
    title = "Loot Monitor",
    description = "Display recent loot text in a central scrolling window. Hold ALT or ALT+Shift while using the mouse wheel over the window to scroll.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    local LootMonitor = CreateFrame("SimpleHTML")
    LootMonitor:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 85, 0)
    LootMonitor:SetWidth(300)
    LootMonitor:SetHeight(50)
    
    LootMonitor.text = LootMonitor:CreateFontString(nil, "HIGH", "GameTooltipTextSmall")
    local font, size, opts = LootMonitor.text:GetFont()
    LootMonitor:SetFont(font, size, "OUTLINE")

    LootMonitor:SetScript("OnHyperlinkClick", function()
      SetItemRef(arg1, arg2, arg3)
    end)

    local LOOT_ITEM = string.gsub(LOOT_ITEM, "%%s|Hitem:%%d:%%d:%%d:%%d|h%[%%s%]|h%%s", "%%s")
    local LOOT_ITEM_SELF = string.gsub(LOOT_ITEM_SELF, "%%s|Hitem:%%d:%%d:%%d:%%d|h%[%%s%]|h%%s", "%%s")
    -- Not used in 1.12:
    -- local LOOT_ITEM_MULTIPLE = string.gsub(LOOT_ITEM_MULTIPLE, "%%s|Hitem:%%d:%%d:%%d:%%d|h%[%%s%]|h%%s", "%%s")    
    -- local LOOT_ITEM_SELF_MULTIPLE = string.gsub(LOOT_ITEM_SELF_MULTIPLE, "%%s|Hitem:%%d:%%d:%%d:%%d|h%[%%s%]|h%%s", "%%s")
    
    LootMonitor.cache = {}
    LootMonitor.cindex = 0   
    LootMonitor.sindex = 5    
    local GetUnitData = ShaguTweaks.GetUnitData
    local strsplit = ShaguTweaks.strsplit
    local _, pclass = UnitClass("player")

    LootMonitor.scan = CreateFrame("Frame", "STLootMonitor", UIParent)
    LootMonitor.scan:RegisterEvent("CHAT_MSG_LOOT")
    LootMonitor.scan:SetScript("OnEvent", function()
      -- constants (https://wowwiki-archive.fandom.com/wiki/Talk:WoW_constants)
      local item = ShaguTweaks.cmatch(arg1, LOOT_ITEM_SELF)
      if item then        
        local player = "You"
        -- DEBUG:
        -- DEFAULT_CHAT_FRAME:AddMessage("LOOT_ITEM_SELF")
        -- DEFAULT_CHAT_FRAME:AddMessage("player = "..tostring(player)..", item = "..tostring(item)..", class = "..tostring(class))
        LootMonitor:AddCache(item, player, pclass)        
        return
      end
      local player, item = ShaguTweaks.cmatch(arg1, LOOT_ITEM)
      if item then
        local class = GetUnitData(player)
        -- DEBUG:
        -- DEFAULT_CHAT_FRAME:AddMessage("LOOT_ITEM")
        -- DEFAULT_CHAT_FRAME:AddMessage("player = "..tostring(player)..", item = "..tostring(item)..", class = "..tostring(class))
        LootMonitor:AddCache(item, player, class)
        return
      end
    end)

    function LootMonitor:AddCache(hyperlink, player, class)      
      local _, _, itemLink = string.find(hyperlink, "(item:%d+:%d+:%d+:%d+)")
      local _, _, itemQuality = GetItemInfo(itemLink)

      -- filter by ItemQuality (https://wowpedia.fandom.com/wiki/Enum.ItemQuality)
      if player == "You" then
        if itemQuality > 0 then
          LootMonitor.cindex = LootMonitor.cindex + 1
          table.insert(LootMonitor.cache, LootMonitor.cindex, hyperlink..","..player..","..class)
          LootMonitor:UpdateLoot(LootMonitor.cindex)
        end
      else
        if itemQuality > 0 then
          LootMonitor.cindex = LootMonitor.cindex + 1
          table.insert(LootMonitor.cache, LootMonitor.cindex, hyperlink..","..player..","..class)
          LootMonitor:UpdateLoot(LootMonitor.cindex)
        end
      end

      -- DEBUG:
      -- DEFAULT_CHAT_FRAME:AddMessage("LootMonitor:AddCache")
      -- DEFAULT_CHAT_FRAME:AddMessage("LootMonitor.cindex = "..LootMonitor.cindex)  
      -- DEFAULT_CHAT_FRAME:AddMessage("AddCache: hyperlink = "..tostring(hyperlink))
      -- DEFAULT_CHAT_FRAME:AddMessage("AddCache: itemQuality = "..tostring(itemQuality))
      -- DEFAULT_CHAT_FRAME:AddMessage("player = "..tostring(player))
      -- DEFAULT_CHAT_FRAME:AddMessage("class = "..tostring(class))    
    end

    function LootMonitor:GetLoot(i)
      if LootMonitor.cindex >= i then      
        local item, player, class = strsplit(",", LootMonitor.cache[i])
        return item, player, class
      else 
        return false
      end
    end

    function LootMonitor:UpdateLoot(i)
      LootMonitor.timer:Show()      
      LootMonitor.timer.time = GetTime() + 15
      local c1, c2, c3, c4, c5 = "", "", "", "", ""
      
      -- most recent on bottom
      local index = i
      if LootMonitor:GetLoot(index) then
        local c5i, c5p, c5c = LootMonitor:GetLoot(index)
        local c5c = RAID_CLASS_COLORS[c5c]
        local color = ShaguTweaks.rgbhex(c5c.r, c5c.g, c5c.b, 1)
        c5 = color..c5p.."|r "..c5i
      end

      index = i-1
      if LootMonitor:GetLoot(index) then
        local c4i, c4p, c4c = LootMonitor:GetLoot(index)
        local c4c = RAID_CLASS_COLORS[c4c]
        local color = ShaguTweaks.rgbhex(c4c.r, c4c.g, c4c.b, 1)
        c4 = color..c4p.."|r "..c4i
      end

      index = i-2
      if LootMonitor:GetLoot(index) then
        local c3i, c3p, c3c = LootMonitor:GetLoot(index)
        local c3c = RAID_CLASS_COLORS[c3c]
        local color = ShaguTweaks.rgbhex(c3c.r, c3c.g, c3c.b, 1)
        c3 = color..c3p.."|r "..c3i
      end

      index = i-3
      if LootMonitor:GetLoot(index) then
        local c2i, c2p, c2c = LootMonitor:GetLoot(index)
        local c2c = RAID_CLASS_COLORS[c2c]
        local color = ShaguTweaks.rgbhex(c2c.r, c2c.g, c2c.b, 1)
        c2 = color..c2p.."|r "..c2i
      end

      index = i-4
      if LootMonitor:GetLoot(index) then
        local c1i, c1p, c1c = LootMonitor:GetLoot(index)
        local c1c = RAID_CLASS_COLORS[c1c]
        local color = ShaguTweaks.rgbhex(c1c.r, c1c.g, c1c.b, 1)
        c1 = color..c1p.."|r "..c1i
      end

      LootMonitor:SetText("<html><body><p>"..c1.."</p><p>"..c2.."</p><p>"..c3.."</p><p>"..c4.."</p><p>"..c5.."</p></body></html>")
      end

    -- scrolling
    local function increment(i)
      LootMonitor.sindex = LootMonitor.sindex + 1
      if LootMonitor.sindex > LootMonitor.cindex then
        LootMonitor.sindex = LootMonitor.cindex        
      end
    end

    local function decrement(i)
      LootMonitor.sindex = LootMonitor.sindex - 1      
      if LootMonitor.sindex < 5 then
        LootMonitor.sindex = 5
      end
    end

    local scrollspeed = 1
    local function LootMonitorOnMouseWheel()
      if arg1 > 0 then -- scroll up
        if IsShiftKeyDown() then
          LootMonitor.sindex = 5
        else
          for i=1, scrollspeed do
          decrement()
          end
        end
      elseif arg1 < 0 then -- scroll down
        if IsShiftKeyDown() then
          LootMonitor.sindex = LootMonitor.cindex
        else
          for i=1, scrollspeed do
            increment()
          end
        end
      end
      LootMonitor:UpdateLoot(LootMonitor.sindex)      
    end

    LootMonitor:EnableMouseWheel(true)
    LootMonitor:SetScript("OnMouseWheel", function()
      if IsAltKeyDown() then
        LootMonitorOnMouseWheel()
      end
    end)

    -- hiding
    LootMonitor.timer = CreateFrame("FRAME", nil, LootMonitor)
    LootMonitor.timer:SetAllPoints(LootMonitor.timer:GetParent())
    LootMonitor.timer:Hide()

    LootMonitor.timer:SetScript("OnUpdate", function()
      if (GetTime() > LootMonitor.timer.time) then
        LootMonitor:SetAlpha(0)
        LootMonitor.sindex = LootMonitor.cindex
        LootMonitor.timer:Hide()
      end
    end)

    LootMonitor.timer:SetScript("OnShow", function()
      LootMonitor:SetAlpha(1)
    end)
end