local module = ShaguTweaks:register({
  title = "Mouseover Cast",
  description = "Adds /stcast and /stcastself functions for use in macros.",
  expansions = { ["vanilla"] = true, ["tbc"] = false },
  enabled = false,
})

module.enable = function(self)
  _G.SLASH_STCAST1 = "/stcast"
  _G.SLASH_STCASTSELF1 = "/stcastself"

  function SlashCmdList.STCAST(msg)
    local oldt = true
    local unit = "mouseover"
    if not UnitExists(unit) then
        local frame = GetMouseFocus()
        if frame.label and frame.id then
          unit = frame.label .. frame.id
        elseif UnitExists("target") then
          unit = "target"
        elseif GetCVar("autoSelfCast") == "1" then
          unit = "player"
        else
          return
        end
    end
    
    if UnitIsUnit("target", unit) then oldt = nil end

    -- mute targeting sounds
    local _PlaySound = PlaySound
    PlaySound = function() end
    
    TargetUnit(unit)
    CastSpellByName(msg)

    if oldt then
        TargetLastTarget()
    end

    -- unmute
    PlaySound = _PlaySound
  end

  function SlashCmdList.STCASTSELF(msg)
    CastSpellByName(msg, 1)
  end
end
