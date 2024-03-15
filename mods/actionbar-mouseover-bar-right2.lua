local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Mouseover Right 2"],
    description = T["Hide the Right ActionBar 2 and show on mouseover."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Action Bar"],
    enabled = nil,
})

module.enable = function(self)
    ShaguTweaks.MouseoverRight2 = true
    local _G = ShaguTweaks.GetGlobalEnv()

    local timer = CreateFrame("Frame", nil, UIParent)
    local mouseOverBar
    local mouseOverButton

    local function hide(bar)
        bar:Hide()
    end

    local function show(bar)
        bar:Show()
    end

    local function mouseover(bar, upd)
        local function setTimer()
            timer.time = GetTime() + 2
            timer:SetScript("OnUpdate", function()
                if GetTime() >= timer.time then
                    hide(bar)
                    timer:SetScript("OnUpdate", nil)
                end
            end)
        end

        if (mouseOverButton or mouseOverBar) then
            timer:SetScript("OnUpdate", nil)
            show(bar)
        elseif (not mouseOverBar) and (not mouseOverButton) or upd then
            setTimer()
        end
    end

    local function barEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverBar = true
            mouseover(bar)
        end)
    end

    local function barLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverBar = nil
            mouseover(bar)
        end)
    end

    local function buttonEnter(frame, bar)
        frame:SetScript("OnEnter", function()
            mouseOverButton = true
            frame:EnableMouse(nil)
            mouseover(bar)
        end)
    end

    local function buttonLeave(frame, bar)
        frame:SetScript("OnLeave", function()
            mouseOverButton = nil
            frame:EnableMouse(true)
            mouseover(bar)
        end)
    end

    local function mouseoverButton(button, bar)
        button.mouseover = CreateFrame("Frame", nil, UIParent)
        button.mouseover:SetAllPoints(button)
        button.mouseover:EnableMouse(true)
        button.mouseover:SetFrameStrata("DIALOG")
        buttonEnter(button.mouseover, bar)
        buttonLeave(button.mouseover, bar)
    end

    local function mouseoverBar(bar)
        bar.mouseover = CreateFrame("Frame", nil, UIParent)
        bar.mouseover:SetAllPoints(bar)
        bar.mouseover:EnableMouse(true)
        barEnter(bar.mouseover, bar)
        barLeave(bar.mouseover, bar)
    end

    local function setup(bar)
        if not bar:IsVisible() then return end
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                mouseoverButton(button, bar)
            end
        end
        mouseoverBar(bar)
        UIParent_ManageFramePositions()
    end

    local function reset(bar)
        for i = 1, 12 do
            for _, button in pairs(
                    {
                    _G[bar:GetName()..'Button'..i],
                }
            ) do
                if button.mouseover then
                    button.mouseover:Hide()
                end
            end
        end

        if bar.mouseover then
            bar.mouseover:Hide()
        end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("CVAR_UPDATE")

    events:SetScript("OnEvent", function()
        local bar = MultiBarLeft
        this.enabled = SHOW_MULTI_ACTIONBAR_4 -- MultiBarLeft

        if not this.enabled then
            reset(bar)
            return
        else
            if not this.loaded then
                this.loaded = true
                setup(bar)
                mouseover(bar, true)
            end

            if event == "CVAR_UPDATE" then
                mouseover(bar, true)
            end
        end
    end)
end
