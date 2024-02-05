local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Gryphons in Front"],
    description = T["Puts the gryphons in front of the action buttons."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Action Bar"],
    enabled = nil,
})

module.enable = function(self)
    local function gryphons()
        local bars = { MultiBarBottomLeft, MultiBarBottomRight }

        for _, bar in pairs(bars) do
            bar:SetFrameStrata("LOW")

            for i = 1, 12 do
                for _, button in pairs(
                        {
                        _G[bar:GetName()..'Button'..i],
                    }
                ) do
                    if button.mouseover then
                        local level = button:GetFrameLevel()
                        button.mouseover:SetFrameStrata("LOW")
                        button.mouseover:SetFrameLevel(level+1)
                    end
                end
            end

            if bar.mouseover then
                local level = bar:GetFrameLevel()
                bar.mouseover:SetFrameStrata("LOW")
                bar.mouseover:SetFrameLevel(level+1)
            end
        end
    end

    local timer = CreateFrame("Frame")
    timer:Hide()
    timer:SetScript("OnUpdate", function()
        if GetTime() >= timer.time then
            timer.time = nil
            gryphons()
            this:Hide()
            this:SetScript("OnUpdate", nil)
        end
    end)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("CVAR_UPDATE")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            timer.time = GetTime() + .5
        timer:Show()
        end
    end)
end
