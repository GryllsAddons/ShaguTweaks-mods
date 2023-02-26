local HookScript = ShaguTweaks.HookScript

local module = ShaguTweaks:register({
    title = "Central UI Windows",
    description = "Makes interaction windows central and draggable.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

--[[
    AddOn Support:
    AdvancedTradeSkillWindow
    Atlas
    AtlasLoot
    aux    
    SuperMacro
    SuperInspect
    SurvivalUI 
]]

module.enable = function(self)
    local _ClearAllPoints
    local _SetAllPoints
    local _SetPoint

    local function lock(f)
        _ClearAllPoints = f.ClearAllPoints
        _SetAllPoints = f.SetAllPoints
        _SetPoint = f.SetPoint

        f.ClearAllPoints = function() end
        f.SetAllPoints = function() end
        f.SetPoint = function() end
    end

    local function unlock(f)
        f.ClearAllPoints = _ClearAllPoints
        f.SetAllPoints = _SetAllPoints
        f.SetPoint = _SetPoint
    end

    local function move(f,e,x,y)        
        f:ClearAllPoints()            
        f:SetClampedToScreen(true)
        f:SetPoint(e, UIParent, "CENTER", x, y) 
    end

    local function hook(f,e,x,y)
        if not f then return end

        HookScript(f, "OnShow", function()
            unlock(f) 
            move(f,e,x,y)
            lock(f)
        end)

        HookScript(f, "OnMouseDown",function()
            f:StartMoving()
        end)
      
        HookScript(f, "OnMouseUp",function()
            f:StopMovingOrSizing()
        end)
    end

    local function hookparent(f,e,x,y)
        HookScript(f, "OnMouseDown",function()
            f:GetParent():StartMoving()
        end)
      
        HookScript(f, "OnMouseUp",function()
            f:GetParent():StopMovingOrSizing()
        end)
    end

    if not this.hooked then
        this.hooked = true    

        hook(CharacterFrame,"RIGHT",0,0)
        hookparent(PaperDollFrame,"RIGHT",0,0)
        hookparent(ReputationFrame,"RIGHT",0,0)
        hookparent(SkillFrame,"RIGHT",0,0)
        hookparent(HonorFrame,"RIGHT",0,0)

        hook(SpellBookFrame,"RIGHT",0,0)

        hook(DressUpFrame,"LEFT",0,0)
        hook(FriendsFrame,"LEFT",0,0)
        hook(InspectFrame,"LEFT",0,0)
        hook(TalentFrame,"LEFT",0,0)

        hook(AuctionFrame,"CENTER",-5,0)
        hook(BankFrame,"CENTER",0,0)
        hook(ClassTrainerFrame,"CENTER",10,0)
        hook(CraftFrame,"CENTER",15,0)
        hook(GossipFrame,"CENTER",5,0)            
        hook(ItemTextFrame,"CENTER",5,0)
        hook(LootFrame,"CENTER",30,10)
        hook(MacroFrame,"CENTER",-5,0)
        hook(MailFrame,"CENTER",10,0)
        hook(MerchantFrame,"CENTER",10,0)
        hook(KeyBindingFrame,"CENTER",20,0)
        hook(PetStableFrame,"CENTER",5,0)
        hook(QuestFrame,"CENTER",5,0)
        hook(QuestLogFrame,"CENTER",30,0)            
        hook(TaxiFrame,"CENTER",0,0)
        hook(TradeFrame,"CENTER",0,0)
        hook(TradeSkillFrame,"CENTER",15,0)

        -- AddOn support
        hook(AtlasFrame,"CENTER",0,50)
        hook(ATSWFrame,"CENTER",15,0)
        hook(aux_frame,"CENTER",0,0)
        hook(SuperMacroFrame,"CENTER",15,0)
        hook(SuperInspectFrame,"LEFT",25,30)
        hook(SurvivalUI_GUI,"CENTER",0,0)
    end
end