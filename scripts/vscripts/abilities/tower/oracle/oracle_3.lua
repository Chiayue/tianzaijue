LinkLuaModifier("modifier_oracle_3", "abilities/tower/oracle/oracle_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_oracle_3_buff", "abilities/tower/oracle/oracle_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_oracle_3_active", "abilities/tower/oracle/oracle_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if oracle_3 == nil then
	oracle_3 = class({})
end
function oracle_3:GetIntrinsicModifierName()
	return "modifier_oracle_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_oracle_3 == nil then
	modifier_oracle_3 = class({}, nil, eom_modifier)
end
function modifier_oracle_3:IsHidden()
	return true
end
function modifier_oracle_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
	}
end
function modifier_oracle_3:OnInBattle()
	if self:GetParent():PassivesDisabled() then return end
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_oracle_3_buff", nil)
	end, UnitType.AllFirends)
end
---------------------------------------------------------------------
if modifier_oracle_3_buff == nil then
	modifier_oracle_3_buff = class({}, nil, eom_modifier)
end
function modifier_oracle_3_buff:IsHidden()
	return true
end
function modifier_oracle_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_oracle_3_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_oracle_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end
function modifier_oracle_3_buff:GetMinHealth()
	if IsValid(self:GetAbility()) and self:GetAbility():IsCooldownReady() then
		return 1
	end
end
function modifier_oracle_3_buff:OnTakeDamage(params)
	if not IsValid(self:GetAbility()) then return end
	local hParent = self:GetParent()
	if params.unit == hParent then
		if hParent:GetHealth() == 1 and self:GetAbility():IsCooldownReady() then
			hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_oracle_3_active", { duration = self:GetAbility():GetDuration(), attacker_index = params.attacker:entindex() })
			self:GetAbility():UseResources(false, false, true)
		end
	end
end
---------------------------------------------------------------------
if modifier_oracle_3_active == nil then
	modifier_oracle_3_active = class({}, nil, eom_modifier)
end
function modifier_oracle_3_active:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self.flDamageRecord = 0
		self.attacker = EntIndexToHScript(params.attacker_index)
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(self:GetCaster(), hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			hUnit:AddBuff(hParent, BUFF_TYPE.TAUNT, self:GetAbility():GetDuration())
		end

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 2, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_false_promise.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		hParent:EmitSound("Hero_Oracle.FalsePromise.Cast")
		hParent:EmitSound("Hero_Oracle.FalsePromise.Target")
	end
end
function modifier_oracle_3_active:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_oracle_3_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MIN_HEALTH,
	}
end
function modifier_oracle_3_active:GetMinHealth()
	return 1
end
function modifier_oracle_3_active:OnBattleEnd()
	self:Destroy()
end
function modifier_oracle_3_active:OnTakeDamage(params)
	local hParent = self:GetParent()
	if params.unit == hParent then
		self.flDamageRecord = self.flDamageRecord + params.original_damage
	end
end
function modifier_oracle_3_active:OnDestroy()
	if IsServer() then
		if not IsValid(self:GetCaster()) then
			return
		end
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		self:GetCaster():DealDamage(tTargets, self:GetAbility(), self.flDamageRecord)
		hParent:Kill(self:GetAbility(), IsValid(self.attacker) and self.attacker or hParent)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_oracle/oracle_fortune_aoe.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.radius, self.radius, self.radius))
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end