local _G = ShaguTweaks.GetGlobalEnv()
local L, T = ShaguTweaks.L, ShaguTweaks.T
local AddBorder = ShaguTweaks.AddBorder
local HookAddonOrVariable = ShaguTweaks.HookAddonOrVariable

local module = ShaguTweaks:register({
  title = T["Item Rarity Border Glow"],
  description = T["Show item rarity as the border color with a glow on bags, bank, character, inspect, merchant, craft, tradeskill, mail, trade and loot frames."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["Tooltip & Items"],
  enabled = false,
})

local defcolor = {}

local paperdoll_slots = {
  [0] = "AmmoSlot", "HeadSlot",
  "NeckSlot", "ShoulderSlot",
  "ShirtSlot", "ChestSlot",
  "WaistSlot", "LegsSlot",
  "FeetSlot", "WristSlot",
  "HandsSlot", "Finger0Slot",
  "Finger1Slot", "Trinket0Slot",
  "Trinket1Slot", "BackSlot",
  "MainHandSlot", "SecondaryHandSlot",
  "RangedSlot", "TabardSlot",
}

local inspect_slots = {
  "HeadSlot", "NeckSlot",
  "ShoulderSlot", "ShirtSlot",
  "ChestSlot", "WaistSlot",
  "LegsSlot", "FeetSlot",
  "WristSlot", "HandsSlot",
  "Finger0Slot", "Finger1Slot",
  "Trinket0Slot", "Trinket1Slot",
  "BackSlot", "MainHandSlot",
  "SecondaryHandSlot", "RangedSlot",
  "TabardSlot"
}

local function AddTexture(frame, inset, color)
  if not frame then return end
  if frame.ShaguTweaks_texture then return frame.ShaguTweaks_texture end

  local top, right, bottom, left

  if type(inset) == "table" then
    top, right, bottom, left = unpack((inset))
    left, bottom = -left, -bottom
  end

  if not frame.ShaguTweaks_texture then
    frame.ShaguTweaks_texture = frame:CreateTexture(nil, "OVERLAY")
    frame.ShaguTweaks_texture:SetTexture("Interface\\Buttons\\UI-ActionButton-Border")
    frame.ShaguTweaks_texture:SetBlendMode("ADD")
    frame.ShaguTweaks_texture:SetPoint("TOPLEFT", frame, "TOPLEFT", (left or -inset), (top or inset))
    frame.ShaguTweaks_texture:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", (right or inset), (bottom or -inset))

    if color then
      frame.ShaguTweaks_texture:SetVertexColor(color.r, color.g, color.b, 1)
    end
  end

  return frame.ShaguTweaks_texture
end

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

-- HerrTiSo / That Guy Turtles addition: Disable glow on low quality items
local function SetGlowForQuality(button, quality, defaultColor)
  if quality and quality > 1 then
    local r, g, b = GetItemQualityColor(quality)
    button.ShaguTweaks_border:SetBackdropBorderColor(r, g, b, 1)
    button.ShaguTweaks_texture:SetVertexColor(r, g, b, 1)
  else
    button.ShaguTweaks_border:SetBackdropBorderColor(defaultColor[1], defaultColor[2], defaultColor[3], 0)
    button.ShaguTweaks_texture:SetVertexColor(defaultColor[1], defaultColor[2], defaultColor[3], 0)
  end
end

module.enable = function(self)
  local dis
  if IsAddOnLoaded("lilsparkysworkshop") then
    dis = true
  end

  do -- paperdoll
    local refresh_paperdoll = function()
      for i, slot in pairs(paperdoll_slots) do
        local button = _G["Character"..slot]
        if button then
          local border = button.ShaguTweaks_border

          if not border then
            border = AddBorder(button, 3, { r = .5, g = .5, b = .5 })
          end

          local texture = button.ShaguTweaks_texture

          if not texture then
            texture = AddTexture(button, 14, { r = .5, g = .5, b = .5 })
          end

          if not defcolor["paperdoll"] then
            defcolor["paperdoll"] = { border:GetBackdropBorderColor() }
          end

          local quality = GetInventoryItemQuality("player", i)
          if quality then
            SetGlowForQuality(button, quality, defcolor["bag"])
          else
            border:SetBackdropBorderColor(defcolor["paperdoll"][1], defcolor["paperdoll"][2], defcolor["paperdoll"][3], 1)
            texture:SetVertexColor(defcolor["paperdoll"][1], defcolor["paperdoll"][2], defcolor["paperdoll"][3], 0)
          end
        end
      end
    end

    local paperdoll = CreateFrame("Frame", nil, CharacterFrame)
    paperdoll:RegisterEvent("UNIT_INVENTORY_CHANGED")
    paperdoll:SetScript("OnEvent", refresh_paperdoll)
    paperdoll:SetScript("OnShow", refresh_paperdoll)
  end

  do -- inspect
    local refresh_inspect = function()
      for i, v in pairs(inspect_slots) do
        local button = _G["Inspect"..v]
        local link = GetInventoryItemLink("target", i)
        local border = button.ShaguTweaks_border

        if not border then
          border = AddBorder(button, 3, { r = .5, g = .5, b = .5 })
        end

        local texture = button.ShaguTweaks_texture

        if not texture then
          texture = AddTexture(button, 14, { r = .5, g = .5, b = .5 })
        end

        if not defcolor["inspect"] then
          defcolor["inspect"] = { border:GetBackdropBorderColor() }
        end

        border:SetBackdropBorderColor(defcolor["inspect"][1], defcolor["inspect"][2], defcolor["inspect"][3], 1)
        texture:SetVertexColor(defcolor["inspect"][1], defcolor["inspect"][2], defcolor["inspect"][3], 0)

        if link then
          local _, _, istring = string.find(link, "|H(.+)|h")
          local _, _, quality = GetItemInfo(istring)
          if quality then
            SetGlowForQuality(button, quality, defcolor["bag"])
          end
        end
      end
    end

    HookAddonOrVariable("Blizzard_InspectUI", function()
      local HookInspectPaperDollItemSlotButton_Update = InspectPaperDollItemSlotButton_Update
      InspectPaperDollItemSlotButton_Update = function(arg)
        HookInspectPaperDollItemSlotButton_Update(arg)
        refresh_inspect()
      end
    end)
  end

  do -- bags
    local color = { r = .5, g = .5, b = .46 }

    for i = 0, 3 do
      AddBorder(_G["CharacterBag"..i.."Slot"], 3, color)
      AddTexture(_G["CharacterBag"..i.."Slot"], 14, color)
    end

    for i = 1, 12 do
      for k = 1, MAX_CONTAINER_ITEMS do
        AddBorder(_G["ContainerFrame"..i.."Item"..k], 3, color)
        AddTexture(_G["ContainerFrame"..i.."Item"..k], 14, color)
      end
    end

    local refresh_bags = function()
      for i = 1, 12 do
        local frame = _G["ContainerFrame"..i]
        if frame then
          local name = frame:GetName()
          local id = frame:GetID()
          for i = 1, MAX_CONTAINER_ITEMS do
            local button = _G[name.."Item"..i]

            if not defcolor["bag"] then
              defcolor["bag"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
            end

            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["bag"][1], defcolor["bag"][2], defcolor["bag"][3], 1)
            button.ShaguTweaks_texture:SetVertexColor(defcolor["bag"][1], defcolor["bag"][2], defcolor["bag"][3], 0)

            local link = GetContainerItemLink(id, button:GetID())
            if button and button:IsShown() and link then
              local _, _, istring  = string.find(link, "|H(.+)|h")
              local _, _, quality, _, _, itype = GetItemInfo(istring)
              if itype == "Quest" then
                button.ShaguTweaks_border:SetBackdropBorderColor(1,1,0)
                button.ShaguTweaks_texture:SetVertexColor(1,1,0,1)
              elseif quality then
                SetGlowForQuality(button, quality, defcolor["bag"])
              end
            end
          end
        end
      end
    end

    local bags = CreateFrame("Frame", nil, ContainerFrame1)
    bags:RegisterEvent("BAG_UPDATE")
    bags:SetScript("OnEvent", refresh_bags)

    local HookContainerFrame_OnShow = ContainerFrame_OnShow
    function ContainerFrame_OnShow() refresh_bags() HookContainerFrame_OnShow() end

    local HookContainerFrame_OnHide = ContainerFrame_OnHide
    function ContainerFrame_OnHide() refresh_bags() HookContainerFrame_OnHide() end
  end

  do -- bank
    for i = 1, 28 do
      AddBorder(_G["BankFrameItem"..i], 3, color)
      AddTexture(_G["BankFrameItem"..i], 14, color)
    end

    local refresh_bank = function()
      for i = 1, 28 do
        local button = _G["BankFrameItem"..i]
		    local link = GetContainerItemLink(-1, i)
        if button then
          if not defcolor["bank"] then
            defcolor["bank"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["bank"][1], defcolor["bank"][2], defcolor["bank"][3], 1)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["bank"][1], defcolor["bank"][2], defcolor["bank"][3], 0)

          if link then
            local _, _, istring = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q and q > 1 then
              SetGlowForQuality(button, q, defcolor["bank"])
            end
          end
        end
      end
    end

    local bank = CreateFrame("Frame", nil, BankFrame)
    bank:RegisterEvent("PLAYERBANKSLOTS_CHANGED")
    bank:SetScript("OnEvent", refresh_bank)
    bank:SetScript("OnShow", refresh_bank)
  end

  do -- weapon buff
    AddBorder(TempEnchant1, 3, {.2,.2,.2})
    AddBorder(TempEnchant2, 3, {.2,.2,.2})

    local hookBuffFrame_Enchant_OnUpdate = BuffFrame_Enchant_OnUpdate
    function BuffFrame_Enchant_OnUpdate(elapsed)
      hookBuffFrame_Enchant_OnUpdate(elapsed)

      -- return early without any weapon enchants
      local mh, _, _, oh = GetWeaponEnchantInfo()
    	if not mh and not oh then return end

      -- update weapon enchant 1
      local r, g, b = GetItemQualityColor(GetInventoryItemQuality("player", TempEnchant1:GetID()) or 1)
      TempEnchant1.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
      TempEnchant1Border:SetAlpha(0)

      -- update weapon enchant 2
      local r, g, b = GetItemQualityColor(GetInventoryItemQuality("player", TempEnchant2:GetID()) or 1)
      TempEnchant2.ShaguTweaks_border:SetBackdropBorderColor(r,g,b,1)
      TempEnchant2Border:SetAlpha(0)
    end
  end

  do -- merchant
    AddBorder(_G["MerchantBuyBackItemItemButton"], 3, color)
    AddTexture(_G["MerchantBuyBackItemItemButton"], 14, color)

    for i = 1, 12 do
      AddBorder(_G["MerchantItem"..i.."ItemButton"], 3, color)
      AddTexture(_G["MerchantItem"..i.."ItemButton"], 14, color)
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
            button.ShaguTweaks_texture:SetVertexColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)

            local link = GetMerchantItemLink(i)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                SetGlowForQuality(button, q, defcolor["merchant"])
              end
            end
          end
        end

        local button = _G["MerchantBuyBackItemItemButton"]
        if button then
          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)

          local buyback = GetNumBuybackItems()
          if buyback > 0 then
            local iname = GetBuybackItemInfo(buyback)
            local link = GetItemLinkByName(iname)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                SetGlowForQuality(button, q, defcolor["merchant"])
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
            button.ShaguTweaks_texture:SetVertexColor(defcolor["merchant"][1], defcolor["merchant"][2], defcolor["merchant"][3], 0)

            local iname = GetBuybackItemInfo(i)
            local link = GetItemLinkByName(iname)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                SetGlowForQuality(button, q, defcolor["merchant"])
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

          local texture = button.ShaguTweaks_texture

          if not texture then
            texture = AddTexture(button, 14, { r = .5, g = .5, b = .5 })
          end

          if not defcolor["tradeskill"] then
            defcolor["tradeskill"] = { border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["tradeskill"][1], defcolor["tradeskill"][2], defcolor["tradeskill"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["tradeskill"][1], defcolor["tradeskill"][2], defcolor["tradeskill"][3], 0)

          local link = GetTradeSkillItemLink(id)
          if link then
            local _, _, istring = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q then
              SetGlowForQuality(button, q, defcolor["tradeskill"])
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

            local texture = button.ShaguTweaks_texture

            if not texture then
              texture = AddTexture(button, 14, { r = .5, g = .5, b = .5 })
              texture:ClearAllPoints()
              texture:SetPoint("TOPLEFT", border, "TOPLEFT", -12, 12)
              texture:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 12, -12)
            end

            if not defcolor["tradeskill"] then
              defcolor["tradeskill"] = { border:GetBackdropBorderColor() }
            end

            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["tradeskill"][1], defcolor["tradeskill"][2], defcolor["tradeskill"][3], 0)
            button.ShaguTweaks_texture:SetVertexColor(defcolor["tradeskill"][1], defcolor["tradeskill"][2], defcolor["tradeskill"][3], 0)

            local link = GetTradeSkillReagentItemLink(id, i)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
                if q then
                SetGlowForQuality(button, q, defcolor["tradeskill"])
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

          local texture = button.ShaguTweaks_texture

          if not texture then
            texture = AddTexture(button, 14, { r = .5, g = .5, b = .5 })
          end

          if not defcolor["craft"] then
            defcolor["craft"] = { border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["craft"][1], defcolor["craft"][2], defcolor["craft"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["craft"][1], defcolor["craft"][2], defcolor["craft"][3], 0)

          local iname = GetCraftInfo(id)
          local link = GetItemLinkByName(iname)
          if link then
            local _, _, istring = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q then
              SetGlowForQuality(button, q, defcolor["craft"])
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

            local texture = button.ShaguTweaks_texture

            if not texture then
              texture = AddTexture(button, 14, { r = .5, g = .5, b = .5 })
              texture:ClearAllPoints()
              texture:SetPoint("TOPLEFT", border, "TOPLEFT", -12, 12)
              texture:SetPoint("BOTTOMRIGHT", border, "BOTTOMRIGHT", 12, -12)
            end

            if not defcolor["craft"] then
              defcolor["craft"] = { border:GetBackdropBorderColor() }
            end

            button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["craft"][1], defcolor["craft"][2], defcolor["craft"][3], 0)
            button.ShaguTweaks_texture:SetVertexColor(defcolor["craft"][1], defcolor["craft"][2], defcolor["craft"][3], 0)

            local iname = GetCraftReagentInfo(id, i)
            local link = GetItemLinkByName(iname)
            if link then
              local _, _, istring = string.find(link, "|H(.+)|h")
              local _, _, q = GetItemInfo(istring)
              if q then
                SetGlowForQuality(button, q, defcolor["craft"])
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
      AddTexture(_G["MailItem"..i.."Button"], 14, color)
    end

    AddBorder(_G["OpenMailPackageButton"], 3, color)
    AddTexture(_G["OpenMailPackageButton"], 14, color)

    local refresh_mail = function()
      for i = 1, GetInboxNumItems() do
        local button = _G["MailItem"..i.."Button"]
        if button then
          if not defcolor["mail"] then
            defcolor["mail"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["mail"][1], defcolor["mail"][2], defcolor["mail"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["mail"][1], defcolor["mail"][2], defcolor["mail"][3], 0)

          local _, _, _, q = GetInboxItem(i)
          if q then
            SetGlowForQuality(button, q, defcolor["mail"])
          end
        end
      end

      if InboxFrame.openMailID then
        local button = _G["OpenMailPackageButton"]

        button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["mail"][1], defcolor["mail"][2], defcolor["mail"][3], 0)
        button.ShaguTweaks_texture:SetVertexColor(defcolor["mail"][1], defcolor["mail"][2], defcolor["mail"][3], 0)

        local _, _, _, q = GetInboxItem(InboxFrame.openMailID)
        if q then
          SetGlowForQuality(button, q, defcolor["mail"])
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
      AddTexture(_G["TradeRecipientItem"..i.."ItemButton"], 14, color)

      AddBorder(_G["TradePlayerItem"..i.."ItemButton"], 3, color)
      AddTexture(_G["TradePlayerItem"..i.."ItemButton"], 14, color)
    end

    local refresh_trade_target = function()
      for i = 1, 7  do
        local button = _G["TradeRecipientItem"..i.."ItemButton"]
        if button then
          if not defcolor["trade"] then
            defcolor["trade"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["trade"][1], defcolor["trade"][2], defcolor["trade"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["trade"][1], defcolor["trade"][2], defcolor["trade"][3], 0)

          local n, _, _, q = GetTradeTargetItemInfo(i)
          if n and q then
            SetGlowForQuality(button, q, defcolor["trade"])
          end
        end
      end
    end

    local refresh_trade_player = function()
      for i = 1, 7  do
        local button = _G["TradePlayerItem"..i.."ItemButton"]
        if button then

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["trade"][1], defcolor["trade"][2], defcolor["trade"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["trade"][1], defcolor["trade"][2], defcolor["trade"][3], 0)

          local link = GetTradePlayerItemLink(i)
          if link then
            local _, _, istring  = string.find(link, "|H(.+)|h")
            local _, _, q = GetItemInfo(istring)
            if q then
              SetGlowForQuality(button, q, defcolor["trade"])
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
      AddTexture(_G["LootButton"..i], 14, color)
    end

    local refresh_loot = function()
      for i = 1, 4 do
        local button = _G["LootButton"..i]
        if button then
          if not defcolor["loot"] then
            defcolor["loot"] = { button.ShaguTweaks_border:GetBackdropBorderColor() }
          end

          button.ShaguTweaks_border:SetBackdropBorderColor(defcolor["loot"][1], defcolor["loot"][2], defcolor["loot"][3], 0)
          button.ShaguTweaks_texture:SetVertexColor(defcolor["loot"][1], defcolor["loot"][2], defcolor["loot"][3], 0)

          local _, _, _, q = GetLootSlotInfo(i)
          if q then
            SetGlowForQuality(button, q, defcolor["loot"])
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