local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Auction Search Timer"],
    description = T["The auction search button will show the time remaining until you can search the auction house."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = nil,
    enabled = nil,
})

module.enable = function(self)
    -- Inspired by https://github.com/EinBaum/AuctionSearchTimer

    local timermax
    local timerstarted
    local timerremaining
    local buttontext
    local buttonscript

    local function formattime(t)
        if t then
            local time = floor(t)
            local hours = floor(mod(t,86400)/3600)
            local minutes = floor(mod(t,3600)/60)
            local seconds = floor(mod(t,60))
            local tenths = floor((t - time) * 10)
            return seconds
        else
          return 0
        end
    end

    local function updatetext()
        local s = formattime(timerremaining)
        BrowseSearchButton:SetText(format("%d",s))
    end

    local function starttimer()
        timerstarted = GetTime()
        RemainingTimer:Show()
    end
    
    local function resettimer()
        RemainingTimer:Hide()
        timermax = 6
        timerstarted = nil
        timerremaining = nil
        BrowseSearchButton:SetText(buttontext)       
    end

    RemainingTimer = CreateFrame("FRAME", nil, BrowseSearchButton)
    RemainingTimer:Hide()
    RemainingTimer:SetScript("OnUpdate", function()
        timerremaining = timermax - (GetTime() - timerstarted)
        if (CanSendAuctionQuery()) or (timerremaining < 0) or (timerremaining > timermax) then            
            resettimer()
        else
            updatetext()
        end
    end)

    local events = CreateFrame("Frame", nil, UIParent)
    events:RegisterEvent("AUCTION_HOUSE_SHOW")
    events:RegisterEvent("AUCTION_HOUSE_CLOSED")

    events:SetScript("OnEvent", function()
        if (event == "AUCTION_HOUSE_SHOW") then
            if (not buttontext) then
                buttontext = BrowseSearchButton:GetText()
            end

            if (not buttonscript) then
                BrowseSearchButton:SetScript("OnClick", function()
                    starttimer()
                    AuctionFrameBrowse_Search()
                end)
                buttonscript = true
            end
            resettimer()
        elseif (event == "AUCTION_HOUSE_CLOSED") then
            resettimer()
        end
    end)
end