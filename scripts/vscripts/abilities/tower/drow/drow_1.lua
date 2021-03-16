LinkLuaModifier("modifier_drow_1", "abilities/tower/drow/drow_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_drow_1_buff", "abilities/tower/drow/drow_1.lua", LUA_MODIFIER_MOTION_NONE)

if drow_1 == nil then
	---@type CDOTABaseAbility
	drow_1 = class({})
end
function drow_1:GetIntrinsicModifierName()
	return "modifier_drow_1"
end

---------------------------------------------------------------------
--Modifiers
if modifier_drow_1 == nil then
	modifier_drow_1 = class({}, nil, eom_modifier)
end
function modifier_drow_1:IsHidden()
	return true
end
function modifier_drow_1:OnCreated(params)
	self.attack_speed_damage_per = self:GetAbilitySpecialValueFor('attack_speed_damage_per')
	self.phy_attack_pct = self:GetAbilitySpecialValueFor('phy_attack_pct')
	if IsServer() then
		self.type_damage = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_drow_1:OnRefresh(params)
	self.attack_speed_damage_per = self:GetAbilitySpecialValueFor('attack_speed_damage_per')
	self.phy_attack_pct = self:GetAbilitySpecialValueFor('phy_attack_pct')
end
function modifier_drow_1:EDeclareFunctions()
	return	{
		EMDF_EVENT_ON_ATTACK_HIT,
	-- EMDF_PHYSICAL_ATTACK_BONUS,
	}
end
function modifier_drow_1:GetPhysicalAttackBonus()
	local hParent = self:GetParent()
	return hParent:GetVal(ATTRIBUTE_KIND.AttackSpeed) * 0.01 * self.attack_speed_damage_per + hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01 * (self.phy_attack_pct - 100)
end
---@param tAttackInfo AttackInfo
function modifier_drow_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent()
	or not IsValid(hTarget)
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	then return end

	if not hTarget:HasModifier('modifier_drow_1_buff') then
		hTarget:AddBuff(self:GetParent(), BUFF_TYPE.FEAR, 1)
	end

	--添加黑暗BUFF
	hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), 'modifier_drow_1_buff', nil)

	--额外伤害
	local fDamage = self:GetPhysicalAttackBonus()
	local tDamageData = tAttackInfo.tDamageInfo[self.type_damage]
	if tDamageData then
		tDamageData.damage = (tDamageData.damage or 0) + fDamage
	end
end

--黑暗BUFF
if modifier_drow_1_buff == nil then
	modifier_drow_1_buff = class({}, nil, eom_modifier)
end
function modifier_drow_1_buff:IsDebuff()
	return true
end
function modifier_drow_1_buff:OnCreated(params)
	self.mana_regain = self:GetAbilitySpecialValueFor('mana_regain')
	if IsServer() then
	else
		-- local iPlayerID = GetPlayerID(self:GetCaster())
		-- LocalPlayerParticle(iPlayerID, function()
		-- 	local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_lone_druid_savage_roar.vpcf", PATTACH_INVALID, self:GetParent())
		-- 	self:AddParticle(iParticleID, false, true, 10, false, false)
		-- 	return iParticleID
		-- end, PARTICLE_DETAIL_LEVEL_LOW)
	end
end
function modifier_drow_1_buff:OnRefresh(params)
	self.mana_regain = self:GetAbilitySpecialValueFor('mana_regain')
end
function modifier_drow_1_buff:EDeclareFunctions()
	return	{
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() }
	}
end
function modifier_drow_1_buff:OnDeath(params)
	if IsValid(self:GetCaster()) then
		self:GetCaster():GiveMana(self.mana_regain)
	end
end