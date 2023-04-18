local _G = ShaguTweaks.GetGlobalEnv()

local module = ShaguTweaks:register({
  title = "Nameplate Tweaks",
  description = "Replace totem nameplates with icons and hides healthbar on critters.",
  expansions = { ["vanilla"] = true, ["tbc"] = nil },
  enabled = true,
})

module.enable = function(self)  
  if ShaguPlates then return end

  local totems = {
    ["Disease Cleansing Totem"] = "spell_nature_diseasecleansingtotem",
    ["Earth Elemental Totem"] = "spell_nature_earthelemental_totem",
    ["Earthbind Totem"] = "spell_nature_strengthofearthtotem02",
    ["Fire Elemental Totem"] = "spell_fire_elemental_totem",
    ["Fire Nova Totem"] = "spell_fire_sealoffire",
    ["Fire Resistance Totem"] = "spell_fireresistancetotem_01",
    ["Flametongue Totem"] = "spell_nature_guardianward",
    ["Frost Resistance Totem"] = "spell_frostresistancetotem_01",
    ["Grace of Air Totem"] = "spell_nature_invisibilitytotem",
    ["Grounding Totem"] = "spell_nature_groundingtotem",
    ["Healing Stream Totem"] = "Inv_spear_04",
    ["Magma Totem"] = "spell_fire_selfdestruct",
    ["Mana Spring Totem"] = "spell_nature_manaregentotem",
    ["Mana Tide Totem"] = "spell_frost_summonwaterelemental",
    ["Nature Resistance Totem"] = "spell_nature_natureresistancetotem",
    ["Poison Cleansing Totem"] = "spell_nature_poisoncleansingtotem",
    ["Searing Totem"] = "spell_fire_searingtotem",
    ["Sentry Totem"] = "spell_nature_removecurse",
    ["Stoneclaw Totem"] = "spell_nature_stoneclawtotem",
    ["Stoneskin Totem"] = "spell_nature_stoneskintotem",
    ["Strength of Earth Totem"] = "spell_nature_earthbindtotem",
    ["Totem of Wrath"] = "spell_fire_totemofwrath",
    ["Tremor Totem"] = "spell_nature_tremortotem",
    ["Windfury Totem"] = "spell_nature_windfury",
    ["Windwall Totem"] = "spell_nature_earthbind",
    ["Wrath of Air Totem"] = "spell_nature_slowingtotem",
  }

  local critters = {
    'Adder',
    'Beetle',
    'Belfry Bat',
    'Biletoad',
    'Black Rat',
    'Brown Prairie Dog',
    'Caged Rabbit',
    'Caged Sheep',
    'Caged Squirrel',
    'Caged Toad',
    'Cat',
    'Chicken',
    'Cleo',
    'Core Rat',
    'Cow',
    'Cow',
    'Cured Deer',
    'Cured Gazelle',
    'Deeprun Rat',
    'Deer',
    'Dog',
    'Effsee',
    'Enthralled Deeprun Rat',
    'Fang',
    'Fawn',
    'Fire Beetle',
    'Fluffy',
    'Frog',
    'Gazelle',
    'Hare',
    'Horse',
    'Huge Toad',
    'Infected Deer',
    'Infected Squirrel',
    'Jungle Toad',
    'Krakle\'s Thermometer',
    'Lady',
    'Larva',
    'Lava Crab',
    'Maggot',
    'Moccasin',
    'Mouse',
    'Mr. Bigglesworth',
    'Nibbles',
    'Noarm',
    'Old Blanchy',
    'Parrot',
    'Pig',
    'Pirate treasure trigger mob',
    'Plagued Insect',
    'Plagued Maggot',
    'Plagued Rat',
    'Plagueland Termite',
    'Polymorphed Chicken',
    'Polymorphed Rat',
    'Prairie Dog',
    'Rabbit',
    'Ram',
    'Rat',
    'Riding Ram',
    'Roach',
    'Salome',
    'School of Fish',
    'Scorpion',
    'Sheep',
    'Sheep',
    'Shen\'dralar Wisp',
    'Sickly Deer',
    'Sickly Gazelle',
    'Snake',
    'Spider',
    'Spike',
    'Squirrel',
    'Swine',
    'Tainted Cockroach',
    'Tainted Rat',
    'Toad',
    'Transporter Malfunction',
    'Turtle',
    'Underfoot',
    'Voice of Elune',
    'Waypoint (Only GM can see it)',
    'Wisp',
  }

  local function GetUnitType(red, green, blue)
    if red > .9 and green < .2 and blue < .2 then
      return "ENEMY_NPC"
    elseif red > .9 and green > .9 and blue < .2 then
      return "NEUTRAL_NPC"
    elseif red < .2 and green < .2 and blue > 0.9 then
      return "FRIENDLY_PLAYER"
    elseif red < .2 and green > .9 and blue < .2 then
      return "FRIENDLY_NPC"
    end
  end

  local function isCritter(name)
    local red, green, blue = this.healthbar:GetStatusBarColor()
    local unittype = GetUnitType(red, green, blue) or "ENEMY_NPC"

    for i, critter in pairs(critters) do
      if ((string.lower(name) == string.lower(critter)) and (unittype == "NEUTRAL_NPC")) then return true end
    end
  end

  local function TotemPlate(name)
    for totem, icon in pairs(totems) do
      if string.find(name, totem) then return icon end
    end
  end

  local function Reset(frame)
    if frame.icon then
      frame.icon:SetTexture(nil)
    end
    frame.name:Show()
    frame.level:Show()
    frame.healthbar:Show()
    frame.border:Show()
  end

  table.insert(ShaguTweaks.libnameplate.OnUpdate, function()
    Reset(this)
    local name = this.name:GetText()
    local TotemIcon = TotemPlate(name)
    local Critter = isCritter(name)

    if TotemIcon then
      this.totem = true
      if not this.icon then
        this.icon = this:CreateTexture(nil, 'OVERLAY')
        this.icon:SetWidth(28)
        this.icon:SetHeight(28)
        this.icon:SetPoint("CENTER", this.name, "CENTER", 0, 0)
        this.icon:SetTexture()
      end
      this.icon:SetTexture("Interface\\Icons\\"..TotemIcon)
      this.name:Hide()
      this.level:Hide()
      this.healthbar:Hide()
      this.border:Hide()  
    elseif Critter then
      this.critter = true
      this.level:Hide()
      this.healthbar:Hide()
      this.border:Hide()
    end
  end)
end