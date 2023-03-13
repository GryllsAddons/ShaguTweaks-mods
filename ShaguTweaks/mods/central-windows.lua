local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
    title = "Central Interaction Windows",
    description = "Interaction windows will be positioned centrally.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    local function SetDoublewideFrame()
        -- DEFAULT_CHAT_FRAME:AddMessage("SetDoublewideFrame")
        local frame = UIParent.doublewide or nil
        if frame then
            frame:ClearAllPoints()
            frame:SetPoint("CENTER", "UIParent", "CENTER", 0, 0)
        end
    end

    local function movePanels(p1, p2)
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

    local function SetLeftFrame()
        -- DEFAULT_CHAT_FRAME:AddMessage("SetLeftFrame")
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        movePanels(left, center)
    end

    local function MovePanelToLeft()
        -- DEFAULT_CHAT_FRAME:AddMessage("MovePanelToLeft")
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        movePanels(left, center)
    end

    local function SetCenterFrame()
        -- DEFAULT_CHAT_FRAME:AddMessage("SetCenterFrame")
        local left = UIParent.left or nil
        local center = UIParent.center or nil
        movePanels(center, left)
    end
    
    hooksecurefunc("SetDoublewideFrame", SetDoublewideFrame, true)
    hooksecurefunc("SetLeftFrame", SetLeftFrame, true)
    hooksecurefunc("MovePanelToLeft", MovePanelToLeft, true)
    hooksecurefunc("SetCenterFrame", SetCenterFrame, true)
end