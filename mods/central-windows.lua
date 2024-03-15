local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Central Interaction Windows"],
    description = T["Interaction windows will be positioned centrally."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local HookSetLeftFrame = SetLeftFrame
    local HookSetDoublewideFrame = SetDoublewideFrame
    local HookMovePanelToLeft = MovePanelToLeft
    local HookSetCenterFrame = SetCenterFrame

    local special = { UIOptionsFrame, MailFrame }

    local function check(frame)
        for _, f in pairs(special) do
            if f == frame then
                frame:ClearAllPoints()
                if frame == UIOptionsFrame then
                    frame:SetAllPoints(UIParent)
                    return true
                elseif frame == MailFrame then
                    frame:SetPoint("CENTER", "UIParent", "CENTER", -384, 0)
                    HookSetCenterFrame(nil) -- set prev left frame to nil
                    return true
                end
            end
        end

        if frame ~= MailFrame then
            if MailFrame:IsVisible() then
                if UIParent.left == MailFrame then
                    MailFrame:ClearAllPoints()
                    MailFrame:SetPoint("CENTER", "UIParent", "CENTER", -384, 0)
                    if frame then
                        frame:ClearAllPoints()
                        frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
                    end
                    return true
                end
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


    function SetDoublewideFrame(frame)
        HookSetDoublewideFrame(frame)
        local special = check(frame)
        if special then return end
        local frame = UIParent.doublewide or nil
        if frame then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        end
    end


    function SetLeftFrame(frame)
        HookSetLeftFrame(frame)
        local special = check(frame)
        if special then return end
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        move(left, center)
    end


    function MovePanelToLeft(frame)
        HookMovePanelToLeft(frame)
        local special = check(frame)
        if special then return end
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        move(left, center)
    end


    function SetCenterFrame(frame)
        HookSetCenterFrame(frame)
        local special = check(frame)
        if special then return end
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        move(center, left)
    end
end