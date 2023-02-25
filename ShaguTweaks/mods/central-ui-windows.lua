local module = ShaguTweaks:register({
    title = "Central UI Windows",
    description = "Moves interaction windows to a central layout.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

--[[
    AddOn Support:
    Atlas
    AtlasLoot
    aux
    AdvancedTradeSkillWindow
    SuperMacro
    SuperInspect
    SurvivalUI 
]]

module.enable = function(self)
    local function move(f,e,x,y)
        if not f then return end
        f:ClearAllPoints()            
        f:SetClampedToScreen(true)
        f:SetPoint(e, UIParent, "CENTER", x, y)
        -- lock frames
        f.ClearAllPoints = function() end
        f.SetAllPoints = function() end
        f.SetPoint = function() end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("ADDON_LOADED")
    events:RegisterEvent("AUCTION_HOUSE_SHOW")
    events:RegisterEvent("TRAINER_SHOW")

    events:SetScript("OnEvent", function()
        if (event == "PLAYER_ENTERING_WORLD") then
            -- left frames
            move(CharacterFrame,"RIGHT",0,0)
            move(SpellBookFrame,"RIGHT",0,0)
            -- right frames
            move(DressUpFrame,"LEFT",0,0)
            move(FriendsFrame,"LEFT",0,0)       
            -- center frames
            move(BankFrame,"CENTER",0,0)
            move(GossipFrame,"CENTER",5,0)
            move(InspectFrame,"LEFT",0,0)
            move(ItemTextFrame,"CENTER",5,0)
            move(LootFrame,"CENTER",30,10)
            move(MailFrame,"CENTER",10,0)
            move(MerchantFrame,"CENTER",10,0)
            move(PetStableFrame,"CENTER",5,0)
            move(QuestFrame,"CENTER",5,0)
            move(QuestLogFrame,"CENTER",30,0)
            move(TalentFrame,"LEFT",0,0)
            move(TaxiFrame,"CENTER",0,0)
            move(TradeFrame,"CENTER",0,0)
            move(TalentFrame,"LEFT",0,0)
            if AtlasFrame then
                move(AtlasFrame,"CENTER",0,50)
            end
            if SuperMacroFrame then
                move(SuperMacroFrame,"CENTER",15,0)
            end
            if SuperInspectFrame then
                move(SuperInspectFrame,"LEFT",25,30)
            end
            if SurvivalUI_GUI then
                move(SurvivalUI_GUI,"CENTER",0,0)
            end
        elseif (event == "ADDON_LOADED") then
            -- fires when clicking the main menu or trade skill buttons for the first time
            if CraftFrame then
                move(CraftFrame,"CENTER",15,0)
            end
            if MacroFrame then
                move(MacroFrame,"CENTER",-5,0)
            end
            if KeyBindingFrame then
                move(KeyBindingFrame,"CENTER",20,0)
            end
            if ATSWFrame then
                move(ATSWFrame,"CENTER",15,0)
            elseif TradeSkillFrame then
                move(TradeSkillFrame,"CENTER",15,0)
            end
        elseif (event == "AUCTION_HOUSE_SHOW") then
            if aux_frame then
                move(aux_frame,"CENTER",0,0)
            end
            move(AuctionFrame,"CENTER",-5,0)
        elseif (event == "TRAINER_SHOW") then
            move(ClassTrainerFrame,"CENTER",10,0)
        end
    end)
end