local _G = ShaguTweaks.GetGlobalEnv()
local libspell = ShaguTweaks.libspell

local module = ShaguTweaks:register({
    title = "Macro Icons & Cooldowns",
    description = "Show macro icons & cooldowns on the action bars.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
  local hooked = nil
  local gfind = string.gmatch or string.gfind

  local function ButtonMacroScan(bar,actionSlotStart)
    if not bar:IsVisible() then return end
    local actionSlot = actionSlotStart
    local actionSlotEnd = actionSlotStart+11

    if bar == MainMenuBar then
      prefix = "Action"
    elseif bar == BonusActionBarFrame then
      prefix = "BonusAction"
    else
      prefix = bar:GetName()
    end
    -- DEFAULT_CHAT_FRAME:AddMessage("prefix = "..tostring(prefix)) -- DEBUG

    local button, icon, cooldown
    -- scan all 12 slots in bar
    for slot = 1, 12 do
      button = _G[prefix.."Button"..slot]
      if not button then 
        -- DEFAULT_CHAT_FRAME:AddMessage("no button for prefix = "..tostring(prefix)..", actionSlotStart = "..actionSlotStart) -- DEBUG
        break 
      end

      icon = _G[prefix.."Button"..slot.."Icon"]
      cooldown = _G[prefix.."Button"..slot.."Cooldown"]

      local macro = GetActionText(actionSlot)
      if actionSlot > actionSlotEnd then
        break
      else
        actionSlot = actionSlot+1
      end     

      local spellslot = nil
      local booktype = nil
      
      if macro then
        local name, body, _
        for slot = 1, 36 do -- 36 macro slots
          name, _, body = GetMacroInfo(slot)
          if name == macro then break end
        end
  
        if name and body then
          local match
  
          for line in gfind(body, "[^%\n]+") do
            _, _, match = string.find(line, '^#showtooltip (.+)')
  
            if not match then
              -- add support to specify custom tooltips via:
              --  /run --showtooltip SPELLNAME
              _, _, match = string.find(line, '%-%-showtooltip (.+)')
            end
  
            if not match then
              _, _, match = string.find(line, '^/cast (.+)')
            end
  
            if not match then
              _, _, match = string.find(line, '^/stcast (.+)')
            end    

            if not match then
              _, _, match = string.find(line, 'CastSpellByName%(%"(.+)%"%)')
            end
  
            if match then
              local _, _, spell, rank = string.find(match, '(.+)%((.+)%)')
              spell = spell or match              
              button.spellslot, button.booktype = libspell.GetSpellIndex(spell, rank)

              -- icon
              -- overwrite with spell macro texture where possible
              local texture = GetActionTexture(slot)
              local start, duration, enable
              if button.spellslot and button.booktype then
                texture = GetSpellTexture(button.spellslot, button.booktype)
                start, duration = GetSpellCooldown(button.spellslot, button.booktype)
                enable = 1
              else
                start, duration, enable = GetActionCooldown(slot)
              end

              -- cooldown
              CooldownFrame_SetTimer(cooldown, start, duration, enable)

              if not texture then break end
              if texture ~= icon:GetTexture() then            
                icon:SetTexture(texture)
              end 
            end
          end
        end
      end      
    end
  end

  local function GetActiveBar()
    if CURRENT_ACTIONBAR_PAGE == 1 and GetBonusBarOffset() ~= 0 then
      return NUM_ACTIONBAR_PAGES + GetBonusBarOffset()
    else
      return CURRENT_ACTIONBAR_PAGE
    end
  end
  
  local function ScanBars()
    local bar = GetActiveBar()
    -- DEFAULT_CHAT_FRAME:AddMessage("GetActiveBar = "..bar)

    if bar == 1 then
      ButtonMacroScan(MainMenuBar,1)
    elseif bar == 2 then
      ButtonMacroScan(MainMenuBar,13)
      ButtonMacroScan(BonusActionBarFrame,13)
    elseif bar == 7 then
      ButtonMacroScan(BonusActionBarFrame,73)
    elseif bar == 8 then
      ButtonMacroScan(BonusActionBarFrame,85)
    elseif bar == 9 then
      ButtonMacroScan(BonusActionBarFrame,97)
    elseif bar == 10 then
      ButtonMacroScan(BonusActionBarFrame,109)
    end

    ButtonMacroScan(MultiBarRight,25)    
    ButtonMacroScan(MultiBarLeft,37)
    ButtonMacroScan(MultiBarBottomRight,49)
    ButtonMacroScan(MultiBarBottomLeft,61)
  end

  local events = CreateFrame("Frame", nil, UIParent)	
  events:RegisterEvent("PLAYER_ENTERING_WORLD")
  events:RegisterEvent("ACTIONBAR_SLOT_CHANGED")
  events:RegisterEvent("ACTIONBAR_PAGE_CHANGED")
  events:RegisterEvent("ACTIONBAR_SHOWGRID")
  events:RegisterEvent("UPDATE_BONUS_ACTIONBAR")  
  events:RegisterEvent("PLAYER_AURAS_CHANGED")
  events:RegisterEvent("UPDATE_SHAPESHIFT_FORMS")

  events:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
  events:RegisterEvent("ACTIONBAR_UPDATE_USABLE")
  events:RegisterEvent("ACTIONBAR_UPDATE_STATE")

  events:SetScript("OnEvent", function()
    ScanBars()
  end)
end