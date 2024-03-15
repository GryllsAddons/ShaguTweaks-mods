local _G = ShaguTweaks.GetGlobalEnv()
local T = ShaguTweaks.T
local hooksecurefunc = ShaguTweaks.hooksecurefunc

local module = ShaguTweaks:register({
  title = T["Real Health Numbers Extended"],
  description = T["Adds health numbers on ToT and party unit frames."],
  expansions = { ["vanilla"] = true, ["tbc"] = true },
  category = T["Unit Frames"],
  enabled = false,
})

module.enable = function(self)
  TargetofTargetFrame.StatusTexts = CreateFrame("Frame", nil, TargetofTargetFrame)
  TargetofTargetFrame.StatusTexts:SetAllPoints(TargetofTargetFrame)
  TargetofTargetFrame.StatusTexts:SetFrameStrata("LOW")
  TargetofTargetFrame.StatusTexts:SetFrameLevel(64)
  
  TargetofTargetHealthBar.TextString = TargetofTargetFrame.StatusTexts:CreateFontString("TargetofTargetHealthBarText")
  TargetofTargetHealthBar.TextString:SetPoint("CENTER", TargetofTargetHealthBar, "CENTER", -2, 0)

  TargetofTargetManaBar.TextString = TargetofTargetFrame.StatusTexts:CreateFontString("TargetofTargetManaBarText")
  TargetofTargetManaBar.TextString:SetPoint("CENTER", TargetofTargetManaBar, "CENTER", -2, 0)

  for _, frame in pairs( { TargetofTargetHealthBar, TargetofTargetManaBar }) do
    frame.TextString:SetFontObject("GameFontWhite")
    frame.TextString:SetFont(STANDARD_TEXT_FONT, 9, "OUTLINE")
    frame.TextString:SetHeight(32)
    frame.TextString:SetJustifyH("LEFT")
  end

  for i=1, 4 do
    local frame = _G["PartyMemberFrame"..i]
    local healthbar = _G["PartyMemberFrame"..i.."HealthBar"]
    local manabar = _G["PartyMemberFrame"..i.."ManaBar"]

    frame.StatusTexts = CreateFrame("Frame", nil, frame)
    frame.StatusTexts:SetAllPoints(frame)

    healthbar.TextString = frame.StatusTexts:CreateFontString("PartyMemberFrame"..i.."HealthBarText")
    healthbar.TextString:SetPoint("CENTER", healthbar, "CENTER", -2, 0)
    healthbar.TextString:SetFontObject("GameFontWhite")
    healthbar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    healthbar.TextString:SetHeight(32)
    healthbar.TextString:SetDrawLayer("OVERLAY")

    manabar.TextString = frame.StatusTexts:CreateFontString("PartyMemberFrame"..i.."ManaBarText")
    manabar.TextString:SetPoint("CENTER", manabar, "CENTER", -2, 0)
    manabar.TextString:SetFontObject("GameFontWhite")
    manabar.TextString:SetFont(STANDARD_TEXT_FONT, 10, "OUTLINE")
    manabar.TextString:SetHeight(32)
    manabar.TextString:SetDrawLayer("OVERLAY")
    
    TextStatusBar_UpdateTextString(healthbar)
    TextStatusBar_UpdateTextString(manabar)
  end

  local function UpdateToT()
    TextStatusBar_UpdateTextString(TargetofTargetHealthBar)
  end

  hooksecurefunc("TargetofTarget_Update", UpdateToT, true)
end
