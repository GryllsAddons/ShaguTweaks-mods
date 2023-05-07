local module = ShaguTweaks:register({
    title = "Modifier Actions",
    description = "Use Ctrl (C), Alt (A) & Shift (S) for in game actions. S: Sell & Repair, A: Accept Release/Resurrect/Summon/Invite/Battleground, CA: Initiate/Accept Trade, CS: Follow, AS: Inspect, CAS: Logout.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

local processed = {}

local function CreateGoldString(money)
    if type(money) ~= "number" then return "-" end

    local gold = floor(money/ 100 / 100)
    local silver = floor(mod((money/100),100))
    local copper = floor(mod(money,100))

    local string = ""
    if gold > 0 then string = string .. "|cffffffff" .. gold .. "|cffffd700g" end
    if silver > 0 or gold > 0 then string = string .. "|cffffffff " .. silver .. "|cffc7c7cfs" end
    string = string .. "|cffffffff " .. copper .. "|cffeda55fc"

    return string
end

local function HasGreyItems()
    for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
        local name = GetContainerItemLink(bag,slot)
        if name and string.find(name,"ff9d9d9d") then return true end
      end
    end
    return nil
  end
  
  local function GetNextGreyItem()
    for bag = 0, 4, 1 do
      for slot = 1, GetContainerNumSlots(bag), 1 do
        local name = GetContainerItemLink(bag,slot)
        if name and string.find(name,"ff9d9d9d") and not processed[bag.."x"..slot] then
          processed[bag.."x"..slot] = true
          return bag, slot
        end
      end
    end
  
    return nil, nil
  end

module.enable = function(self)
    local actions = CreateFrame("Frame", nil, UIParent)
    local autovendor = CreateFrame("Frame", nil, nil)

    function actions:SetTime()
       actions.time = GetTime() + 0.75
    end

    function actions:Error(msg)
        UIErrorsFrame:AddMessage(msg, 1, 0, 0)
    end

    function actions:Merchant()
        if actions.merchant then
             -- sell
            if GetTime() > autovendor.cd  then
                if not autovendor:IsVisible() then
                    autovendor:Show()
                    autovendor.cd = GetTime()+5
                end
            end
            -- repair
            local repairAllCost, canRepair = GetRepairAllCost()
	        if canRepair and (GetMoney() > repairAllCost) then
                RepairAllItems()
                DEFAULT_CHAT_FRAME:AddMessage("Your items were repaired for " .. CreateGoldString(repairAllCost))
            end
        end
    end

    local function selljunk()
        autovendor:Hide()

        autovendor:SetScript("OnShow", function()
        processed = {}
        this.price = 0
        this.count = 0
        end)

        autovendor:SetScript("OnHide", function()
        if this.count > 0 then
            DEFAULT_CHAT_FRAME:AddMessage("Your grey items were sold for " .. CreateGoldString(this.price))
        end
        end)

        autovendor:SetScript("OnUpdate", function()
        -- throttle to to one item per .1 second
        if ( this.tick or 1) > GetTime() then return else this.tick = GetTime() + .1 end

        -- scan for the next grey item
        local bag, slot = GetNextGreyItem()
        if not bag or not slot then
            this:Hide()
            return
        end

        -- double check to only sell grey
        local name = GetContainerItemLink(bag,slot)
        if not name or not string.find(name,"ff9d9d9d") then
            return
        end

        -- get value
        local _, icount = GetContainerItemInfo(bag, slot)
        local _, _, id = string.find(GetContainerItemLink(bag, slot), "item:(%d+):%d+:%d+:%d+")
        local price = ShaguTweaks.SellValueDB[tonumber(id)] or 0
        if this.price then
            this.price = this.price + ( price * ( icount or 1 ) )
            this.count = this.count + 1
        end

        -- abort if the merchant window disappeared
        if not actions.merchant then return end

        -- clear cursor and sell the item
        ClearCursor()
        UseContainerItem(bag, slot)
        end)
    end

    function actions:Inspect()
        if actions:CheckInteractable("target", "inspect") then
            InspectUnit("target")
        end
    end

    function actions:Trade()
        if actions.trade then
            AcceptTrade()
        elseif actions:CheckInteractable("target", "trade") then
            InitiateTrade("target")
        end
    end

    function actions:Follow()
        if actions:CheckInteractable("target", "follow") then
            FollowUnit("target")
        end
    end

    function actions:Resurrect()
        if UnitIsDeadOrGhost("player") then
            AcceptResurrect()
        elseif UnitIsGhost("player") then
            RetrieveCorpse()
        elseif UnitIsDead("player") then
            RepopMe()        
        end
        StaticPopup_Hide("RESURRECT_NO_TIMER")
        StaticPopup_Hide("RESURRECT_NO_SICKNESS")
        StaticPopup_Hide("RESURRECT")
    end

    function actions:Summon()
        ConfirmSummon()
        StaticPopup_Hide("CONFIRM_SUMMON")
    end

    function actions:Group()
        AcceptGroup()
        StaticPopup_Hide("PARTY_INVITE")
    end

    function actions:Battleground()
        for i=1, MAX_BATTLEFIELD_QUEUES do
            status, mapName, instanceID = GetBattlefieldStatus(i)
            if status == "confirm" then
                AcceptBattlefieldPort(i,1)
                StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
            end
        end
    end

    function actions:CheckInteractable(unit, action)
        if not UnitExists(unit) then return false end
        
        local distIndex
        if action == "trade" then   
            if not UnitIsUnit("player", unit) and UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
                distIndex = 2
            end
        elseif action == "inspect" or action == "duel" then
            -- if not UnitIsUnit("player", unit) and UnitIsPlayer(unit) then
            if UnitIsPlayer(unit) then
                distIndex = 3
            end
        elseif action == "follow" then
            if not UnitIsUnit("player", unit) and UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
                distIndex = 4
            end
        end

        if not distIndex then
            if action == "trade" or action == "duel" then
                action = action.." with"
            end
            actions:Error("Unable to "..action.." "..GetUnitName(unit))
            return false
        end
        
        local inRange = CheckInteractDistance(unit, distIndex)
        if inRange then
            return true
        else
            actions:Error(GetUnitName(unit).." is too far away to "..action)
            return false
        end
    end    
    
    selljunk()
    actions:RegisterEvent("TRADE_SHOW")
    actions:RegisterEvent("TRADE_CLOSED")
    actions:RegisterEvent("MERCHANT_SHOW")
    actions:RegisterEvent("MERCHANT_CLOSED")

    actions:SetScript("OnEvent", function() 
        if (event == "TRADE_SHOW") then
            actions.trade = true
        elseif (event == "TRADE_CLOSED") then
            actions.trade = nil        
        elseif (event == "MERCHANT_SHOW") then
            actions.merchant = true
            autovendor.cd = 0
        elseif (event == "MERCHANT_CLOSED") then
            actions.merchant = nil
            autovendor:Hide()
        end
    end)
    
    actions:SetScript("OnUpdate", function()
        if GetTime() < actions.time then return end
        actions:SetTime()
        actions.shift = IsShiftKeyDown()
	    actions.ctrl = IsControlKeyDown()
	    actions.alt = IsAltKeyDown()        

        if (actions.ctrl and actions.alt and actions.shift) then
            Logout()
        elseif (actions.ctrl and actions.alt) then            
            actions:Trade()
        elseif (actions.ctrl and actions.shift) then
            actions:Follow()
        elseif (actions.alt and actions.shift) then
            actions:Inspect()
        elseif (actions.alt) then
            actions:Resurrect()
            actions:Summon()
            actions:Group()
            actions:Battleground()
        elseif (actions.shift) then
            actions:Merchant()
        end
    end)

    actions:SetTime()
end