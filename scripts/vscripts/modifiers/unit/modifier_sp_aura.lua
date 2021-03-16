if modifier_sp_aura == nil then
	modifier_sp_aura = class({}, nil, eom_modifier)
end
local public = modifier_sp_aura
function public:GetTexture()
	return "attribute_bonus"
end
function public:IsHidden()
	return false
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:IsStunDebuff()
	return false
end
function public:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self:SetHasCustomTransmitterData(true)
		self.sp_magical_single = hParent:Load("sp_magical_single")
		self.sp_physical_single = hParent:Load("sp_physical_single")
		self.sp_defend_single = hParent:Load("sp_defend_single")
		self.sp_attackspeed_single = hParent:Load("sp_attackspeed_single")
	end
end
function public:OnRefresh(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.sp_magical_single = hParent:Load("sp_magical_single")
		self.sp_physical_single = hParent:Load("sp_physical_single")
		self.sp_defend_single = hParent:Load("sp_defend_single")
		self.sp_attackspeed_single = hParent:Load("sp_attackspeed_single")
	end
end
function public:AddCustomTransmitterData()
	return {
		sp_magical_single = self.sp_magical_single,
		sp_physical_single = self.sp_physical_single,
		sp_defend_single = self.sp_defend_single,
		sp_attackspeed_single = self.sp_attackspeed_single,
	}
end
function public:HandleCustomTransmitterData(tData)
	self.sp_magical_single = tData.sp_magical_single
	self.sp_physical_single = tData.sp_physical_single
	self.sp_defend_single = tData.sp_defend_single
	self.sp_attackspeed_single = tData.sp_attackspeed_single
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function public:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_MANA_REGEN_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_ATTACKT_SPEED_BONUS,
	}
end
function public:GetPhysicalAttackBonus()
	local hCaster = self:GetCaster()
	local spell_value = self:GetKVSpecialValueFor('sp_physical', "physical_atkbonus")
	local art_value = self:GetKVSpecialValueFor('art_wine_glass', "attack_bonus")
	if IsValid(hCaster) then
		local iSpell_Stack = hCaster:GetModifierStackCount("modifier_sp_physical", hCaster)
		local iArt_Stack = hCaster:GetModifierStackCount("modifier_physical_bonus", hCaster)
		local bonus = art_value * iArt_Stack + iSpell_Stack * spell_value + self.sp_physical_single
		return bonus
	end
	return 0
end
function public:GetMagicalAttackBonus()
	local hCaster = self:GetCaster()
	local spell_value = self:GetKVSpecialValueFor('sp_magical', "magical_atkbonus")
	local art_value = self:GetKVSpecialValueFor('art_wine_glass', "attack_bonus")
	if IsValid(hCaster) then
		local iSpell_Stack = hCaster:GetModifierStackCount("modifier_sp_magical", hCaster)
		local iArt_Stack = hCaster:GetModifierStackCount("modifier_magical_bonus", hCaster)
		local bonus = art_value * iArt_Stack + iSpell_Stack * spell_value + self.sp_magical_single
		return bonus
	end
	return 0
end
function public:GetModifierPercentageCooldown()
	local hCaster = self:GetCaster()
	local value = self:GetKVSpecialValueFor('sp_cooldown', "cooldown_reduce")
	if IsValid(hCaster) then
		local iStack = hCaster:GetModifierStackCount("modifier_sp_cooldown", hCaster)
		return (1 - math.pow(1 - value * 0.01, iStack)) * 100
	end
	return 0
end
function public:GetHealthRegenBonus()
	local hCaster = self:GetCaster()
	local value = self:GetKVSpecialValueFor('sp_hpregen', "health_regenbonus")
	if IsValid(hCaster) then
		local iStack = hCaster:GetModifierStackCount("modifier_sp_hpregen", hCaster)
		return iStack * value
	end
	return 0
end
function public:GetManaRegenBonus()
	local hCaster = self:GetCaster()
	local value = self:GetKVSpecialValueFor('sp_manaregen', "mana_regenbonus")
	if IsValid(hCaster) then
		local iStack = hCaster:GetModifierStackCount("modifier_sp_manaregen", hCaster)
		return iStack * value
	end
	return 0
end
function public:GetPhysicalArmorBonus()
	local hCaster = self:GetCaster()
	local value = self:GetKVSpecialValueFor('sp_defend', "armorbonus")
	if IsValid(hCaster) then
		local iStack = hCaster:GetModifierStackCount("modifier_sp_defend", hCaster)
		return iStack * value + self.sp_defend_single
	end
	return 0
end
function public:GetMagicalArmorBonus()
	local hCaster = self:GetCaster()
	local value = self:GetKVSpecialValueFor('sp_defend', "armorbonus")
	if IsValid(hCaster) then
		local iStack = hCaster:GetModifierStackCount("modifier_sp_defend", hCaster)
		return iStack * value + self.sp_defend_single
	end
	return 0
end
function public:GetAttackSpeedBonus()
	local hCaster = self:GetCaster()
	local value = self.sp_attackspeed_single
	if IsValid(hCaster) then
		return value
	end
	return 0
end
function public:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 8 + 1
	if self._tooltip == 1 then
		return self:GetPhysicalAttackBonus()
	elseif self._tooltip == 2 then
		return self:GetMagicalAttackBonus()
	elseif self._tooltip == 3 then
		return self:GetModifierPercentageCooldown()
	elseif self._tooltip == 4 then
		return self:GetHealthRegenBonus()
	elseif self._tooltip == 5 then
		return self:GetManaRegenBonus()
	elseif self._tooltip == 6 then
		return self:GetPhysicalArmorBonus()
	elseif self._tooltip == 7 then
		return self:GetMagicalArmorBonus()
	elseif self._tooltip == 8 then
		return self:GetAttackSpeedBonus()
	end
end