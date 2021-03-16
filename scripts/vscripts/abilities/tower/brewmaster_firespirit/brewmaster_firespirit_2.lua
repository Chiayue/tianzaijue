LinkLuaModifier("modifier_brewmaster_firespirit_2", "abilities/tower/brewmaster_firespirit/brewmaster_firespirit_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_brewmaster_firespirit_2_buff", "abilities/tower/brewmaster_firespirit/brewmaster_firespirit_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if brewmaster_firespirit_2 == nil then
	brewmaster_firespirit_2 = class({})
end
function brewmaster_firespirit_2:Action(vPosition, tTargets)
	local hCaster = self:GetCaster()
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetSpecialValueFor("stun_duration"))
	end
end
function brewmaster_firespirit_2:GetIntrinsicModifierName()
	return "modifier_brewmaster_firespirit_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_firespirit_2 == nil then
	modifier_brewmaster_firespirit_2 = class({}, nil, BaseModifier)
end
function modifier_brewmaster_firespirit_2:IsHidden()
	return true
end
function modifier_brewmaster_firespirit_2:GetEffectName()
	return "particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf"
end
function modifier_brewmaster_firespirit_2:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end
function modifier_brewmaster_firespirit_2:IsAura()
	return true
end
function modifier_brewmaster_firespirit_2:GetAuraRadius()
	return self.radius
end
function modifier_brewmaster_firespirit_2:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_brewmaster_firespirit_2:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end
function modifier_brewmaster_firespirit_2:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_brewmaster_firespirit_2:GetModifierAura()
	return "modifier_brewmaster_firespirit_2_buff"
end
function modifier_brewmaster_firespirit_2:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_brewmaster_firespirit_2_buff == nil then
	modifier_brewmaster_firespirit_2_buff = class({}, nil, BaseModifier)
end
function modifier_brewmaster_firespirit_2_buff:IsDebuff()
	return true
end
function modifier_brewmaster_firespirit_2_buff:OnCreated(params)
	-- self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.iInterval = self:GetAbilitySpecialValueFor("interval")

	if IsServer() then
		-- self:GetParent():AddBuff(self:GetCaster(), BUFF_TYPE.STUN, self.stun_duration)
		local iParticleID = ParticleManager:CreateParticle("particles/econ/courier/courier_wyvern_hatchling/courier_wyvern_hatchling_fire.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)

		self:StartIntervalThink(self.iInterval)
	end
end
function modifier_brewmaster_firespirit_2_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_brewmaster_firespirit_2_buff:OnIntervalThink()
	if not IsValid(self:GetCaster()) or not IsValid(self:GetAbility()) then
		self:Destroy()
		return
	end
	local tDamage = {
		ability = self:GetAbility(),
		attacker = self:GetCaster(),
		victim = self:GetParent(),
		damage = self:GetAbility():GetAbilityDamage(),
		damage_type = DAMAGE_TYPE_MAGICAL
	}
	ApplyDamage(tDamage)

	local hAbility_3 = self:GetCaster():FindAbilityByName("brewmaster_firespirit_3")
	local bReduce = (IsValid(hAbility_3) and hAbility_3:GetLevel() > 0) and true or false
	if bReduce then
		self:GetParent():AddNewModifier(self:GetCaster(), hAbility_3, "modifier_brewmaster_firespirit_3_debuff", { duration = self.iInterval })
	end
end
function modifier_brewmaster_firespirit_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_brewmaster_firespirit_2_buff:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self.iInterval
	end
	local fSumDamage = 0
	-- 计算伤害加成
	local tDamageAdd = self:GetAbility():GetDamageAdd()
	for typeDamage, fDamage in pairs(tDamageAdd) do
		fSumDamage = fSumDamage + fDamage
	end
	return fSumDamage
end