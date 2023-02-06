local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "Mouseover Cast",
  description = "Adds /stcast and /stcastself functions for use in macros.",
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  enabled = false,
})

module.enable = function(self)
  -- pfUI mouseover

  -- Prepare a list of units that can be used via SpellTargetUnit
  local st_units = { [1] = "player", [2] = "target", [3] = "mouseover" }
  for i=1, MAX_PARTY_MEMBERS do table.insert(st_units, "party"..i) end
  for i=1, MAX_RAID_MEMBERS do table.insert(st_units, "raid"..i) end

  -- Try to find a valid (friendly) unitstring that can be used for
  -- SpellTargetUnit(unit) to avoid another target switch
  local function GetUnitString(unit)
    for index, unitstr in pairs(st_units) do
      if UnitIsUnit(unit, unitstr) then
        return unitstr
      end
    end

    return nil
  end

  -- Same as CastSpellByName but with disabled AutoSelfCast
  local function NoSelfCast(spell, onself)
    local cvar_selfcast = GetCVar("AutoSelfCast")

    if cvar_selfcast ~= "0" then
      SetCVar("AutoSelfCast", "0")
      pcall(CastSpellByName, spell, onself)
      SetCVar("AutoSelfCast", cvar_selfcast)
    else
      CastSpellByName(spell, onself)
    end
  end

  _G.SLASH_STCAST1 = "/stcast"
  _G.SLASH_STCASTSELF1 = "/stcastself"


  function SlashCmdList.STCAST(msg)
    -- mute targeting sounds
    local _PlaySound = PlaySound
    PlaySound = function() end

    local restore_target = true
    local func = loadstring(msg or "")
    local unit = "mouseover"

    if not UnitExists(unit) then
      local frame = GetMouseFocus()
      if frame.label and frame.id then
        unit = frame.label .. frame.id
      elseif frame.unit then -- default unitframe support (self)
          unit = frame.unit
      elseif UnitExists("target") then
        unit = "target"
      elseif GetCVar("autoSelfCast") == "1" then
        unit = "player"
      else
        return
      end
    end

    -- HCWarn support
    if HCWarn_nointeract and (unit ~= "player") then
      if HCWarn_Check(unit) then 
        UIErrorsFrame:AddMessage("Mouseover unit is PVP flagged",1,0,0)
        return 
      end
    end

    -- If target and mouseover are friendly units, we can't use spell target as it
    -- would cast on the target instead of the mouseover. However, if the mouseover
    -- is friendly and the target is not, we can try to obtain the best unitstring
    -- for the later SpellTargetUnit() call.
    local unitstr = not UnitCanAssist("player", "target") and UnitCanAssist("player", unit) and GetUnitString(unit)

    if UnitIsUnit("target", unit) or (not func and unitstr) then
      -- no target change required, we can either use spell target
      -- or the unit is already our current target.
      restore_target = false
    else
      -- The spelltarget can't be used here, we need to switch
      -- and restore the target during spell cast
      TargetUnit(unit)
    end

    if func then
      func()
    else
      -- cast without self cast cvar setting
      -- to allow spells to use spelltarget
      NoSelfCast(msg)

      -- set spell target to unitstring (or selfcast)
      if SpellIsTargeting() then SpellTargetUnit((unitstr or "player")) end

      -- clean up spell target in error case
      if SpellIsTargeting() then SpellStopTargeting() end
    end

    if restore_target then
      TargetLastTarget()
    end

    -- unmute
    PlaySound = _PlaySound
  end

  function SlashCmdList.STCASTSELF(msg)
    CastSpellByName(msg, 1)
  end
end