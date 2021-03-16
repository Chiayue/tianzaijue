LinkLuaModifier("modifier_kunkkaB_3", "abilities/tower/kunkkaB/kunkkaB_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kunkkaB_3 == nil then
	kunkkaB_3 = class({})
end
function kunkkaB_3:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_kunkka/kunkka_shard_tidal_wave.vpcf", context)
end
function kunkkaB_3:OnSpellStart(vPosition, ExtraData)
	local hCaster = self:GetCaster()
	local vPosition = vPosition or self:GetCursorPosition()
	local vStart = hCaster:GetAbsOrigin()
	local vDirection = CalculateDirection(vPosition, vStart)

	local speed = self:GetSpecialValueFor("speed")
	local width = self:GetSpecialValueFor("width")
	local distance = self:GetSpecialValueFor("distance")

	local info = {
		Ability = self,
		Source = hCaster,
		EffectName = "particles/units/heroes/hero_kunkka/kunkka_shard_tidal_wave.vpcf",
		vSpawnOrigin = vStart,
		vVelocity = vDirection * speed,
		fDistance = distance,
		fStartRadius = width,
		fEndRadius = width,
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		ExtraData = ExtraData
	}
	ProjectileManager:CreateLinearProjectile(info)
end
function kunkkaB_3:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local tAttackInfo = GetAttackInfo(ExtraData.record, self:GetCaster())
		local hAttackAbility = EntIndexToHScript(ExtraData.iAbilityIndex)
		--命中
		EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, tAttackInfo)
		--伤害
		hAttackAbility:OnDamage(hTarget, tAttackInfo)

		hTarget:AddBuff(self:GetCaster(), BUFF_TYPE.CURSE.COLD, self:GetDuration(), true)
	else
		DelAttackInfo(ExtraData.record)
	end
	return false
end
function kunkkaB_3:GetIntrinsicModifierName()
	return "modifier_kunkkaB_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kunkkaB_3 == nil then
	modifier_kunkkaB_3 = class({}, nil, eom_modifier)
end
function modifier_kunkkaB_3:IsHidden()
	return true
end
function modifier_kunkkaB_3:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical")
	if IsServer() then
		self.tRecords = {}
	end
end
function modifier_kunkkaB_3:OnRefresh(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical")
end
function modifier_kunkkaB_3:EDeclareFunctions()
	return {
		EMDF_ATTACKT_ANIMATION,
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_OUTGOING_PERCENTAGE,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY,
		EMDF_ATTACKT_SPEED_BONUS
	}
end
function modifier_kunkkaB_3:GetAttackSpeedBonus()
	if not self:GetAbility():IsCooldownReady() then
		return self.attackspeed
	end
end
function modifier_kunkkaB_3:GetOutgoingPercentage(params)
	if params.attacker == self:GetParent() then
		local tAtkInfo = GetAttackInfoByDamageRecord(params.record, params.attacker)
		if tAtkInfo then
			if self.tRecords[tAtkInfo.record] then
				return self.physical2physical
			end
		end
	end
end
function modifier_kunkkaB_3:OnCustomAttackRecordDestroy(params)
	self.tRecords[params.record] = nil
end
function modifier_kunkkaB_3:GetAttackAnimation()
	if self:GetAbility():IsCooldownReady() then
		-- self:GetParent():AddActivityModifier("tidebringer")
		return ACT_DOTA_CAST_ABILITY_4
	end
	return ACT_DOTA_ATTACK
end
function modifier_kunkkaB_3:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = tAttackInfo.target

	if hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		self.tRecords[tAttackInfo.record] = true
		hAbility:OnSpellStart(hTarget:GetAbsOrigin(), { record = tAttackInfo.record, iAbilityIndex = hAttackAbility:entindex() })
		-- self:GetParent():RemoveActivityModifier("tidebringer")
	else
		--忽略自定义，使用原生攻击
		return false
	end
end