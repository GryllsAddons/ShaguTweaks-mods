local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["What Happened to Me?"],
    description = T["Creates a 'What Happened to Me?' style chat tab."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Social & Chat"],
    enabled = nil,
})

module.enable = function(self)
    local tabname = T["What Happened to Me?"]
    -- Credit to @ericschn for the idea
    local function Create(frame)
        FCF_DockFrame(frame)
        FCF_SetWindowName(frame, tabname)
        FCF_SelectDockFrame(ChatFrame1)

        ChatFrame_RemoveAllMessageGroups(frame)
        ChatFrame_RemoveAllChannels(frame)

        local combat = {
            "COMBAT_SELF_HITS", -- when you hit a creature
            "COMBAT_SELF_MISSES", -- when a you miss a creature
            "COMBAT_PET_HITS", -- when your pet hits a creature
            "COMBAT_PET_MISSES", -- when your pet misses a creature
            "COMBAT_HOSTILEPLAYER_HITS", -- Hostile Players' Hits (no self alternative)
            "COMBAT_HOSTILEPLAYER_MISSES", -- Hostile Players' Misses (no self alternative)
            "COMBAT_CREATURE_VS_SELF_HITS", -- when a creature hits you or your pet
            "COMBAT_CREATURE_VS_SELF_MISSES", -- when a creature misses you or your pet
            "COMBAT_HOSTILE_DEATH", -- when any hostile NPC or player dies near you

            "SPELL_SELF_DAMAGE", -- whenever you cast a harmful spell
            "SPELL_SELF_BUFF", -- when you cast a beneficial spell
            "SPELL_PET_DAMAGE", -- Pet's Damage Spells
            "SPELL_PET_BUFF", -- Pet's Buff Spells
            "SPELL_HOSTILEPLAYER_DAMAGE", -- Hostile Players' Damage Spells
            "SPELL_HOSTILEPLAYER_BUFF", -- Hostile Players' Buff Spells
            "SPELL_CREATURE_VS_SELF_DAMAGE", -- Creature Damage Spells on You
            "SPELL_CREATURE_VS_SELF_BUFF", -- Creature Buff Spells on You
            "SPELL_DAMAGESHIELDS_ON_SELF", -- when a buff (or possibly item) damages an opponent (Thorns etc)
            "SPELL_AURA_GONE_SELF", -- whenever a buff or debuff wears off
            "SPELL_PERIODIC_SELF_DAMAGE", -- when you are debuffed, disarmed, silenced etc
            "SPELL_PERIODIC_SELF_BUFFS", -- when a buff is cast on you
        }

        for _,group in pairs(combat) do
            ChatFrame_AddMessageGroup(frame, group)
        end
    end

    local function Setup()
        local found
        local free

        for i= NUM_CHAT_WINDOWS, 1, -1 do
            local frame = _G["ChatFrame"..i]
            local tab = _G["ChatFrame"..i.."Tab"]
            local name = tab:GetText()
            -- check if ChatFrame is named "Chat x" (where x is a number)
            if string.find(name, "^Chat %d+$") then
                free = _G["ChatFrame"..i]
            end
            if tabname == name then
                found = true
                break
            end
        end

        if not found then
            Create(free)
        end
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        if not this.loaded then
            this.loaded = true
            Setup()
        end
    end)
end
