local module = ShaguTweaks:register({
    title = "Hide UI Frames",
    description = "Hides the player and pet frame based on conditions. Additional configuration available in the .lua.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
  })
  
module.enable = function(self)

    local Hide = CreateFrame("Frame", nil, UIParent)
    
    local function Hide_addFrames()    
        --[[
            INSTRUCTIONS:

            Frames may need to be shown or hidden by using the following methods:
            "SetAlpha" - uses SetAlpha(1) and SetAlpha(0)
            "ShowHide" - uses Show() and Hide() 
            "EVENT" - uses RegisterEvent(EVENT) and UnregisterEvent(EVENT)

            Frames in Perma will be permanently hidden, frames in toggle will toggle visibility based on conditions.
            To add a frame, add the name to:
            1. The Perma section (1A) or Toggle section (1B) below
            2. For Perma frames add the framename to the Hide_permaFrames function (2A)
               For toggle frames add the framename to the Hide_toggleFrames function (2B)
            3. If using EVENT add the RegisterEvent(EVENT) and UnregisterEvent(EVENT) to the Hide_toggleFrames function (3A and 3B)
        ]]
    
        -- (1A)
        -- Perma section (use "Perma" only as the hide method)
            -- add frames
                -- example
                -- Hide.perma[FRAME] = "Perma"
                -- /example
            -- /add frames
        -- /Perma
    
        -- (1B)
        -- Toggle section  (use "SetAlpha", "ShowHide" or "EVENT" only as the hide method)
            -- add frames
                -- example
                -- Hide.toggle[FRAME] = "SetAlpha"
                -- Hide.toggle[FRAME] = "ShowHide"
                -- Hide.toggle[FRAME] = "PLAYER_UPDATE_RESTING" -- EVENT
                -- /example

                -- Blizzard frames 
                Hide.toggle[PlayerFrame] = "ShowHide"
                Hide.toggle[PlayerStatusGlow] = "PLAYER_UPDATE_RESTING"
            -- /add frames
        -- /Toggle
    end

    --[[
    local function Hide_CVAR() -- add/remove bars if interface options change    
        if MultiBarBottomLeft:IsVisible() then
            Hide.toggle[MultiBarBottomLeft] = "ShowHide"
        else
            Hide.toggle[MultiBarBottomLeft] = nil
        end
    
        if MultiBarBottomRight:IsVisible() then
            Hide.toggle[MultiBarBottomRight] = "ShowHide"
        else
            Hide.toggle[MultiBarBottomRight] = nil
        end
    
        if MultiBarLeft:IsVisible() then
            Hide.toggle[MultiBarLeft] = "ShowHide"
        else
            Hide.toggle[MultiBarLeft] = nil
        end
    
        if MultiBarRight:IsVisible() then
            Hide.toggle[MultiBarRight] = "ShowHide"
        else
            Hide.toggle[MultiBarRight] = nil
        end
    end
    ]]
    
    -- (2A)
    local function Hide_permaFrames()
        for _, frame in pairs({    
            -- add frames
                -- example
                -- FRAME,
                -- /example

            -- /add frames
        }) do
            if Hide.perma[frame] == "Perma" then
                if (frame:GetObjectType() ~= 'Texture') then
                    frame:SetScript('OnEvent', nil)
                    frame:UnregisterAllEvents()
                end
                frame:SetParent(nil)
                frame:Hide()
            end
        end
    end

    -- (2B)
    local function Hide_toggleFrames(show)
        for _, frame in pairs({
            -- add frames
                -- example
                -- FRAME,
                -- /example

                -- Blizzard
                PlayerFrame,
                PlayerStatusGlow,
                -- MultiBarLeft,
                -- MultiBarRight,
            -- /add frames
        }) do
            -- three methods to toggle - SetAlpha, ShowHide and EVENT
            if Hide.toggle[frame] ~= nil then
                if show then
                    -- Show frames
                    if Hide.toggle[frame] == "SetAlpha" then
                        frame:SetAlpha(1)
                    elseif Hide.toggle[frame] == "ShowHide" then
                        frame:Show()
                    else
                        -- we are using an event
                        if Hide.toggle[frame] == "PLAYER_UPDATE_RESTING" then
                            frame:RegisterEvent("PLAYER_UPDATE_RESTING")
                            -- (3A)
                            -- Add further events here following the template below
                            -- elseif Hide.toggle[frame] == "EVENT" then
                            --     frame:UnregisterEvent("EVENT")                            
                        end    
                    end
                else
                    -- Hide frames
                    if Hide.toggle[frame] == "SetAlpha" then
                        frame:SetAlpha(0)
                    elseif Hide.toggle[frame] == "ShowHide" then
                        frame:Hide()
                    else
                        -- we are using an event
                        if Hide.toggle[frame] == "PLAYER_UPDATE_RESTING" then                            
                            frame:UnregisterEvent("PLAYER_UPDATE_RESTING")
                        -- (3B)
                        -- Add further events here following the template below
                        -- elseif Hide.toggle[frame] == "EVENT" then
                        --     frame:UnregisterEvent("EVENT")
                        end                        
                        
                    end
                end
            end
        end
    end

    local function Hide_isCasting()
        if CastingBarFrame.casting or CastingBarFrame.channeling then
            return true
        else
            return false
        end
    end
    
    local function Hide_fullHealth()
        if UnitHealth("player") == UnitHealthMax("player") then
            return true
        else
            return false
        end
    end
    
    local function Hide_fullPower()
        local powerType = UnitPowerType("player") -- 0 = mana, 3 = energy    
        if (powerType == 0) or (powerType == 3) then -- mana / energy
            if UnitMana("player") == UnitManaMax("player") then  -- if we are at full mana / energy
                return true
            else
                return false
            end
            --[[
        elseif (powerType == 1) then -- rage
            if UnitMana("player") = 0 then
                return true
            else
                return false
            end
            ]]
        else
            return true
        end
    end
    
    local function Hide_pet()
        if UnitExists("pet") then        
            local function petHappy()
                if UnitCreatureType("pet") == "Beast" then -- Hunter pet
                    if GetPetHappiness() > 1 then
                        return true
                    else
                        return false
                    end
                else -- Warlock pet
                    return true
                end
            end
            
            -- pet has full health and is content/happy
            if (UnitHealth("pet") == UnitHealthMax("pet")) and petHappy() then
                return true
            else
                return false
            end
        else -- no pet
            return true
        end
    end

    local function Hide_conditions()
        -- if player has no target, player and pet are full health & power, pet is happy, player is not in combat and is not casting a spell
        if (not UnitExists("target")) and Hide_fullHealth() and Hide_fullPower() and Hide_pet() and (not UnitAffectingCombat("player")) and (not Hide_isCasting()) then
            Hide_toggleFrames(false)
        else
            Hide_toggleFrames(true)
        end
    end
    
    Hide:RegisterEvent("PLAYER_ENTERING_WORLD")
    Hide:RegisterEvent("PLAYER_TARGET_CHANGED")
    Hide:RegisterEvent("UNIT_HEALTH", "player")
    Hide:RegisterEvent("UNIT_MANA", "player")
    Hide:RegisterEvent("UNIT_ENERGY", "player")    
    Hide:RegisterEvent("SPELLCAST_START")
    Hide:RegisterEvent("SPELLCAST_CHANNEL_START")
    Hide:RegisterEvent("SPELLCAST_STOP")
    Hide:RegisterEvent("SPELLCAST_FAILED")
    Hide:RegisterEvent("SPELLCAST_INTERRUPTED")
    Hide:RegisterEvent("SPELLCAST_CHANNEL_STOP")
    Hide:RegisterEvent("PLAYER_REGEN_DISABLED") -- in combat
    Hide:RegisterEvent("PLAYER_REGEN_ENABLED") -- out of combat
    -- this:RegisterEvent("CVAR_UPDATE")

    Hide:SetScript("OnEvent", function()
        if event == "PLAYER_ENTERING_WORLD" then
            if not Hide.toggle then       
                Hide.toggle = {}
                Hide.perma = {}
                Hide_addFrames()
                Hide_permaFrames()
                -- Hide_CVAR()
                Hide_conditions()
            end
        elseif event == "PLAYER_TARGET_CHANGED" or "PLAYER_REGEN_ENABLED" then
            Hide_conditions()
        elseif event == "UNIT_HEALTH" or "UNIT_MANA" or "UNIT_ENERGY" then
            if arg1 == "player" then
                Hide_conditions()
            end
        elseif event == "SPELLCAST_START" or "SPELLCAST_CHANNEL_START" then
            if arg1 == "player" then
                Hide_toggleFrames(true)
            end
        elseif event == "SPELLCAST_STOP" or "SPELLCAST_FAILED" or "SPELLCAST_INTERRUPTED" or "SPELLCAST_CHANNEL_STOP" then
            if arg1 == "player" then
                if (not Hide_isCasting()) then
                    Hide_toggleFrames()
                end
            end
        elseif event == "PLAYER_REGEN_DISABLED" or "PLAYER_REGEN_ENABLED" then
            Hide_toggleFrames(true)
        -- elseif event == "CVAR_UPDATE" then
        --     Hide_CVAR()
        end
    end)

end