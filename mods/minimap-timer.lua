local T = ShaguTweaks.T

local module = ShaguTweaks:register({
  title = T["MiniMap Timer"],
  description = T["Adds a togglable timer to the minimap clock. Left click the clock to toggle the timer. Left click the timer to start/pause or right click to reset. Hold Ctrl & Shift then drag to move, hold Ctrl & Shift then right click to reset position."],
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  category = T["World & MiniMap"],
  enabled = nil,
})

MinimapTimer = CreateFrame("Button", "MinimapTimer", Minimap)
MinimapTimer:Hide()
MinimapTimer:SetFrameStrata("MEDIUM")
MinimapTimer:SetFrameLevel(65)
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
  local ElapsedTimer = CreateFrame("FRAME", nil, MinimapTimer)
  ElapsedTimer:Hide()

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

  local function toggletimer()
    resettimer()
    if (not MinimapTimer:IsVisible()) then
      MinimapTimer:Show()
    else
      MinimapTimer:Hide()
    end
  end

  local function timerscripts()    
    if (MinimapClock and MinimapClock:IsVisible()) then
      MinimapClock:SetScript("OnMouseDown", toggletimer)
    elseif GameTimeFrame:IsVisible() then
      GameTimeFrame:SetScript("OnMouseDown", toggletimer)
    end
  end

  local function timervisibility()
    if ((MinimapClock and MinimapClock:IsVisible()) or (GameTimeFrame:IsVisible())) then
      MinimapTimer:Hide()
    else
      MinimapTimer:Show()
    end
  end

  local function positiontimer()
    MinimapTimer:ClearAllPoints()
    if (MinimapClock and MinimapClock:IsVisible()) then
      MinimapTimer:SetPoint("TOP", MinimapClock, "BOTTOM")
    else
      MinimapTimer:SetPoint("TOP", Minimap, "BOTTOM", 0, -12)   
    end
  end

  MinimapTimer:SetMovable(true)
  MinimapTimer:SetClampedToScreen(true)
  MinimapTimer:SetUserPlaced(true)
  MinimapTimer:EnableMouse(true)
  MinimapTimer:RegisterForDrag("LeftButton")
  MinimapTimer:SetScript("OnDragStart", function() 
      if (IsShiftKeyDown() and IsControlKeyDown()) then
        this:StartMoving()
      end
  end)
  MinimapTimer:SetScript("OnDragStop", function() this:StopMovingOrSizing() end)
  MinimapTimer:RegisterForClicks("LeftButtonUp","RightButtonUp")
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
      if (IsShiftKeyDown() and IsControlKeyDown()) then
        this:SetUserPlaced(false)
        this:Hide()
        resettimer()
        positiontimer()
        timervisibility()
      else
        resettimer()
      end
    end
  end)

  ElapsedTimer:SetScript("OnUpdate", function()
    timerelapsed = GetTime() - timerstarted    
    if timerelapsed > timermax then
      timerelapsed = timermax
      this:Hide()
    else
      updatetext()
    end
  end)

  timerscripts()
  resettimer()
  positiontimer()
  timervisibility()
end
