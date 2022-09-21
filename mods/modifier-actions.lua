local module = ShaguTweaks:register({
    title = "Modifier Actions",
    description = "Use Ctrl (C), Alt (A) & Shift (S) for in game actions. CAS: Logout, CA: Initiate/Accept Trade, CS: Follow, AS: Inspect, S: Repair.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

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

module.enable = function(self)
    local actions = CreateFrame("Frame", nil, UIParent)

    function actions:SetTime()
       actions.time = GetTime() + 0.75
    end

    function actions:Error(msg)
        UIErrorsFrame:AddMessage(msg, 1, 0, 0)
    end

    function actions:Merchant()
        if actions.merchant then
            local repairAllCost, canRepair = GetRepairAllCost()
	        if canRepair and (GetMoney() > repairAllCost) then
                RepairAllItems()
                DEFAULT_CHAT_FRAME:AddMessage("Your items have been repaired for " .. CreateGoldString(repairAllCost))
            end
        end
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

    function actions:CheckInteractable(unit, action)
        if not UnitExists(unit) then return false end
        
        local distIndex
        if action == "trade" then   
            if not UnitIsUnit("player", unit) and UnitIsPlayer(unit) and UnitIsFriend(unit, "player") then
                distIndex = 2
            end
        elseif action == "inspect" or action == "duel" then
            if not UnitIsUnit("player", unit) and UnitIsPlayer(unit) then
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
        elseif (event == "MERCHANT_CLOSED") then
            actions.merchant = nil
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
        elseif (actions.shift) then
            actions:Merchant()
        end
    end)

    actions:SetTime()
end