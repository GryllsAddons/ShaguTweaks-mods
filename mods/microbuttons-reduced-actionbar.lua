local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Reduced Actionbar Microbuttons"],
    description = T["Shows the microbuttons when using the reduced actionbar. Mouseover the help button to show the draggable tab. Hold Ctrl & Shift then drag to move, hold Ctrl & Shift then right click to reset position."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local frames = {
        CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, QuestLogMicroButton,
        SocialsMicroButton, WorldMapMicroButton, MainMenuMicroButton, HelpMicroButton,
    }

    local _CharacterMicroButton = CharacterMicroButton
    local _SpellbookMicroButton = SpellbookMicroButton
    local _TalentMicroButton = TalentMicroButton
    local _QuestLogMicroButton = QuestLogMicroButton
    local _SocialsMicroButton = SocialsMicroButton
    local _WorldMapMicroButton = WorldMapMicroButton
    local _MainMenuMicroButton = MainMenuMicroButton
    local _HelpMicroButton = HelpMicroButton

    ShaguTweaks_config = ShaguTweaks_config or {}
    ShaguTweaks_config["ReducedActionbarBags"] = ShaguTweaks_config["ReducedActionbarBags"] or {}
    local movedb = ShaguTweaks_config["ReducedActionbarBags"]

    local holder = CreateFrame("Button", "microholder", UIParent)
    local name = holder:GetName()
    local width = 210

    local function setup()
        holder:SetWidth(width)
        holder:SetHeight(44)
        holder:SetFrameLevel(64)
        holder:SetFrameStrata("MEDIUM")
        holder:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileSize = 8, edgeSize = 16,
        insets = { left = 3, right = 3, top = 3, bottom = 3 }
        })
        holder:SetBackdropBorderColor(.9,.8,.5,1)
        holder:SetBackdropColor(.4,.4,.4,1)

        holder:SetMovable(true)
        holder:SetClampedToScreen(true)

        holder:EnableMouse(true)
        holder:RegisterForClicks("RightButtonDown")
        holder:RegisterForDrag("LeftButton")
    end

    local function defaultPosition()
        holder:ClearAllPoints()
        holder:SetPoint("LEFT", ActionButton12, "RIGHT", 100, 0)
    end

    local function position()
        if movedb[name] then
            holder:ClearAllPoints()
            holder:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", movedb[name][1], movedb[name][2])
        else
            defaultPosition()
        end
    end

    local function scripts()
        holder:SetScript("OnClick", function()
            if arg1 == "RightButton" then
                if (IsShiftKeyDown() and IsControlKeyDown()) then
                    holder:SetUserPlaced(false)
                    defaultPosition()
                end
            end
        end)

        holder:SetScript("OnDragStart", function()
            if (IsShiftKeyDown() and IsControlKeyDown()) then
                holder:StartMoving()
            end
        end)

        holder:SetScript("OnDragStop", function()
            holder:StopMovingOrSizing()
            movedb[name] = {holder:GetLeft(), holder:GetTop()}
        end)

        holder:SetScript("OnLeave", function()
            holder:SetWidth(width)
        end)
    end

    local function restore()
        CharacterMicroButton = _CharacterMicroButton
        SpellbookMicroButton = _SpellbookMicroButton
        TalentMicroButton = _TalentMicroButton
        QuestLogMicroButton = _QuestLogMicroButton
        SocialsMicroButton = _SocialsMicroButton
        WorldMapMicroButton = _WorldMapMicroButton
        MainMenuMicroButton = _MainMenuMicroButton
        HelpMicroButton = _HelpMicroButton

        CharacterMicroButton:SetPoint("LEFT", holder, "LEFT", 3, 11)
        SpellbookMicroButton:SetPoint("LEFT", CharacterMicroButton, "RIGHT", -4, 0)
        TalentMicroButton:SetPoint("LEFT", SpellbookMicroButton, "RIGHT", -4, 0)
        QuestLogMicroButton:SetPoint("LEFT", TalentMicroButton, "RIGHT", -4, 0)
        SocialsMicroButton:SetPoint("LEFT", QuestLogMicroButton, "RIGHT", -4, 0)
        WorldMapMicroButton:SetPoint("LEFT", SocialsMicroButton, "RIGHT", -4, 0)
        MainMenuMicroButton:SetPoint("LEFT", WorldMapMicroButton, "RIGHT", -4, 0)
        HelpMicroButton:SetPoint("LEFT", MainMenuMicroButton, "RIGHT", -4, 0)

        for id, frame in pairs(frames) do
            frame:SetParent(holder)
            frame.Show = frame:Show()
            frame:Show()
        end

        HelpMicroButton:SetScript("OnEnter", function()
            holder:SetWidth(width+20)
        end)
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            -- if not reduced action bar end
            if MainMenuExpBar:GetWidth() > 512 then return end
            setup()
            scripts()
            restore()
            position()
        end
    end)

end