LinkLuaModifier("modifier_snapfire_1", "abilities/tower/snapfire/snapfire_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if snapfire_1 == nil then
	snapfire_1 = class({})
end
function snapfire_1:Spawn()
	local hCaster = self:GetCaster()
	hCaster.IsCooldownReady = function(hCaster)
		if self:GetLevel() > 0 and self:IsCooldownReady() then
			return true
		end
		return false
	end
	self.tRecord = {}
end
function snapfire_1:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/hero_snapfire/snapfire_1.vpcf", context)
end
function snapfire_1:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	local tAttackInfo = GetAttackInfo(ExtraData.record)
	local hAttackAbility = EntIndexToHScript(ExtraData.iAbilityIndex)
	if hTarget then
		hAttackAbility:OnDamage(hTarget, tAttackInfo)
	else
		if tAttackInfo then
			tAttackInfo.bullet = tAttackInfo.bullet - 1
			if tAttackInfo.bullet <= 0 then
				DelAttackInfo(ExtraData.record)
				ArrayRemove(self.tRecord, ExtraData.record)
			end
		end
	end
end
function snapfire_1:GetIntrinsicModifierName()
	return "modifier_snapfire_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_snapfire_1 == nil then
	modifier_snapfire_1 = class({}, nil, eom_modifier)
end
function modifier_snapfire_1:IsHidden()
	return true
end
function modifier_snapfire_1:OnCreated(params)
	self.blast_speed = self:GetAbilitySpecialValueFor("blast_speed")
	self.bullet_width = self:GetAbilitySpecialValueFor("bullet_width")
	self.bullet = self:GetAbilitySpecialValueFor("bullet")
	self.angle_per_bullet = self:GetAbilitySpecialValueFor("angle_per_bullet")
	self.max_angle = self:GetAbilitySpecialValueFor("max_angle")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
end
function modifier_snapfire_1:OnRefresh(params)
	self.blast_speed = self:GetAbilitySpecialValueFor("blast_speed")
	self.bullet_width = self:GetAbilitySpecialValueFor("bullet_width")
	self.bullet = self:GetAbilitySpecialValueFor("bullet")
	self.angle_per_bullet = self:GetAbilitySpecialValueFor("angle_per_bullet")
	self.max_angle = self:GetAbilitySpecialValueFor("max_angle")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.physical2physical = self:GetAbilitySpecialValueFor("physical2physical")
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
end
function modifier_snapfire_1:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_ANIMATION] = { 1 },
		EMDF_DO_ATTACK_BEHAVIOR,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_snapfire_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_POINT_CONSTANT,
	}
end
function modifier_snapfire_1:GetModifierAttackPointConstant()
	if self:GetAbility():IsCooldownReady() then
		return 0.6
	end
end
function modifier_snapfire_1:GetAttackAnimation()
	local hParent = self:GetParent()
	if self:GetAbility():IsCooldownReady() then
		return ACT_DOTA_CAST_ABILITY_1
	end
	return ACT_DOTA_ATTACK
end
function modifier_snapfire_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hTarget = tAttackInfo.target
	if self:GetAbility():IsCooldownReady() then
		for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			if iDamageType == DAMAGE_TYPE_PHYSICAL and tDamageInfo.damage > 0 then
				tDamageInfo.damage = tDamageInfo.damage * self.physical2physical * 0.01
			end
		end

		local iBullet = self.bullet	-- 子弹数量
		local angle_per_bullet = self.angle_per_bullet
		local flAngle = (iBullet - 1) * angle_per_bullet
		if flAngle > self.max_angle then
			angle_per_bullet = self.max_angle / (iBullet - 1)
			flAngle = self.max_angle
		end
		local vDirection = CalculateDirection(hTarget, hParent)
		local vInitDir = RotatePosition(Vector(0, 0, 0), QAngle(0, -flAngle / 2, 0), vDirection)
		local yaw = iBullet % 2 ~= 0 and ((iBullet + 1) / 2) * angle_per_bullet or (iBullet / 2 + 0.5) * angle_per_bullet
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_snapfire/snapfire_1.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
		ParticleManager:SetParticleControl(iParticleID, 1, vDirection * self.distance)
		ParticleManager:SetParticleControl(iParticleID, 2, Vector(iBullet, 360 / angle_per_bullet, -yaw))
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 记录
		table.insert(self:GetAbility().tRecord, tAttackInfo.record)
		-- 霰弹
		tAttackInfo.bullet = iBullet
		for i = 1, iBullet do
			local info = {
				Ability = self:GetAbility(),
				Source = hParent,
				EffectName = "",
				vSpawnOrigin = hParent:GetAbsOrigin(),
				vVelocity = RotatePosition(Vector(0, 0, 0), QAngle(0, angle_per_bullet * i, 0), vInitDir) * self.blast_speed,
				fDistance = self.distance,
				fStartRadius = self.bullet_width,
				fEndRadius = self.bullet_width,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
				iUnitTargetFlags = self:GetAbility():GetAbilityTargetFlags(),
				ExtraData = {
					record = tAttackInfo.record,
					iAbilityIndex = hAttackAbility:entindex()
				}
			}
			ProjectileManager:CreateLinearProjectile(info)
		end

		self:GetAbility():UseResources(false, false, true)
	else
		return false
	end
end
function modifier_snapfire_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if TableFindKey(self:GetAbility().tRecord, tAttackInfo.record) == nil then return end
end