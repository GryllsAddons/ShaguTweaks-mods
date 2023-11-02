local module = ShaguTweaks:register({
    title = "Gryphons in Front",
    description = "Puts the gryphons in front of the action buttons.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Action Bar",
    enabled = nil,
})

module.enable = function(self)
    frames = { MultiBarBottomLeft, MultiBarBottomRight }

    for _, frame in pairs(frames) do
        if frame then
            frame:SetFrameStrata("LOW")
        end
    end
end
