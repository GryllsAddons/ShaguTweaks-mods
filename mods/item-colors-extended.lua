local _G = ShaguTweaks.GetGlobalEnv()
local L, T = ShaguTweaks.L, ShaguTweaks.T
local AddBorder = ShaguTweaks.AddBorder
local HookAddonOrVariable = ShaguTweaks.HookAddonOrVariable

local module = ShaguTweaks:register({
  title = T["Item Rarity Borders Extended"],
  description = T["Extends item rarity as the border color to merchant, craft, tradeskill, mail, trade and loot frames."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["Tooltip & Items"],
  enabled = false,
})

local defcolor = {}

local suffixes = {
  "of the Tiger", "of the Bear", "of the Gorilla", "of the Boar", "of the Monkey", "of the Falcon", "of the Wolf", "of the Eagle", "of the Whale", "of the Owl",
  "of Spirit", "of Intellect", "of Strength", "of Stamina", "of Agility",
  "of Defense", "of Healing", "of Power", "of Blocking", "of Marksmanship", "of Eluding",
  "of Frozen Wrath", "of Arcane Wrath", "of Fiery Wrath", "of Nature's Wrath", "of Shadow Wrath",
  "of Fire Resistance", "of Nature Resistance", "of Arcane Resistance", "of Frost Resistance", "of Shadow Resistance",
  "of Fire Protection", "of Nature Protection", "of Arcane Protection", "of Frost Protection", "of Shadow Protection",
}

local function remove_suffix(item)
  if not item then return end
  for _, suffix in ipairs(suffixes) do
      item = string.gsub(item, "%s" .. suffix .. "$", "")
  end
  return item
end

-- https://github.com/shagu/pfUI/blob/ebaebc6304625a47b825779231df9d4a054fd228/api/api.lua
-- [ GetItemLinkByName ]
-- Returns an itemLink for the given itemname
-- 'name'       [string]         name of the item
-- returns:     [string]         entire itemLink for the given item
local function GetItemLinkByName(name)
  name = remove_suffix(name)
  for itemID = 1, 25818 do
    local itemName, hyperLink, itemQuality = GetItemInfo(itemID)
    if (itemName and itemName == name) then
      local _, _, _, hex = GetItemQualityColor(tonumber(itemQuality))
      return hex.. "|H"..hyperLink.."|h["..itemName.."]|h|r"
    end
  end
end

module.enable = function(self)
  local dis
  if IsAddOnLoaded("lilsparkysworkshop") then
    dis = true
  end

  do -- merchant
    AddBorder(_G["MerchantBuyBackItemItemButton"], 3, color)

    for i = 1, 12 do
      AddBorder(_G["MerchantItem"..i.."ItemButton"], 3, color)
    end

    local refresh_merchant = function()
      if MerchantFrame.selectedTab == 1 then
        -- merchant tab
        for i = 1, GetMerchantNumItems() do
          local button = _G["MerchantItem"..i.."ItemButton"]
          if button then
            if not defcolor["merchant"] then
              defcolor["merchant"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
            end

            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)

            local link = GetMerchantItemLink(i)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                local r, g, b = GetItemQualityColor(q)
                button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
              end
            end
          end
        end

        local button = _G["MerchantBuyBackItemItemButton"]
        if button then
          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)

          local buyback = GetNumBuybackItems()
          if buyback > 0 then
            local iname = GetBuybackItemInfo(buyback)
            local link = GetItemLinkByName(iname)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                local r, g, b = GetItemQualityColor(q)
                button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
              end
            end
          end
        end
      else
        -- buyback tab
        for i = 1, GetNumBuybackItems() do
          local button = _G["MerchantItem"..i.."ItemButton"]
          if button then
            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)

            local iname = GetBuybackItemInfo(i)
            local link = GetItemLinkByName(iname)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                local r, g, b = GetItemQualityColor(q)
                button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
              end
            end
          end
        end
      end
    end

    local HookMerchantFrame_Update = MerchantFrame_Update
    MerchantFrame_Update = function()
      HookMerchantFrame_Update()
      refresh_merchant()
    end
  end

  do -- tradeskill
    if not dis then
      local refresh_tradeskill = function()
        local id = TradeSkillFrame.selectedSkill

        do
          -- icon
          local button = _G["TradeSkillSkillIcon"]
          local border = button.ShaguTweaks_border

          if not border then
            border = AddBorder(button, 3, { r = .5, g = .5, b = .5 })
          end

          if not defcolor["tradeskill"] then
            defcolor["tradeskill"] = { border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["tradeskill"][1], defcolor["tradeskill"][2], defcolor["tradeskill"][3], 0)

          local link = GetTradeSkillItemLink(id)
          if link then
            local _, _, istring = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q then
              local r, g, b = GetItemQualityColor(q)
              button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
            end
          end
        end

        do
          -- reagents
          for i = 1, GetTradeSkillNumReagents(id) do
            local button = _G["TradeSkillReagent"..i]
            local border = button.ShaguTweaks_border

            if not border then
              border = AddBorder(button, 1, { r = .5, g = .5, b = .5 })
              border:ClearAllPoints()
              local icon = _G["TradeSkillReagent"..i.."IconTexture"]
              border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
              border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
              border:SetFrameLevel(1)
            end

            if not defcolor["tradeskill"] then
              defcolor["tradeskill"] = { border:GetBackdropBorderColor() }
            end

            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["tradeskill"][1], defcolor["tradeskill"][2], defcolor["tradeskill"][3], 0)

            local link = GetTradeSkillReagentItemLink(id, i)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
                if q then
                local r, g, b = GetItemQualityColor(q)
                button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
              end
            end
          end
        end
      end

      HookAddonOrVariable("Blizzard_TradeSkillUI", function()
        local HookTradeSkillFrame_Update = TradeSkillFrame_Update
        TradeSkillFrame_Update = function(arg)
          HookTradeSkillFrame_Update(arg)
          refresh_tradeskill()
        end
      end)
    end
  end

  do -- craft
    if not dis then
      local refresh_craft = function()
        local id = GetCraftSelectionIndex()

        do
          -- icon
          local button = _G["CraftIcon"]
          local border = button.ShaguTweaks_border

          if not border then
            border = AddBorder(button, 3, { r = .5, g = .5, b = .5 })
          end
          if not defcolor["craft"] then
            defcolor["craft"] = { border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["craft"][1], defcolor["craft"][2], defcolor["craft"][3], 0)
          local iname = GetCraftInfo(id)
          local link = GetItemLinkByName(iname)
          if link then
            local _, _, istring = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q then
              local r, g, b = GetItemQualityColor(q)
              button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
            end
          end
        end

        do
          -- reagents
          for i = 1, GetCraftNumReagents(id) do
            local button = _G["CraftReagent"..i]
            local border = button.ShaguTweaks_border

            if not border then
              border = AddBorder(button, 1, { r = .5, g = .5, b = .5 })
              border:ClearAllPoints()
              local icon = _G["CraftReagent"..i.."IconTexture"]
              border:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, 2)
              border:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 2, -2)
              border:SetFrameLevel(1)
            end

            if not defcolor["craft"] then
              defcolor["craft"] = { border:GetBackdropBorderColor() }
            end

            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["craft"][1], defcolor["craft"][2], defcolor["craft"][3], 0)

            local iname = GetCraftReagentInfo(id, i)
            local link = GetItemLinkByName(iname)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                local r, g, b = GetItemQualityColor(q)
                button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
              end
            end
          end
        end
      end

      HookAddonOrVariable("Blizzard_CraftUI", function()
        local HookCraftFrame_Update = CraftFrame_Update
        CraftFrame_Update = function(arg)
          HookCraftFrame_Update(arg)
          refresh_craft()
        end
      end)
    end
  end

  do -- mail
    for i = 1, 7 do
      AddBorder(_G["MailItem"..i.."Button"], 3, color)
    end

    AddBorder(_G["OpenMailPackageButton"], 3, color)

    local refresh_mail = function()
      for i = 1, GetInboxNumItems() do
        local button = _G["MailItem"..i.."Button"]
        if button then
          if not defcolor["mail"] then
            defcolor["mail"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["mail"][1], defcolor["mail"][2], defcolor["mail"][3], 0)

          local _, _, _, q = GetInboxItem(i)
          if q then
            local r, g, b = GetItemQualityColor(q)
            button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
          end
        end
      end

      if InboxFrame.openMailID then
        local button = _G["OpenMailPackageButton"]

        button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["mail"][1], defcolor["mail"][2], defcolor["mail"][3], 0)

        local _, _, _, q = GetInboxItem(InboxFrame.openMailID)
        if q then
          local r, g, b = GetItemQualityColor(q)
          button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
        end
      end
    end

    local HookOpenMail_Update = OpenMail_Update
    OpenMail_Update = function()
      HookOpenMail_Update()
      refresh_mail()
    end
  end

  do -- trade
    for i = 1, 7  do
      AddBorder(_G["TradeRecipientItem"..i.."ItemButton"], 3, color)
      AddBorder(_G["TradePlayerItem"..i.."ItemButton"], 3, color)
    end

    local refresh_trade_target = function()
      for i = 1, 7  do
        local button = _G["TradeRecipientItem"..i.."ItemButton"]
        if button then
          if not defcolor["trade"] then
            defcolor["trade"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["trade"][1], defcolor["trade"][2], defcolor["trade"][3], 0)

          local n, _, _, q = GetTradeTargetItemInfo(i)
          if n and q then
            local r, g, b = GetItemQualityColor(q)
            button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
          end
        end
      end
    end

    local refresh_trade_player = function()
      for i = 1, 7  do
        local button = _G["TradePlayerItem"..i.."ItemButton"]
        if button then

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["trade"][1], defcolor["trade"][2], defcolor["trade"][3], 0)

          local link = GetTradePlayerItemLink(i)
          if link then
            local _, _, istring  = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q then
              local r, g, b = GetItemQualityColor(q)
              button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
            end
          end
        end
      end
    end

    local trade = CreateFrame("Frame", nil, TradeFrame)
    trade:RegisterEvent("TRADE_SHOW")
    trade:RegisterEvent("TRADE_PLAYER_ITEM_CHANGED")
    trade:RegisterEvent("TRADE_TARGET_ITEM_CHANGED")
    trade:SetScript("OnEvent", function()
      if event == "TRADE_SHOW" then
        refresh_trade_target()
        refresh_trade_player()
      elseif event == "TRADE_TARGET_ITEM_CHANGED" then
        refresh_trade_target()
      elseif event == "TRADE_PLAYER_ITEM_CHANGED" then
        refresh_trade_player()
      end
    end)
  end

  do -- loot
    for i = 1, 4 do
      AddBorder(_G["LootButton"..i], 3, color)
    end

    local refresh_loot = function()
      for i = 1, 4 do
        local button = _G["LootButton"..i]
        if button then
          if not defcolor["loot"] then
            defcolor["loot"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["loot"][1], defcolor["loot"][2], defcolor["loot"][3], 0)

          local _, _, _, q = GetLootSlotInfo(i)
          if q then
            local r, g, b = GetItemQualityColor(q)
            button.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
          end
        end
      end
    end

    local loot = CreateFrame("Frame", nil, LootFrame)
    loot:RegisterEvent("LOOT_OPENED")
    loot:RegisterEvent("LOOT_SLOT_CLEARED")
    loot:SetScript("OnEvent", refresh_loot)
  end
end