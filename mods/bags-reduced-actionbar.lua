local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Reduced Actionbar Bags"],
    description = T["Shows the bag and keyring buttons when using the reduced actionbar. Mouseover the backpack to show the draggable tab. Hold Ctrl & Shift then drag to move, hold Ctrl & Shift then right click to reset position."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local frames = {
        CharacterBag3Slot, CharacterBag2Slot, CharacterBag1Slot,
        CharacterBag0Slot, MainMenuBarBackpackButton, KeyRingButton,
    }

    local _CharacterBag3Slot = CharacterBag3Slot
    local _CharacterBag2Slot = CharacterBag2Slot
    local _CharacterBag1Slot = CharacterBag1Slot
    local _CharacterBag0Slot = CharacterBag0Slot
    local _MainMenuBarBackpackButton = MainMenuBarBackpackButton
    local _KeyRingButton = KeyRingButton

    ShaguTweaks_config = ShaguTweaks_config or {}
    ShaguTweaks_config["ReducedActionbarBags"] = ShaguTweaks_config["ReducedActionbarBags"] or {}
    local movedb = ShaguTweaks_config["ReducedActionbarBags"]

    local holder = CreateFrame("Button", "bagholder", UIParent)
    local name = holder:GetName()
    local width = 222

    local function setup()
        holder:SetWidth(width)
        holder:SetHeight(49)
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
        holder:SetPoint("LEFT", ActionButton12, "RIGHT", 350, 0)
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
        CharacterBag3Slot = _CharacterBag3Slot
        CharacterBag2Slot = _CharacterBag2Slot
        CharacterBag1Slot = _CharacterBag1Slot
        CharacterBag0Slot = _CharacterBag0Slot
        MainMenuBarBackpackButton = _MainMenuBarBackpackButton
        KeyRingButton = _KeyRingButton

        KeyRingButton:SetPoint("LEFT", holder, "LEFT", 5, 1)
        CharacterBag3Slot:SetPoint("LEFT", KeyRingButton, "RIGHT", 2, 0)
        CharacterBag2Slot:SetPoint("LEFT", CharacterBag3Slot, "RIGHT", 2, 0)
        CharacterBag1Slot:SetPoint("LEFT", CharacterBag2Slot, "RIGHT", 2, 0)
        CharacterBag0Slot:SetPoint("LEFT", CharacterBag1Slot, "RIGHT", 2, 0)
        MainMenuBarBackpackButton:SetPoint("LEFT", CharacterBag0Slot, "RIGHT")

        for id, frame in pairs(frames) do
            frame:SetParent(holder)
            frame.Show = frame:Show()
            frame:Show()
        end

        MainMenuBarBackpackButton:SetScript("OnEnter", function()
            holder:SetWidth(width+20)
        end)
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            -- if not reduced action bar end
            if MainMenuBar:GetWidth() > 512 then return end
            setup()
            scripts()
            restore()
            position()
        end
    end)
end