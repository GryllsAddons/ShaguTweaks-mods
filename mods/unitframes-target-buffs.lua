local T = ShaguTweaks.T

local module = ShaguTweaks:register({
    title = T["Target Buffs Extended"],
    description = T["Show up to 16 buffs on the target unit frame and detect enemy buffs."],
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = T["Unit Frames"],
    enabled = nil,
})

module.enable = function(self)
	-- detect target buffs
	local L = ShaguTweaks.L
	-- register tooltip scanner
	local scanner = ShaguTweaks.libtipscan:GetScanner("unitframes")

	local detect_icon, detect_name
	local function DetectBuff(name, id)
		if not name or not id then return end
		-- clear previously assigned
		detect_icon, detect_name = nil, nil

		-- make sure the icon cache exists
		ShaguTweaks_cache.buff_icons = ShaguTweaks_cache.buff_icons or {}

		-- check the regular way
		detect_icon = UnitBuff(name, id)
		if detect_icon then
			if not L["spells"][detect_name] and not ShaguTweaks_cache.buff_icons[detect_icon] then
			-- read buff name and cache it
			scanner:SetUnitBuff(name, id)
			detect_name = scanner:Line(1)

			if detect_name then
				ShaguTweaks_cache.buff_icons[detect_icon] = detect_name
			end
			end

			-- return the regular function
			return UnitBuff(name, id)
		end

		-- try to guess the buff based on tooltips and icon caches
		scanner:SetUnitBuff(name, id)
		detect_name = scanner:Line(1)

		if detect_name then
			-- try to find the spell icon in locales
			if L["spells"][detect_name] then
			return "Interface\\Icons\\" .. L["spells"][detect_name].icon, 1
			end

			-- try to find the spell icon in caches
			for icon, name in pairs(ShaguTweaks_cache.buff_icons) do
			if name == detect_name then return icon, 1 end
			end

			-- return fallback image
			return "interface\\icons\\inv_misc_questionmark", 1
		end

		-- nothing found
		return nil
	end

	-- extend target buffs
	-- note: The default target frame shows 5 buffs and 16 debuffs
	local buffButtons = 16
	local debuffButtons = 16

	do -- create 11 additional buff buttons
		for i = 6, buffButtons do
			local button = CreateFrame("Button", "TargetFrameBuff"..i, TargetFrame, "TargetBuffButtonTemplate")
			button:SetID(i)
		end
	end

	local function resize()
		-- resize debuffs to full size
		local button, debuffFrame
		for i=1, debuffButtons do
			button = getglobal("TargetFrameDebuff"..i)
			debuffFrame = getglobal("TargetFrameDebuff"..i.."Border")
			button:SetWidth(21)
			button:SetHeight(21)
			debuffFrame:SetWidth(23)
			debuffFrame:SetHeight(23)
		end
	end

	local function BuffRows(frame, numButtons, rowLimit)
		-- position buffs in rows attached to the first buff/debuff
		local rowBuff = 1 -- the first buff on the last row of buffs/debuffs
		local added = 1 -- we have already got one buff in the row when we start
		for i = 2, numButtons do
			local button = getglobal(frame..i)
			button:ClearAllPoints()

			if added < rowLimit then -- continue the row
				button:SetPoint("LEFT", getglobal(frame..i-1), "RIGHT", 3, 0)
				added = added + 1
			else -- start a new row
				button:SetPoint("TOPLEFT", getglobal(frame..i-(rowLimit)), "BOTTOMLEFT", 0, -3)
				rowBuff = i
				added = 1
			end
		end

		return rowBuff
	end

	local function BuffPositions(num_buff, num_debuff, rowLimit)
		-- position debuffs depending on if there are any buffs
		-- fill buffs and debuffs in rows
		TargetFrameDebuff1:ClearAllPoints()
		if num_buff > 0 then
			local rowBuff = BuffRows("TargetFrameBuff", num_buff, rowLimit) -- position buffs in rows
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff"..rowBuff, "BOTTOMLEFT", 0, -3) -- set debuff anchor
		else
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32) -- set default anchor
		end

		if num_debuff > 0 then
			BuffRows("TargetFrameDebuff", num_debuff, rowLimit) -- position debuffs in rows
		end
	end

	local function TargetFrameBuff_Position(num_buff, num_debuff)
		TargetFrameBuff1:ClearAllPoints()
		TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32) -- set default anchor
		if not UnitExists("targettarget") then
			-- show rows of 5 buffs/debuffs if no target of target
			BuffPositions(num_buff, num_debuff, 5)
		else
			-- show rows of 4 buffs/debuffs if target of target
			BuffPositions(num_buff, num_debuff, 4)
		end
	end

	local function TargetDebuffButtonExtended_Update()
		-- update the target buffs/debuffs (code from FrameXML/TargetFrame.lua)
		local num_buff = 0
		local num_debuff = 0
		local button, buff

		-- buffs
		for i=1, buffButtons do
			buff = DetectBuff("target", i)
			button = getglobal("TargetFrameBuff"..i)
			if (buff) then
				getglobal("TargetFrameBuff"..i.."Icon"):SetTexture(buff)
				button:Show()
				button.id = i
				num_buff = i
			else
				button:Hide()
			end
		end

		-- debuffs
		local debuff, debuffApplication, debuffCount
		for i=1, debuffButtons do
			debuff, debuffApplications = UnitDebuff("target", i)
			button = getglobal("TargetFrameDebuff"..i)
			if (debuff) then
				debuffCount = getglobal("TargetFrameDebuff"..i.."Count")
				if (debuffApplications > 1) then
					debuffCount:SetText(debuffApplications)
					debuffCount:Show()
				else
					debuffCount:Hide()
				end
				getglobal("TargetFrameDebuff"..i.."Icon"):SetTexture(debuff)
				button:Show()
				button.id = i
				num_debuff = i
			else
				button:Hide()
			end
		end

		-- position the buffs/debuffs
		TargetFrameBuff_Position(num_buff, num_debuff)
	end

	TargetDebuffButton_Update()
	TargetDebuffButton_Update = TargetDebuffButtonExtended_Update
	resize()
end