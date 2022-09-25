local module = ShaguTweaks:register({
    title = "Loot Monitor",
    description = "Display recent loot text in a central scrolling window. Hold Alt or Alt+Shift to scroll. Hold Alt+Ctrl while scrolling to filter by quality.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)    
    local width, height = 300, 10
    
    local LootMonitor = CreateFrame("Frame")
    LootMonitor:SetPoint("TOP", UIErrorsFrame, "BOTTOM", 85, 0)
    LootMonitor:SetHeight(height)
    LootMonitor:SetWidth(width)

    LootMonitor.info = CreateFrame("Frame", nil, LootMonitor)    
    LootMonitor.info:SetHeight(height)
    LootMonitor.info:SetWidth(width)

    LootMonitor.text = LootMonitor:CreateFontString(nil, "HIGH", "GameTooltipTextSmall")
    local font, size, opts = LootMonitor.text:GetFont()
    opts = "OUTLINE"
    LootMonitor.text:SetFont(font, size, "OUTLINE")

    LootMonitor.lines = 5
    for i=LootMonitor.lines,1,-1 do
      LootMonitor[i] = CreateFrame("SimpleHTML", nil, LootMonitor)
      LootMonitor[i]:SetPoint("TOP", LootMonitor[i+1] or LootMonitor, "BOTTOM")
      LootMonitor[i]:SetHeight(height)
      LootMonitor[i]:SetWidth(width)
      LootMonitor[i]:SetFont(font, size, opts)
      LootMonitor[i]:SetScript("OnHyperlinkClick", function()
        SetItemRef(arg1, arg2, arg3)
      end)
    end

    LootMonitor.info:SetPoint("TOP", LootMonitor[1], "BOTTOM")
    LootMonitor.text:SetPoint("LEFT", LootMonitor.info, "LEFT")    
    
    -- https://wowwiki-archive.fandom.com/wiki/Talk:WoW_constants
    local LOOT_ITEM_SELF = string.gsub(LOOT_ITEM_SELF, "%%s|Hitem:%%d:%%d:%%d:%%d|h%[%%s%]|h%%s", "%%s")
    -- "You receive loot: %s."
    local LOOT_ITEM = string.gsub(LOOT_ITEM, "%%s|Hitem:%%d:%%d:%%d:%%d|h%[%%s%]|h%%s", "%%s")
    -- "%s receives loot: %s."
    
    LootMonitor.cache = {}
    LootMonitor.cindex = 0  
    LootMonitor.sindex = LootMonitor.lines
    LootMonitor.timedelay = 10
    LootMonitor.itemQuality = -1
    
    local GetUnitData = ShaguTweaks.GetUnitData
    local strsplit = ShaguTweaks.strsplit
    local _, pclass = UnitClass("player")

    LootMonitor.scan = CreateFrame("Frame", "STLootMonitor", UIParent)
    LootMonitor.scan:RegisterEvent("CHAT_MSG_LOOT")
    LootMonitor.scan:SetScript("OnEvent", function()
      local cachetime = GetTime()

      local item = ShaguTweaks.cmatch(arg1, LOOT_ITEM_SELF)
      if item then        
        local player = "You"
        -- DEBUG:
        -- DEFAULT_CHAT_FRAME:AddMessage("LOOT_ITEM_SELF")
        -- DEFAULT_CHAT_FRAME:AddMessage("player = "..tostring(player)..", item = "..tostring(item)..", class = "..tostring(class)..", cachetime = "..cachetime)
        LootMonitor:AddCache(item, player, pclass, cachetime)        
        return
      end

      local player, item = ShaguTweaks.cmatch(arg1, LOOT_ITEM)
      if item then
        local class = GetUnitData(player)
        -- DEBUG:
        -- DEFAULT_CHAT_FRAME:AddMessage("LOOT_ITEM")
        -- DEFAULT_CHAT_FRAME:AddMessage("player = "..tostring(player)..", item = "..tostring(item)..", class = "..tostring(class)..", cachetime = "..cachetime)
        LootMonitor:AddCache(item, player, class, cachetime)
        return
      end      
    end)

    function LootMonitor:AddCache(hyperlink, player, class, cachetime)      
      local _, _, itemLink = string.find(hyperlink, "(item:%d+:%d+:%d+:%d+)")
      local _, _, itemQuality = GetItemInfo(itemLink)
      itemQuality = tonumber(itemQuality)
      
      LootMonitor.cindex = LootMonitor.cindex + 1
      table.insert(LootMonitor.cache, LootMonitor.cindex, hyperlink..","..itemQuality..","..player..","..class..","..cachetime)
      LootMonitor:UpdateLoot(LootMonitor.cindex)      

      -- DEBUG:
      -- DEFAULT_CHAT_FRAME:AddMessage("LootMonitor:AddCache")
      -- DEFAULT_CHAT_FRAME:AddMessage("LootMonitor.cindex = "..LootMonitor.cindex)  
      -- DEFAULT_CHAT_FRAME:AddMessage("hyperlink = "..tostring(hyperlink))
      -- DEFAULT_CHAT_FRAME:AddMessage("itemQuality = "..tostring(itemQuality))
      -- DEFAULT_CHAT_FRAME:AddMessage("player = "..tostring(player))
      -- DEFAULT_CHAT_FRAME:AddMessage("class = "..tostring(class))
      -- DEFAULT_CHAT_FRAME:AddMessage("cachetime = "..tostring(cachetime))  
    end

    function LootMonitor:GetLoot(i)
        if i < 1 then return false end
        local item, itemQuality, player, class, cachetime = strsplit(",", LootMonitor.cache[i])
        if not item then return false end
        return item, player, class, cachetime
    end

    function LootMonitor:GetFilteredLoot()
      for i=LootMonitor.findex,1,-1 do
        local item, itemQuality, player, class, cachetime = strsplit(",", LootMonitor.cache[i])
        if item then
          if tonumber(itemQuality) == tonumber(LootMonitor.itemQuality) then
            LootMonitor.findex = i
            return item, player, class, cachetime
          end
        end
      end
    end

    function LootMonitor:UpdateLoot(index)
      local updatetime = GetTime()
      LootMonitor.timer.time = GetTime() + LootMonitor.timedelay
      LootMonitor.timer:Show()
      LootMonitor:ClearText()
      local text = LootMonitor:GetItemQuality(LootMonitor.itemQuality)
      local r,g,b = GetItemQualityColor(LootMonitor.itemQuality)
      LootMonitor.text:SetText(text)
      LootMonitor.text:SetTextColor(r,g,b)

      if LootMonitor.itemQuality == -1 then
        for i=1,LootMonitor.lines do
          if LootMonitor:GetLoot(index) then
            local item, player, class, cachetime = LootMonitor:GetLoot(index)
            index = index - 1
            class = RAID_CLASS_COLORS[class]
            local alpha = LootMonitor:GetTimeAlpha(updatetime, cachetime)
            LootMonitor[i]:SetText(player.." "..item)
            LootMonitor[i]:SetTextColor(class.r, class.g, class.b, alpha)
          end
        end
      else
        LootMonitor.findex = index
        for i=1,LootMonitor.lines do
          if LootMonitor:GetFilteredLoot() then
            local item, player, class, cachetime = LootMonitor:GetLoot(LootMonitor.findex)
            LootMonitor.findex = LootMonitor.findex - 1
            class = RAID_CLASS_COLORS[class]
            local alpha = LootMonitor:GetTimeAlpha(updatetime, cachetime)
            LootMonitor[i]:SetText(player.." "..item)
            LootMonitor[i]:SetTextColor(class.r, class.g, class.b, alpha)
          end
        end
      end
    end

    function LootMonitor:GetTimeAlpha(updatetime, cachetime)
      local diff = updatetime - cachetime
      if diff < 60 then
        return 1
      elseif diff < 600 then
        return 0.5
      else
        return 0.25
      end
    end

    function LootMonitor:ClearText()
      LootMonitor.text:SetText("")
      for i=1, LootMonitor.lines do
        LootMonitor[i]:SetText("")
      end
    end

    function LootMonitor:GetItemQuality(q)
      -- (https://wowpedia.fandom.com/wiki/Enum.ItemQuality)
      if q == -1 then
        return "All loot"
      elseif q == 0 then        
        return "Poor loot"
      elseif q == 1 then        
        return "Common loot"
      elseif q == 2 then        
        return "Uncommon loot"
      elseif q == 3 then        
        return "Rare loot"
      elseif q == 4 then        
        return "Epic loot"
      elseif q == 5 then        	
        return "Legendary loot"
      end
    end    

    -- scrolling
    local function incrementIndex()
      LootMonitor.sindex = LootMonitor.sindex + 1
      if LootMonitor.sindex > LootMonitor.cindex then
        if LootMonitor.cindex == 0 then
          LootMonitor.sindex = 1
        else
          LootMonitor.sindex = LootMonitor.cindex
        end
      end
    end

    local function decrementIndex()
      LootMonitor.sindex = LootMonitor.sindex - 1
      if LootMonitor.sindex < LootMonitor.lines then
        if LootMonitor.cindex == 0 then
          LootMonitor.sindex = 1
        elseif LootMonitor.cindex < LootMonitor.lines then
          LootMonitor.sindex = LootMonitor.cindex
        else
          LootMonitor.sindex = LootMonitor.lines
        end
      end
    end

    local function firstIndex()
      LootMonitor.sindex = LootMonitor.lines
      if LootMonitor.sindex > LootMonitor.cindex then
        if LootMonitor.cindex == 0 then
          LootMonitor.sindex = 1
        else
          LootMonitor.sindex = LootMonitor.cindex
        end
      end
    end

    local function lastIndex()
      LootMonitor.sindex = LootMonitor.cindex
      if LootMonitor.sindex < LootMonitor.lines then
        if LootMonitor.cindex == 0 then
          LootMonitor.sindex = 1
        elseif LootMonitor.cindex < LootMonitor.lines then
          LootMonitor.sindex = LootMonitor.cindex
        end
      end
    end

    local function incrementQuality()
      LootMonitor.itemQuality = LootMonitor.itemQuality + 1
      if LootMonitor.itemQuality > 5 then
        LootMonitor.itemQuality = 5
      end
    end

    local function decrementQuality()
      LootMonitor.itemQuality = LootMonitor.itemQuality - 1
      if LootMonitor.itemQuality < -1 then
        LootMonitor.itemQuality = -1
      end
    end

    
    local function LootMonitorOnMouseWheel()
      if IsAltKeyDown() then
        if arg1 > 0 then -- scroll up
          if IsShiftKeyDown() then
            firstIndex()          
          elseif IsControlKeyDown() then
            incrementQuality()     
          else            
            decrementIndex()
          end
        elseif arg1 < 0 then -- scroll down
          if IsShiftKeyDown() then
            lastIndex()
          elseif IsControlKeyDown() then
            decrementQuality()
          else           
              incrementIndex()
          end
        end
      end
      -- DEBUG:
      -- DEFAULT_CHAT_FRAME:AddMessage("LootMonitor.sindex = "..LootMonitor.sindex)
      LootMonitor.timer.time = GetTime() + LootMonitor.timedelay
      LootMonitor:UpdateLoot(LootMonitor.sindex)
    end

    LootMonitor.bg = CreateFrame("Frame", nil, LootMonitor)
    LootMonitor.bg:SetPoint("TOPLEFT", LootMonitor, "TOPLEFT")
    LootMonitor.bg:SetPoint("BOTTOMRIGHT", LootMonitor.info, "BOTTOMRIGHT")
    LootMonitor.bg:EnableMouseWheel(true)
    LootMonitor.bg:SetScript("OnMouseWheel", LootMonitorOnMouseWheel)

    -- hiding
    LootMonitor.timer = CreateFrame("FRAME", nil, LootMonitor)
    LootMonitor.timer:SetAllPoints(LootMonitor.timer:GetParent())
    LootMonitor.timer:Hide()

    LootMonitor.timer:SetScript("OnUpdate", function()
      if (GetTime() > LootMonitor.timer.time) then
        LootMonitor:ClearText()
        LootMonitor.sindex = LootMonitor.cindex
        LootMonitor.timer:Hide()
      end
    end)
end