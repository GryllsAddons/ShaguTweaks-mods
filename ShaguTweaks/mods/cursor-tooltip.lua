local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "Cursor Tooltip",
  description = "Attaches the tooltip to the cursor.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "Tooltip & Items",
  enabled = nil,
})

module.enable = function(self)

    function _G.GameTooltip_SetDefaultAnchor(tooltip, parent)
        tooltip:SetOwner(parent, "ANCHOR_CURSOR")
        
        -- create mouse follow frame
        if not tooltip.cursor then
            tooltip.cursor = CreateFrame("Frame", nil, UIParent)
            tooltip.cursor:SetWidth(10 * 2)
            tooltip.cursor:SetHeight(10 * 2)
            tooltip.cursor:SetScript("OnUpdate", function()
                local scale = UIParent:GetScale()
                local x, y = GetCursorPosition()
                this:SetPoint("CENTER", UIParent, "BOTTOMLEFT", x/scale, y/scale)
                tooltip.cursor:SetWidth(tooltip:GetWidth())                
            end)
        end
    
        -- adjust tooltip to mouse frame
        tooltip:SetPoint("CENTER", tooltip.cursor, "RIGHT", 15, 15)
    end

end
