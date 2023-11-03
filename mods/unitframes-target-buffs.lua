local module = ShaguTweaks:register({
    title = "Target Buffs Extended",
    description = "Show up to 16 buffs on the target unit frame.",
    expansions = { ["vanilla"] = true, ["tbc"] = nil },
    category = "Unit Frames",
    enabled = nil,
})

module.enable = function(self)
	local buffButtons = 16

	do -- create additional buff buttons		
		for i = 6, buffButtons do		
			local button = CreateFrame("Button", "TargetFrameBuff"..i, TargetFrame, "TargetBuffButtonTemplate")
			button:SetID(i)
			if (i == 6) then
				button:SetPoint("TOPLEFT", TargetFrameBuff1, "BOTTOMLEFT", 0, -2)
			else
				button:SetPoint("LEFT", "TargetFrameBuff"..i-1, "RIGHT", 3, 0)
			end
		end
	end

	local function TargetFrameBuff_Anchor(num_buffs)
		if (num_buffs > 5) then
			return 6 -- anchor to third line
		end
		return 1 -- anchor to second line
	end

	local function TargetFrameBuff_Position(num_buff, num_debuff)
		-- position buffs/debuffs depending on whether the targeted unit is friendly or not
		if (UnitIsFriend("player", "target")) then
			-- unit is friendly
			TargetFrameBuff1:ClearAllPoints()
			TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32)
			
			TargetFrameDebuff1:ClearAllPoints()
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrameBuff"..TargetFrameBuff_Anchor(num_buff), "BOTTOMLEFT", 0, -2)
		else
			-- unit is hostile
			TargetFrameDebuff1:ClearAllPoints()
			TargetFrameDebuff1:SetPoint("TOPLEFT", "TargetFrame", "BOTTOMLEFT", 5, 32)

			TargetFrameBuff1:ClearAllPoints()
			TargetFrameBuff1:SetPoint("TOPLEFT", "TargetFrameDebuff"..TargetFrameBuff_Anchor(num_debuff), "BOTTOMLEFT", 0, -2)
		end

		if not UnitExists("targettarget") then
			-- show rows of 5 buffs/debuffs if no target of target
			TargetFrameBuff5:ClearAllPoints()
			TargetFrameBuff5:SetPoint("LEFT", "TargetFrameBuff4", "RIGHT", 3, 0)
			TargetFrameBuff10:ClearAllPoints()
			TargetFrameBuff10:SetPoint("LEFT", "TargetFrameBuff9", "RIGHT", 3, 0)

			TargetFrameDebuff5:ClearAllPoints()
			TargetFrameDebuff5:SetPoint("LEFT", "TargetFrameDebuff4", "RIGHT", 3, 0)				
			TargetFrameDebuff10:ClearAllPoints()
			TargetFrameDebuff10:SetPoint("LEFT", "TargetFrameDebuff9", "RIGHT", 3, 0)
		else
			-- show rows of 4 buffs/debuffs if target of target
			TargetFrameBuff5:ClearAllPoints()
			TargetFrameBuff5:SetPoint("TOPLEFT", "TargetFrameBuff1", "BOTTOMLEFT", 0, -2)				
			TargetFrameBuff10:ClearAllPoints()
			TargetFrameBuff10:SetPoint("TOPLEFT", "TargetFrameBuff5", "BOTTOMLEFT", 0, -2)
			
			TargetFrameDebuff5:ClearAllPoints()
			TargetFrameDebuff5:SetPoint("TOPLEFT", "TargetFrameDebuff1", "BOTTOMLEFT", 0, -2)				
			TargetFrameDebuff10:ClearAllPoints()
			TargetFrameDebuff10:SetPoint("TOPLEFT", "TargetFrameDebuff5", "BOTTOMLEFT", 0, -2)
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
		for i=1, buffButtons do
			debuff, debuffCount = UnitDebuff("target", i)
			button = getglobal("TargetFrameDebuff"..i)
			if (debuff) then
				debuffCount = getglobal("TargetFrameDebuff"..i.."Count")
				if (debuffCount > 1) then
					debuffCount:SetText(debuffCount)
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