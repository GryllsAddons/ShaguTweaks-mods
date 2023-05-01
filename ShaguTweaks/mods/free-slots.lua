local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
    title = "Free slots",
    description = "Adds a free slot count to the backpack button.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Tooltip & Items",
    enabled = nil,
})
  
module.enable = function(self)
    local button = MainMenuBarBackpackButton
    button.text = MainMenuBarBackpackButton:CreateFontString("Status", "LOW", "GameFontNormal")
    button.text:SetFont(STANDARD_TEXT_FONT, 14, "OUTLINE")
    button.text:SetPoint("BOTTOMRIGHT", MainMenuBarBackpackButton, "BOTTOMRIGHT", -2, 2)
    button.text:SetJustifyH("RIGHT")
    button.text:SetFontObject(GameFontWhite)

    local function slots()
        local freeSlots = 0
        for i = 0, 4 do
            for slot = 1, GetContainerNumSlots(i) do
                local link = GetContainerItemLink(i, slot)
				if not (link) then 
					freeSlots = freeSlots + 1 
				end
            end
        end
        MainMenuBarBackpackButton.text:SetText(freeSlots)
    end
    slots()    

    local events = CreateFrame("Frame")
    events:RegisterEvent("BAG_UPDATE")

    events:SetScript("OnEvent", function()
        slots()
    end)
end