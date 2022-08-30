local _G = _G or getfenv(0)

local module = ShaguTweaks:register({
  title = "Unit Frame ToT Class Portraits",
  description = "Extends class portraits to Target of Target.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Unit Frames",
  enabled = nil,
})

local addonpath
local tocs = { "", "-master", "-tbc", "-wotlk" }
for _, name in pairs(tocs) do
  local current = string.format("ShaguTweaks%s", name)
  local _, title = GetAddOnInfo(current)
  if title then
    addonpath = "Interface\\AddOns\\" .. current
    break
  end
end

local CLASS_ICON_TCOORDS = {
    ["WARRIOR"] = { 0, 0.25, 0, 0.25 },
    ["MAGE"] = { 0.25, 0.49609375, 0, 0.25 },
    ["ROGUE"] = { 0.49609375, 0.7421875, 0, 0.25 },
    ["DRUID"] = { 0.7421875, 0.98828125, 0, 0.25 },
    ["HUNTER"] = { 0, 0.25, 0.25, 0.5 },
    ["SHAMAN"] = { 0.25, 0.49609375, 0.25, 0.5 },
    ["PRIEST"] = { 0.49609375, 0.7421875, 0.25, 0.5 },
    ["WARLOCK"] = { 0.7421875, 0.98828125, 0.25, 0.5 },
    ["PALADIN"] = { 0, 0.25, 0.5, 0.75 },
    ["DEATHKNIGHT"] = { 0.25, .5, 0.5, .75 },
  }

local function UpdatePortraits(frame, unit)
    local portrait = nil

    if frame == TargetTargetFrame then
        portrait = TargetofTargetPortrait
    else
        portrait = frame.portrait
    end

    -- detect unit class or remove for non-player units
    local _, class = UnitClass(unit)
    class = UnitIsPlayer(unit) and class or nil    

    -- update class icon if possible
    if class then
        local iconCoords = CLASS_ICON_TCOORDS[class]
        portrait:SetTexture(addonpath .. "\\img\\UI-Classes-Circles")
        portrait:SetTexCoord(unpack(iconCoords))
    elseif not class then
        portrait:SetTexCoord(0, 1, 0, 1)
    end
end

local targeting = CreateFrame("Frame", nil, UIParent)
local name

local function portraitToT()
    if UnitExists("target") then        
        targeting:SetScript("OnUpdate", function()
            if UnitExists("targettarget") then        
                if GetUnitName("targettarget") ~= name then
                    name = GetUnitName("targettarget")
                    UpdatePortraits(TargetTargetFrame, "targettarget")
                end
            end
        end)
    else
        targeting:SetScript("OnUpdate", nil)
    end
end

module.enable = function(self)

  local events = CreateFrame("Frame", nil, UIParent)
  events:RegisterEvent("PLAYER_TARGET_CHANGED")

  events:SetScript("OnEvent", function()
    portraitToT()
  end)

end