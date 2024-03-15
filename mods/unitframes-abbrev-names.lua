local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Unit Frame Abbreviated Names"],
    description = T["Abbreviates long unit names."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Unit Frames"],
    enabled = nil,
})

module.enable = function(self)
    local function abbrevname(t)
        return string.sub(t,1,1)..". "
    end

    local function getNameString(unitstr)
        local name = UnitName(unitstr)
        local size = 15

        -- first try to only abbreviate the first word
        if name and strlen(name) > size then
            name = string.gsub(name, "^(%S+) ", abbrevname)
        end

        -- abbreviate all if it still doesn't fit
        if name and strlen(name) > size then
            name = string.gsub(name, "(%S+) ", abbrevname)
        end

        return name
    end

    local function abbrevName(frame, unit)
        local name = getNameString(unit)
        if name and frame.name then
            frame.name:SetText(name)
        end
    end

    local target = CreateFrame("Frame")
    target:RegisterEvent("PLAYER_TARGET_CHANGED")
    target:SetScript("OnEvent", function()
        abbrevName(TargetFrame, "target")
    end)

    local tot = CreateFrame("Frame", nil, TargetFrame)
    tot:SetScript("OnUpdate", function()
        abbrevName(TargetofTargetFrame, "targettarget")
    end)
end