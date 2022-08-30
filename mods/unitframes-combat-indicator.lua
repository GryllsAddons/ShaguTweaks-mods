local module = ShaguTweaks:register({
    title = "Unit Frame Combat Indicator",
    description = "Adds a combat indicator to the target frame",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
  })
  
module.enable = function(self)

    local f = CreateFrame("Frame", "TargetCombatIndicator", TargetFrame)
    f.indicator = f:CreateTexture(nil, "OVERLAY")
    --f.indicator:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
    f.indicator:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
    f.indicator:SetTexCoord(0.50, 1.0, 0.0, 0.49)
    f.indicator:SetWidth(32)
    f.indicator:SetHeight(32)
    --f.indicator:SetPoint("Right", TargetFrame, 0, 5)
    f.indicator:SetPoint("CENTER", TargetFrame, 65, -13)
    f.indicator:Hide()

    f.glow = f:CreateTexture(nil, "OVERLAY")
    f.glow:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
    f.glow:SetBlendMode("ADD")
    f.glow:SetTexCoord(0.50, 1.0, 0.50, 1.0)
    f.glow:SetVertexColor(1,0,0)
    f.glow:SetPoint("TOPLEFT", f.indicator, -1, 1)
    f.glow:SetPoint("BOTTOMRIGHT", f.indicator, 1, -1)
    f.glow:SetAlpha(0) -- for fade
    f.glow:Hide()

    local function updateIndicator(unit, frame)
        if frame then
            if UnitExists(unit) then
                frame:SetScript("OnUpdate", function()
                    local inCombat = UnitAffectingCombat(unit)
                    if inCombat then
                        TargetLevelText:Hide()
                        frame.indicator:Show()
                        frame.glow:Show() -- comment out for blink
                        --frame.statusTexture:Show()

                        -- blinking glow
                        -- local time = GetTime()
                        -- if ( time >= frame.timerEnd ) then
                        --     frame.timerEnd = time + frame.tickRate

                        --     if frame.glow:IsVisible() then
                        --         frame.glow:Hide()
                        --     else
                        --         frame.glow:Show()
                        --     end
                        -- end

                        -- pulsing glow if we are attacking the mob otherwise static glow
                        if PlayerStatusGlow:IsVisible() then
                            local alpha = PlayerStatusGlow:GetAlpha()
                            frame.glow:SetAlpha(alpha)
                        else
                            frame.glow:SetAlpha(1)
                        end
                    else
                        TargetLevelText:Show()
                        frame.indicator:Hide()
                        frame.glow:Hide()
                        --frame.statusTexture:Hide()
                    end
                end)
            else
                frame:SetScript("OnUpdate", nil)
            end
        end
    end

    local events = CreateFrame("Frame")
    events:RegisterEvent("PLAYER_TARGET_CHANGED")

    events:SetScript("OnEvent", function()
        updateIndicator("target", TargetCombatIndicator)
    end)
end