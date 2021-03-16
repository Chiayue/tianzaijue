LinkLuaModifier("modifier_item_satan_power", "abilities/items/item_satan_power.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_satan_power_buff", "abilities/items/item_satan_power.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_satan_power_debuff", "abilities/items/item_satan_power.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_satan_power == nil then
	item_satan_power = class({})
end
function item_satan_power:GetIntrinsicModifierName()
	return "modifier_item_satan_power"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_satan_power == nil then
	modifier_item_satan_power = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_satan_power:IsHidden()
	return false
end
function modifier_item_satan_power:OnCreated(params)
	self.max_damage = self:GetAbilitySpecialValueFor("max_damage")
	self.min_damage = self:GetAbilitySpecialValueFor("min_damage")
	self.absorb_pct = self:GetAbilitySpecialValueFor("absorb_pct")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
		self:StartIntervalThink(1)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_faceless_void/faceless_void_chrono_speed.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
	end
	local cur_phy_atk = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local cur_mag_atk = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
	if cur_phy_atk >= cur_mag_atk then
		self.isPhyAtk = 1
		self.isMagAtk = 0
	else
		self.isPhyAtk = 0
		self.isMagAtk = 1
	end
end
function modifier_item_satan_power:OnRefresh(params)
	self.max_damage = self:GetAbilitySpecialValueFor("max_damage")
	self.min_damage = self:GetAbilitySpecialValueFor("min_damage")
	self.absorb_pct = self:GetAbilitySpecialValueFor("absorb_pct")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_satan_power:OnIntervalThink()
	self:SetStackCount(RandomInt(self.min_damage, self.max_damage))
end
function modifier_item_satan_power:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_IN_BATTLE,
	}
end
function modifier_item_satan_power:GetPhysicalAttackBonusPercentage()
	return self:GetStackCount() * self.isPhyAtk
end
function modifier_item_satan_power:GetMagicalAttackBonusPercentage()
	return self:GetStackCount() * self.isMagAtk
end
function modifier_item_satan_power:OnInBattle()
	local flAttackTotal = 0
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		if hUnit ~= self:GetParent() then
			local flAttack = 0
			if self.isPhyAtk == 1 then
				flAttack = hUnit:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.absorb_pct * 0.01
			else
				flAttack = hUnit:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.absorb_pct * 0.01
			end
			flAttackTotal = flAttackTotal + flAttack
			hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_satan_power_debuff", { flAttack = flAttack, isPhyAtk = self.isPhyAtk, isMagAtk = self.isMagAtk })
		end
	end, UnitType.AllFirends)
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_satan_power_buff", { flAttack = flAttackTotal })
end
---------------------------------------------------------------------
if modifier_item_satan_power_buff == nil then
	modifier_item_satan_power_buff = class({}, nil, eom_modifier)
end
function modifier_item_satan_power_buff:OnCreated(params)
	local cur_phy_atk = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
	local cur_mag_atk = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
	if cur_phy_atk >= cur_mag_atk then
		self.isPhyAtk = 1
		self.isMagAtk = 0
	else
		self.isPhyAtk = 0
		self.isMagAtk = 1
	end
	if IsServer() then
		self:SetStackCount(math.ceil(params.flAttack))
	end
end
function modifier_item_satan_power_buff:IsHidden()
	return false
end
function modifier_item_satan_power_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE,
		EMDF_MAGICAL_ATTACK_BONUS_UNIQUE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_item_satan_power_buff:GetPhysicalAttackBonus()
	return self:GetStackCount() * self.isPhyAtk
end
function modifier_item_satan_power_buff:GetMagicalAttackBonus()
	return self:GetStackCount() * self.isMagAtk
end
function modifier_item_satan_power_buff:OnBattleEnd()
	self:Destroy()
end
---------------------------------------------------------------------
if modifier_item_satan_power_debuff == nil then
	modifier_item_satan_power_debuff = class({}, nil, eom_modifier)
end
function modifier_item_satan_power_debuff:IsDebuff()
	return true
end
function modifier_item_satan_power_debuff:IsHidden()
	return false
end
function modifier_item_satan_power_debuff:OnCreated(params)
	if IsServer() then
		self:SetStackCount(math.ceil(params.flAttack))
		self.tData = {}
		self.tData.isPhyAtk = params.isPhyAtk
		self.tData.isMagAtk = params.isMagAtk
	end
	self:SetHasCustomTransmitterData(true)
end
function modifier_item_satan_power_debuff:AddCustomTransmitterData()
	return self.tData
end
function modifier_item_satan_power_debuff:HandleCustomTransmitterData(tData)
	self.tData = tData
end
function modifier_item_satan_power_debuff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_UNIQUE,
		EMDF_MAGICAL_ATTACK_BONUS_UNIQUE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_item_satan_power_debuff:GetPhysicalAttackBonusUnique()
	return -self:GetStackCount() * self.tData.isPhyAtk
end
function modifier_item_satan_power_debuff:GetMagicalAttackBonusUnique()
	return -self:GetStackCount() * self.tData.isMagAtk
end
function modifier_item_satan_power_debuff:OnBattleEnd()
	self:Destroy()
end