LinkLuaModifier("modifier_juggernaut_3", "abilities/tower/juggernaut/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_3_buff", "abilities/tower/juggernaut/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_3_particle", "abilities/tower/juggernaut/juggernaut_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if juggernaut_3 == nil then
	juggernaut_3 = class({}, nil, ability_base_ai)
end
function juggernaut_3:GetAOERadius()
	return self:GetSpecialValueFor("attack_range")
end
function juggernaut_3:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/juggernaut/juggernaut_3.vpcf", context)
	PrecacheResource("particle", "particles/units/heroes/juggernaut/juggernaut_3_2.vpcf", context)
end
function juggernaut_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_3_buff", { duration = self:GetDuration() })
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_3_buff == nil then
	modifier_juggernaut_3_buff = class({}, nil, eom_modifier)
end
function modifier_juggernaut_3_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.attack_range = self:GetAbilitySpecialValueFor("attack_range")
	self.damage_add = self:GetAbilitySpecialValueFor("damage_add")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.physical_factor = self:GetAbilitySpecialValueFor("physical_factor")
	if IsServer() then
		self.count = 0	-- 次数标记
		self.flDamageRecorder = 0	-- 记录格挡次数
		self:StartIntervalThink(self.interval)
		-- self:OnIntervalThink()
	else
	end
end
function modifier_juggernaut_3_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.attack_range, hAbility)
	if IsValid(tTargets[1]) then
		hParent:Attack(tTargets[1], ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
	end
	-- 挥剑特效
	local sParticleName = self.count == 0 and "particles/units/heroes/juggernaut/juggernaut_3_2.vpcf" or "particles/units/heroes/juggernaut/juggernaut_3.vpcf"
	local iParticleID = ParticleManager:CreateParticle(sParticleName, PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
	self:AddParticle(iParticleID, false, false, -1, false, false)
	-- 音效
	self:GetParent():EmitSound("Hero_DragonKnight.PreAttack")
	self.count = self.count == 0 and 1 or 0
end
function modifier_juggernaut_3_buff:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() and hParent:IsAlive() and GSManager:getStateType() == GS_Battle then
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_juggernaut_3_particle", { duration = 0.5 })
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility())
		hParent:DealDamage(tTargets, self:GetAbility(), self.physical_factor * hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * (1 + self.flDamageRecorder * self.damage_add * 0.01) * 0.01)
		for _, hUnit in pairs(tTargets) do
			hParent:KnockBack(hParent:GetAbsOrigin(), hUnit, 300, 0, 0.1, true)
		end
	end
end
function modifier_juggernaut_3_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_INCOMING_PERCENTAGE] = -1000,
		-- EMDF_MAGICAL_INCOMING_PERCENTAGE,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		EMDF_EVENT_ON_ATTACK_HIT,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_juggernaut_3_buff:OnBattleEnd()
	-- 处理动作
	self:Destroy()
	self:GetParent():FadeGesture(ACT_DOTA_GENERIC_CHANNEL_1)
end
function modifier_juggernaut_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE
	}
end
function modifier_juggernaut_3_buff:CheckState()
	return {
	-- [MODIFIER_STATE_DISARMED] = true
	}
end
function modifier_juggernaut_3_buff:GetPhysicalIncomingPercentage(params)
	return -1000
end
-- function modifier_juggernaut_3_buff:GetMagicalIncomingPercentage(params)
-- 	return -1000
-- end
function modifier_juggernaut_3_buff:OnTakeDamage(params)
	if IsServer() then
		self.flDamageRecorder = self.flDamageRecorder + 1
	end
end
function modifier_juggernaut_3_buff:GetOverrideAnimation()
	return ACT_DOTA_GENERIC_CHANNEL_1
end
function modifier_juggernaut_3_buff:GetOverrideAnimationRate()
	return 2
end
function modifier_juggernaut_3_buff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if hTarget == self:GetParent() then
		-- 记录远程伤害
		for k, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			self.flDamageRecorder = self.flDamageRecorder + 1
		end
		--是否支持弹道反弹
		if tAttackInfo.tProjectileInfo and tAttackInfo.tProjectileInfo.bRebound then
			local tInfo = shallowcopy(tAttackInfo.tProjectileInfo)

			if tAttackInfo.typeProjectile == PROJECTILE_TYPE.Tracking then
				tInfo.Target = tInfo.Source
				tInfo.Source = self:GetParent()
				tInfo.vSourceLoc = self:GetParent():GetAbsOrigin()
				tInfo.iMoveSpeed = tInfo.iMoveSpeed * 4
				ProjectileManager:CreateTrackingProjectile(tInfo)
			else
				tInfo.Source = self:GetParent()
				tInfo.vSpawnOrigin = self:GetParent():GetAbsOrigin()
				tInfo.vVelocity = tInfo.vVelocity * -4
				ProjectileManager:CreateLinearProjectile(tInfo)
			end
			--中断原弹道
			return true
		end
	end
end
function modifier_juggernaut_3_buff:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hTarget = tAttackInfo.target
	local flFaceAngle = VectorToAngles(hParent:GetForwardVector())[2]
	-- 范围伤害
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.attack_range, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		local vDirection = CalculateDirection(hUnit, hParent)
		local flAngle = VectorToAngles(vDirection)[2]
		if AngleDiff(flFaceAngle, flAngle) <= 100 then
			--命中
			EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hUnit, tAttackInfo)
			--伤害
			hAttackAbility:OnDamage(hUnit, tAttackInfo)
		end
	end
end
function modifier_juggernaut_3_buff:OnAttackRecordDestroy(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, hCaster)
	if nil == params then return end
	DelAttackInfo(params.record)
end
---------------------------------------------------------------------
if modifier_juggernaut_3_particle == nil then
	modifier_juggernaut_3_particle = class({}, nil, eom_modifier)
end
function modifier_juggernaut_3_particle:IsHidden()
	return true
end
function modifier_juggernaut_3_particle:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:GetParent():EmitSound("Hero_Juggernaut.BladeFuryStart")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_ti8_sword/juggernaut_crimson_blade_fury_abyssal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(self.radius, 1, 1))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_3_particle:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_Juggernaut.BladeFuryStart")
	end
end
function modifier_juggernaut_3_particle:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_juggernaut_3_particle:GetOverrideAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_1
end
function modifier_juggernaut_3_particle:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_juggernaut_3_particle:OnBattleEnd()
	-- 处理动作
	self:GetParent():FadeGesture(ACT_DOTA_OVERRIDE_ABILITY_1)
end