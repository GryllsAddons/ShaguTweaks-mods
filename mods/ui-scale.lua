local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Set UI Scale"],
    description = T["Sets the pixel perfect UI scale for your resolution."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Graphics"],
    enabled = nil,
})

module.enable = function(self)
    local function pixelperfect()
        local resolution = GetCVar("gxResolution")
        local _, _, screenwidth, screenheight = strfind(resolution, "(.+)x(.+)")
        screenwidth = tonumber(screenwidth)
        screenheight = tonumber(screenheight)
        local scale = 768 / screenheight        
        SetCVar("useUiScale", 1)
        SetCVar("uiScale", scale)
        UIParent:SetScale(scale)
    end

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
        pixelperfect()
    end)
end