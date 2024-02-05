local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Modifier Actions"],
    description = T["Use Ctrl (C), Alt (A) & Shift (S) for in game actions. S: Sell & Repair, AC: Initiate/Accept Trade, Confirm/Accept Resurrect/Quest/Summon/Invite/Battleground, CS: Follow, AS: Inspect, CAS: Logout."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

local processed = {}
local msgtime = 1

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

    function actions:SetTime(time)
        if not time then time = 0.75 end
        if actions.quest then time = 0.1 end
        actions.time = GetTime() + time
    end

    actions.errormsgtime = 0
    function actions:Error(msg)
        if actions.errormsgtime < GetTime() then
            actions.errormsgtime = GetTime() + msgtime
            UIErrorsFrame:AddMessage(msg, 1, 0, 0)
        end
    end

    function actions:Merchant()
        if actions.merchant then
             -- sell
            if GetTime() > autovendor.cd  then
                if HasGreyItems() and (not autovendor:IsVisible()) then
                    autovendor:Show()
                    autovendor.cd = GetTime()+5
                end
            end
            -- repair
            local repairAllCost, canRepair = GetRepairAllCost()
            if canRepair and (GetMoney() > repairAllCost) then
                RepairAllItems()
                DEFAULT_CHAT_FRAME:AddMessage(T["Your items were repaired for "] .. CreateGoldString(repairAllCost))
            end
        end
    end

    do
        autovendor:Hide()

        autovendor:SetScript("OnShow", function()
            processed = {}
            this.price = 0
            this.count = 0
        end)

        autovendor:SetScript("OnHide", function()
            if this.count > 0 then
                DEFAULT_CHAT_FRAME:AddMessage(T["Your grey items were sold for "] .. CreateGoldString(this.price))
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
        if actions.dead then
            if UnitIsDeadOrGhost("player") then
                AcceptResurrect()
            elseif UnitIsGhost("player") then
                RetrieveCorpse()
            elseif UnitIsDead("player") then
                UseSoulstone()
                RepopMe()
            end
        end
    end

    function actions:Summon()
        if actions.summon then
            if GetSummonConfirmSummoner() and (not UnitAffectingCombat("player")) then
                ConfirmSummon()
            end

            if (not GetSummonConfirmSummoner()) then
                actions.summon = nil
                StaticPopup_Hide("CONFIRM_SUMMON")
            end
        end
    end

    function actions:Group()
        if actions.group then
            AcceptGroup()
        end
    end

    function actions:Battleground()
        if actions.battleground then
            for i=1, MAX_BATTLEFIELD_QUEUES do
                local status, mapName, instanceID = GetBattlefieldStatus(i)                
                if status == "confirm" then
                    AcceptBattlefieldPort(i,1)
                    break
                elseif status == "active" then
                    if GetBattlefieldWinner() then
                        LeaveBattlefield()
                        break
                    end
                end
            end
        end
    end

    function actions:QuestConfirm()
        if actions.questconfirm then
            local _, numQuests = GetNumQuestLogEntries()
            if numQuests < MAX_QUESTS then
                actions.questconfirm = nil
                ConfirmAcceptQuest()
                StaticPopup_Hide("QUEST_ACCEPT")
            end
        end
    end

    function actions:CheckQuestCompleted(quest)
        for i = 1, GetNumQuestLogEntries() do
            local title, _, _, _, _, complete = GetQuestLogTitle(i)
            if (title == quest) and (complete == 1) then
                return true
            end
        end
        return false
    end

    actions.rewardmsgtime = 0
    function actions:Quest()
        if actions.quest then
            if QuestFrameGreetingPanel:IsShown() then
                -- check for active quests
                for i = 1, MAX_NUM_QUESTS do
                    local questTitleButton = _G["QuestTitleButton" .. i]
                    if questTitleButton.isActive == 1 then
                        local quest = questTitleButton:GetText()
                        if actions:CheckQuestCompleted(quest) then
                            SelectActiveQuest(questTitleButton:GetID())
                            break
                        end
                    end
                end
                -- check for available quests
                for i = 1, MAX_NUM_QUESTS do
                    local questTitleButton = _G["QuestTitleButton" .. i]
                    if questTitleButton.isActive == 0 then
                        SelectAvailableQuest(questTitleButton:GetID())
                        break
                    end
                end
            elseif GossipFrame:IsShown() then
                -- check for active quests
                for i = 1, NUMGOSSIPBUTTONS do
                    local titleButton = _G["GossipTitleButton" .. i]
                    if titleButton.type == "Active" then
                        local quest = titleButton:GetText()
                        if actions:CheckQuestCompleted(quest) then
                            SelectGossipActiveQuest(titleButton:GetID())
                            break
                        end
                    end
                end
                -- check for available quests
                for i = 1, NUMGOSSIPBUTTONS do
                    local titleButton = _G["GossipTitleButton" .. i]
                    if titleButton.type == "Available" then
                        SelectGossipAvailableQuest(titleButton:GetID())
                        break
                    end
                end
            elseif QuestFrameAcceptButton:IsVisible() and QuestFrameAcceptButton:IsEnabled() then
                AcceptQuest()
            elseif QuestFrameCompleteButton:IsVisible() and QuestFrameCompleteButton:IsEnabled() then
                -- proceed to rewards
                CompleteQuest()
            elseif QuestFrameCompleteQuestButton:IsVisible() and QuestFrameCompleteQuestButton:IsEnabled() then
                -- get the reward unless multiple rewards
                if (QuestFrameRewardPanel.itemChoice == 0 and GetNumQuestChoices() > 0) then
                    -- limit reward error spam      
                    if actions.rewardmsgtime < GetTime() then
                        actions.rewardmsgtime = GetTime() + msgtime
                        QuestChooseRewardError()
                    end
                else
                    GetQuestReward(QuestFrameRewardPanel.itemChoice)
                end
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
            actions:Error(T["Unable to "]..action.." "..GetUnitName(unit))
            return false
        end
        
        local inRange = CheckInteractDistance(unit, distIndex)
        if inRange then
            return true
        else
            actions:Error(GetUnitName(unit)..T[" is too far away to "]..action)
            return false
        end
    end

    actions:RegisterEvent("TRADE_SHOW")
    actions:RegisterEvent("TRADE_CLOSED")
    actions:RegisterEvent("MERCHANT_SHOW")
    actions:RegisterEvent("MERCHANT_CLOSED")
    actions:RegisterEvent("CONFIRM_SUMMON")
    actions:RegisterEvent("PLAYER_DEAD")
    actions:RegisterEvent("PLAYER_ALIVE")
    actions:RegisterEvent("PARTY_INVITE_REQUEST")
    actions:RegisterEvent("PARTY_INVITE_CANCEL")
    actions:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
    actions:RegisterEvent("GOSSIP_SHOW")
    actions:RegisterEvent("GOSSIP_CLOSED")
    actions:RegisterEvent("QUEST_GREETING")
    actions:RegisterEvent("QUEST_DETAIL")
    actions:RegisterEvent("QUEST_PROGRESS")
    actions:RegisterEvent("QUEST_COMPLETE")
    actions:RegisterEvent("QUEST_ACCEPT_CONFIRM")
    actions:RegisterEvent("QUEST_FINISHED")

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
        elseif (event == "CONFIRM_SUMMON") then
            actions.summon = true
        elseif (event == "PLAYER_DEAD") then
            actions.dead = true
        elseif (event == "PLAYER_ALIVE") then
            actions.dead = nil
            StaticPopup_Hide("RESURRECT_NO_TIMER")
            StaticPopup_Hide("RESURRECT_NO_SICKNESS")
            StaticPopup_Hide("RESURRECT")
            StaticPopup_Hide("DEATH")
        elseif (event == "PARTY_INVITE_REQUEST") then
            actions.group = true
            actions:RegisterEvent("PARTY_MEMBERS_CHANGED")  
        elseif (event == "PARTY_INVITE_CANCEL" or event == "PARTY_MEMBERS_CHANGED") then            
            actions.group = nil
            actions:UnregisterEvent("PARTY_MEMBERS_CHANGED")
            StaticPopup_Hide("PARTY_INVITE")
        elseif (event == "UPDATE_BATTLEFIELD_STATUS") then
            for i=1, MAX_BATTLEFIELD_QUEUES do
                local status, mapName, instanceID = GetBattlefieldStatus(i)
                if (status == "none") then
                    actions.battleground = nil
                    break
                elseif (status == "queued")  then
                    actions.battleground = true
                    break
                elseif (status == "active") then
                    actions.battleground = true
                    StaticPopup_Hide("CONFIRM_BATTLEFIELD_ENTRY")
                    break
                end
            end
        elseif (event == "GOSSIP_SHOW" or event == "QUEST_GREETING" or event == "QUEST_DETAIL" or event == "QUEST_PROGRESS" or event == "QUEST_COMPLETE") then
            actions.quest = true
            actions:SetTime()
        elseif (event == "GOSSIP_CLOSED" or event == "QUEST_FINISHED") then
            actions.quest = nil
        elseif (event == "QUEST_ACCEPT_CONFIRM") then
            actions.questconfirm = true
        end
    end)
    
    actions:SetScript("OnUpdate", function()
        if GetTime() < actions.time then return end
        actions.shift = IsShiftKeyDown()
	    actions.ctrl = IsControlKeyDown()
	    actions.alt = IsAltKeyDown()

        if (actions.ctrl and actions.alt and actions.shift) then
            Logout()
        elseif (actions.ctrl and actions.alt) then
            actions:Trade()
            actions:Resurrect()
            actions:Quest()
            actions:QuestConfirm()
            actions:Summon()
            actions:Group()
            actions:Battleground()
        elseif (actions.ctrl and actions.shift) then
            actions:Follow()
        elseif (actions.alt and actions.shift) then
            actions:Inspect()
        -- elseif (actions.alt) then
        elseif (actions.shift) then
            actions:Merchant()
        end

        actions:SetTime()
    end)

    actions:SetTime()
end