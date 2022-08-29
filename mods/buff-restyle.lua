-- Based on zUI skinning (https://github.com/Ko0z/zUI)
-- Credit to Ko0z (https://github.com/Ko0z/)

local _G = _G or getfenv(0)

local module = ShaguTweaks:register({
    title = "Buff Restyle",
    description = "Restyles buff and debuff font and timer",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
  })
  
module.enable = function(self)

    -- Buff font
    local font, size, outline = "Fonts\\FRIZQT__.TTF", 9, "OUTLINE"
    local yoffset = 3
    local f = CreateFrame("Frame", nil, GryllsMinimap)
    f:SetFrameStrata("HIGH")

    local function buffText(buffButton)
        -- remove spaces from buff durations
        local duration = getglobal(buffButton:GetName().."Duration");
        local durationtext = duration:GetText()
        if durationtext ~= nil then
            local timer = string.gsub(durationtext, "%s+", "")
            duration:SetText(timer)
        end
    end

    for i = 0, 2 do
        for _, v in pairs(
                {
                _G['TempEnchant'..i..'Duration'],
            }
        ) do
            local b = _G['TempEnchant'..i]
            v:SetFont(font, size, outline)
            v:ClearAllPoints()
            v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
            v:SetParent(f)            

            local f = CreateFrame("Frame", nil, b)
            f:SetScript("OnUpdate", function()
                buffText(b)
            end)
        end
    end

    for i = 0, 23 do
        for _, v in pairs(
                {
                _G['BuffButton'..i..'Duration'],
            }
        ) do
            local b = _G['BuffButton'..i]
            v:SetFont(font, size, outline)
            v:ClearAllPoints()
            v:SetPoint("CENTER", b, "BOTTOM", 0, yoffset)
            v:SetParent(f)            

            local f = CreateFrame("Frame", nil, b)
            f:SetScript("OnUpdate", function()
                buffText(b)
            end)
        end
    end
end