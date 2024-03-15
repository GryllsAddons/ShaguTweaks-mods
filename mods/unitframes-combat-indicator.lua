local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Unit Frame Combat Indicator"],
    description = T["Adds a combat indicator to the target and party frames."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Unit Frames"],
    enabled = nil,
})

module.enable = function(self)
    local function createTargetIndicator()
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
        f.glow:SetAlpha(0)
        f.glow:Hide()

        f.lastUpdate = GetTime()
        f.refreshTime = 0.1

        f:SetScript("OnUpdate", function()
            local elapsed = GetTime() - this.lastUpdate
            if elapsed >= this.refreshTime then
                this.lastUpdate = GetTime()

                local inCombat = UnitAffectingCombat("target")
                if inCombat then
                    TargetLevelText:Hide()
                    f.indicator:Show()
                    f.glow:Show()

                    -- pulsing glow if we are attacking the mob otherwise static glow
                    if PlayerStatusGlow:IsVisible() then
                        local alpha = PlayerStatusGlow:GetAlpha()
                        f.glow:SetAlpha(alpha)
                    else
                        f.glow:SetAlpha(1)
                    end
                else
                    TargetLevelText:Show()
                    f.indicator:Hide()
                    f.glow:Hide()
                end
            end
        end)
    end

    local function updateTargetIndicator()
        if UnitExists("target") then
            TargetCombatIndicator:Show()
        else
            TargetCombatIndicator:Hide()
        end
    end

    local function createPartyIndicators()
        for i = 1, MAX_PARTY_MEMBERS do
            local frame = _G["PartyMemberFrame"..i]
            local p = CreateFrame("Frame", "PartyCombatIndicator"..i, frame)
            p.indicator = p:CreateTexture(nil, "OVERLAY")
            p.indicator:SetTexture("Interface\\CharacterFrame\\UI-StateIcon")
            p.indicator:SetTexCoord(0.50, 1.0, 0.0, 0.49)
            -- p.indicator:SetTexture("Interface\\Icons\\ABILITY_DUALWIELD")
            p.indicator:SetWidth(24)
            p.indicator:SetHeight(24)
            -- p.indicator:SetPoint("RIGHT", frame.name, "LEFT", 0, -2)
            p.indicator:SetPoint("LEFT", frame.healthbar, "RIGHT", 1, -4)
            p.indicator:Hide()

            p.lastUpdate = GetTime()
            p.refreshTime = 0.5 -- twice per second

            p:SetScript("OnUpdate", function()
                local elapsed = GetTime() - this.lastUpdate
                if elapsed >= this.refreshTime then
                    this.lastUpdate = GetTime()

                    local id = this:GetParent():GetID()
                    local unit = "party"..id

                    local inCombat = UnitAffectingCombat(unit)
                    if inCombat then
                        -- DEFAULT_CHAT_FRAME:AddMessage(unit.." inCombat")
                        p.indicator:Show()
                    else
                        -- DEFAULT_CHAT_FRAME:AddMessage(unit.." NOT inCombat")
                        p.indicator:Hide()
                    end
                end
            end)
        end
    end

    local function updatePartyIndicators()
        if GetNumPartyMembers() == 0 then return end
        for i = 1, GetNumPartyMembers() do
            local p = _G["PartyCombatIndicator"..i]
            if GetPartyMember(i) then
                p:Show()
            else
                p:Hide()
            end
        end
    end

    local events = CreateFrame("Frame")
    events:RegisterEvent("PLAYER_ENTERING_WORLD")
    events:RegisterEvent("PLAYER_TARGET_CHANGED")
    events:RegisterEvent("PARTY_MEMBERS_CHANGED")

    events:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            if not this.loaded then
                this.loaded = true
                createTargetIndicator()
                createPartyIndicators()
            end
            updatePartyIndicators()
        elseif event == "PLAYER_TARGET_CHANGED" then
            updateTargetIndicator()
        elseif event == "PARTY_MEMBERS_CHANGED" then
            updatePartyIndicators()
        end
    end)
end
