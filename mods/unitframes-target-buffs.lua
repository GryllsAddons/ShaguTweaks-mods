local module = ShaguTweaks:register({
    title = "Target Buffs Extended",
    description = "Show up to 16 buffs on the target unit frame.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
})

module.enable = function(self)
	-- Note: The default target frame shows 5 buffs and 16 debuffs
	local buffButtons = 16
	local debuffButtons = 16

	do -- create 11 additional buff buttons		
		for i = 6, buffButtons do
			local button = CreateFrame("Button", "TargetFrameBuff"..i, TargetFrame, "TargetBuffButtonTemplate")
			button:SetID(i)
		end
	end

	local function layout(frame, numButtons, rowLimit)
		-- layout buffs in rows attached to the first buff/debuff
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

	local function layoutFriendly(num_buff, num_debuff, rowLimit)
		if num_buff > 0 then
			local rowBuff = layout("TargetFrameBuff", num_buff, rowLimit) -- layout buffs
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff"..rowBuff, "BOTTOMLEFT", 0, -3) -- set debuff anchor
		else
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32)
		end
		layout("TargetFrameDebuff", num_debuff, rowLimit) -- layout debuffs
	end

	local function layoutHostile(num_buff, num_debuff, rowLimit)
		if num_debuff > 0 then
			local rowBuff = layout("TargetFrameDebuff", num_debuff, rowLimit) -- layout debuffs
			TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrameDebuff"..rowBuff, "BOTTOMLEFT", 0, -3) -- set buff anchor
		else
			TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32)
		end
		layout("TargetFrameBuff", num_buff, rowLimit) -- layout buffs
	end

	local function TargetFrameBuff_Position(num_buff, num_debuff)
		-- position buffs/debuffs depending on whether the targeted unit is friendly or not
		if (UnitIsFriend("player", "target")) then
			-- unit is friendly, show buffs first then debuffs
			TargetFrameBuff1:ClearAllPoints()
			TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32) -- set position of first buff	
			if not UnitExists("targettarget") then
				-- show rows of 5 buffs/debuffs if no target of target
				layoutFriendly(num_buff, num_debuff, 5)
			else
				-- show rows of 4 buffs/debuffs if target of target
				layoutFriendly(num_buff, num_debuff, 4)
			end
		else
			-- unit is hostile, show debuffs first then buffs
			TargetFrameDebuff1:ClearAllPoints()
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32) -- set position of first debuff
			if not UnitExists("targettarget") then
				-- show rows of 5 buffs/debuffs if no target of target
				layoutHostile(num_buff, num_debuff, 5)
			else
				-- show rows of 4 buffs/debuffs if target of target
				layoutHostile(num_buff, num_debuff, 4)
			end
		end
	end
	
	local function TargetDebuffButtonExtended_Update()
		-- update the target buffs/debuffs (code from FrameXML/TargetFrame.lua)
		local num_buff = 0
		local num_debuff = 0
		local button, buff

		-- buffs
		for i=1, buffButtons do
			buff = UnitBuff("target", i)
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
end