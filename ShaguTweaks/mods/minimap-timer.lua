local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "MiniMap Timer",
  description = "Adds a togglable timer to the minimap clock. Left click the clock to toggle the timer. Left click the timer to start/pause or right click to reset.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = "World & MiniMap",
  enabled = nil,
})

MinimapTimer = CreateFrame("BUTTON", "Timer", Minimap)
MinimapTimer:Hide()
MinimapTimer:SetFrameLevel(64)
MinimapTimer:SetWidth(70)
MinimapTimer:SetHeight(23)
MinimapTimer:SetBackdrop({
  bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
  edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
  tile = true, tileSize = 8, edgeSize = 16,
  insets = { left = 3, right = 3, top = 3, bottom = 3 }
})
MinimapTimer:SetBackdropBorderColor(.9,.8,.5,1)
MinimapTimer:SetBackdropColor(.4,.4,.4,1)

module.enable = function(self)
  MinimapTimer:EnableMouse(true)
  local timertext = MinimapTimer:CreateFontString("Status", "LOW", "GameFontNormal")
  timertext:SetFont(STANDARD_TEXT_FONT, 12, "OUTLINE")
  timertext:SetFontObject(GameFontWhite)
  timertext:SetAllPoints(MinimapTimer)

  local timermax = 99 * 3600 + 59 * 60 + 59 -- 99:59:59
  local timerstarted = nil
  local timerelapsed = nil
  local timerpaused = nil
  
  local function formattime(e)
    if e then
      local t = floor(e)
      local h = floor(mod(t,86400)/3600)
      local m = floor(mod(t,3600)/60)
      local s = floor(mod(t,60))
      return h, m, s
    else
      return 0, 0, 0
    end
  end

  local function updatetext()
    local h,m,s = formattime(timerelapsed)
   timertext:SetText(format("%02d:%02d:%02d",h,m,s))
  end

  local function starttimer()
    timerstarted = GetTime()
    ElapsedTimer:Show()
  end

  local function stoptimer()
    ElapsedTimer:Hide()
  end

  local function resettimer()
    stoptimer()
    timerstarted = nil
    timerelapsed = nil
    timerpaused = nil
    updatetext()    
  end

  local function pausetimer()
    stoptimer()
    timerpaused = GetTime()
  end

  local function continuetimer()
    timerstarted = timerstarted + (GetTime() - timerpaused)
    timerpaused = nil
    ElapsedTimer:Show()
  end

  local function hidetimer()
    resettimer()
    MinimapTimer:Hide()
  end

  ElapsedTimer = CreateFrame("FRAME", nil, MinimapTimer)
  ElapsedTimer:Hide()
  ElapsedTimer:SetScript("OnUpdate", function()
    timerelapsed = GetTime() - timerstarted    
    if timerelapsed > timermax then
      timerelapsed = timermax
      this:Hide()
    else
      updatetext()
    end
  end)  

  MinimapTimer:RegisterForClicks("LeftButtonDown","RightButtonDown")
  MinimapTimer:SetScript("OnClick", function()
      if (arg1 == "LeftButton") then
        if timerpaused then
          continuetimer()          
        elseif not timerstarted then
          starttimer()
        else
          pausetimer()
        end        
      elseif (arg1 == "RightButton") then
        resettimer()
      end
  end)

  local function setuptimer()
    local function toggle()
      resettimer()
      if not MinimapTimer:IsVisible() then
        MinimapTimer:Show()
      else
        MinimapTimer:Hide()
      end
    end

    if MinimapClock and MinimapClock:IsVisible() then
      MinimapTimer:SetPoint("TOP", MinimapClock, "BOTTOM")
      MinimapClock:SetScript("OnMouseDown", toggle)
    elseif GameTimeFrame:IsVisible() then
      MinimapTimer:SetPoint("TOP", Minimap, "BOTTOM", 0, -12)
      GameTimeFrame:SetScript("OnMouseDown", toggle)
    else
      MinimapTimer:SetPoint("TOP", Minimap, "BOTTOM", 0, -12)
      MinimapTimer:Show()
    end
  end

  local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("PLAYER_ENTERING_WORLD")

    events:SetScript("OnEvent", function()
      setuptimer()      
    end)
end
