-- Based on zUI skinning (https://github.com/Ko0z/zUI)
-- Credit to Ko0z (https://github.com/Ko0z/)

local module = ShaguTweaks:register({
    title = "Improved Interface Options",
    description = "Rescales the interface options menu and removes the background.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})
  
module.enable = function(self)
    UIOptionsFrame:SetScript("OnShow", function()
        -- default events
        UIOptionsFrame_Load();
        MultiActionBar_Update();
        MultiActionBar_ShowAllGrids();
        Disable_BagButtons();
        UpdateMicroButtons();

        -- customize
        UIOptionsBlackground:Hide()
        UIOptionsFrame:SetScale(.8)
    end)
end