LinkLuaModifier("modifier_lanaya_1", "abilities/tower/lanaya/lanaya_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lanaya_1_illusion_buff", "abilities/tower/lanaya/lanaya_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lanaya_1 == nil then
	lanaya_1 = class({}, nil, ability_base_ai)
end
function lanaya_1:GetAOERadius()
	return self:GetSpecialValueFor("range")
end
function lanaya_1:GetCastRange(vLocation, hTarget)
	return self:GetSpecialValueFor("range")
end
function lanaya_1:OnSpellStart()
	local range = self:GetSpecialValueFor("range")
	local illusion_outgoing_damage = self:GetSpecialValueFor("illusion_outgoing_damage")
	local illusion_duration = self:GetSpecialValueFor("illusion_duration")
	local illusion_spawn_distance = self:GetSpecialValueFor("illusion_spawn_distance")

	local hCaster = self:GetCaster()

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, range, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_FARTHEST, false)
	local hTarget = tTargets[1]
	if IsValid(hTarget) then
		local vDirection = hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()
		vDirection.z = 0
		local vSpawn = hTarget:GetAbsOrigin() + vDirection:Normalized() * illusion_spawn_distance

		local hIllusion = CreateIllusion(hCaster, vSpawn, true, hCaster, hCaster, hCaster:GetTeamNumber(), illusion_duration, illusion_outgoing_damage, 100)
		hIllusion:AddBuff(hTarget, BUFF_TYPE.TAUNT, 10)
		hIllusion:AddNewModifier(hCaster, self, "modifier_lanaya_1_illusion_buff", { duration = illusion_duration })
		hIllusion:SetAcquisitionRange(3000)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_lanaya_1_illusion_buff == nil then
	modifier_lanaya_1_illusion_buff = class({}, nil, eom_modifier)
end
function modifier_lanaya_1_illusion_buff:OnCreated(params)
	self.critical_chance = self:GetAbilitySpecialValueFor("critical_chance")
	self.critical_damage = self:GetAbilitySpecialValueFor("critical_damage")
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle('particles/units/heroes/lanaya/lanaya_illusion_test.vpcf', PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lanaya_1_illusion_buff:CheckState()
	return {
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_MAGIC_IMMUNE] = true,
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function modifier_lanaya_1_illusion_buff:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		MODIFIER_EVENT_ON_DEATH,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_lanaya_1_illusion_buff:GetAttackCritBonus()
	return self.critical_damage, self.critical_chance
end
function modifier_lanaya_1_illusion_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if nil == hTarget
	or tAttackInfo.attacker ~= self:GetParent()
	or IsAttackMiss(tAttackInfo)
	or self:GetParent():PassivesDisabled()
	or not IsAttackCrit(tAttackInfo)
	then return end

	local hCaster = self:GetCaster()
	if IsValid(hCaster) then
		local hAbility2 = hCaster:FindAbilityByName("lanaya_2")
		if IsValid(hAbility2) and hAbility2.OnCritHit then
			hAbility2:OnCritHit(self:GetParent())
		end
	end
end
function modifier_lanaya_1_illusion_buff:OnBattleEnd()
	self:GetParent():ForceKill(false)
end