local module = ShaguTweaks:register({
    title = "Central Interaction Windows",
    description = "Interaction windows will be positioned centrally.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local skip = { UIOptionsFrame }

    local function check(frame)
        for _, f in pairs(skip) do
            if f == frame then
                frame:ClearAllPoints()
                frame:SetAllPoints(UIParent)
                return true
            end
        end
    end

    local function move(p1, p2)
        if p1 and p2 then
            p2:ClearAllPoints()
            p2:SetPoint("CENTER", "UIParent", "CENTER", -384, 0)
            p1:ClearAllPoints()
            p1:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        elseif p1 then
            p1:ClearAllPoints()
            p1:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        elseif p2 then
            p2:ClearAllPoints()
            p2:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        end
    end

    local HookSetDoublewideFrame = SetDoublewideFrame
    function SetDoublewideFrame(frame)
        HookSetDoublewideFrame(frame)
        local skip = check(frame)
        if skip then return end
        local frame = UIParent.doublewide or nil
        if frame then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        end
    end

    local HookSetLeftFrame = SetLeftFrame
    function SetLeftFrame(frame)
        HookSetLeftFrame(frame)
        local skip = check(frame)
        if skip then return end
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        move(left, center)
    end

    local HookMovePanelToLeft = MovePanelToLeft
    function MovePanelToLeft(frame)
        HookMovePanelToLeft(frame)
        local skip = check(frame)
        if skip then return end
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        move(left, center)
    end

    local HookSetCenterFrame = SetCenterFrame
    function SetCenterFrame(frame)
        HookSetCenterFrame(frame)
        local skip = check(frame)
        if skip then return end
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        move(center, left)
    end    
end