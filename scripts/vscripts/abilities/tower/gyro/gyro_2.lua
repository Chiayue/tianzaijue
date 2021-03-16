LinkLuaModifier("modifier_gyro_2", "abilities/tower/gyro/gyro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyro_2_target", "abilities/tower/gyro/gyro_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_gyro_2_thinker", "abilities/tower/gyro/gyro_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if gyro_2 == nil then
	gyro_2 = class({}, nil, ability_base_ai)
end
function gyro_2:GetCastAnimation()
	return ACT_DOTA_OVERRIDE_ABILITY_4
end
function gyro_2:OnSpellStart()
	local hCaster = self:GetCaster()

	local hTarget = self:GetCursorTarget()
	local hDir = (hTarget:GetAbsOrigin() - hCaster:GetAbsOrigin()):Normalized()
	self.iAcceleration = self:GetSpecialValueFor("acceleration")
	self.iSpeed = self:GetSpecialValueFor("speed")
	self.fTime = GameRules:GetGameTime()
	local hHomingMissile = CreateUnitByName("npc_dota_gyrocopter_homing_missile", hCaster:GetAbsOrigin() + hDir * 150, true, hCaster, hCaster:GetOwnerEntity(), hCaster:GetTeam())
	hHomingMissile:SetForwardVector(hDir)
	local hHomingMissileModifier = hHomingMissile:AddNewModifier(hCaster, self, "modifier_gyro_2", {})
	-- hTarget:AddNewModifier(hHomingMissile, self,"modifier_truesight", {})
	hTarget:AddNewModifier(hCaster, self, "modifier_gyro_2_target", {})
	EmitSoundOn("Hero_Gyrocopter.HomingMissile", hHomingMissile)
	local hDis = (hHomingMissile:GetAbsOrigin() - hTarget:GetAbsOrigin()):Length2D()
	hHomingMissile.hTarget = hTarget
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_homing_missile_fuse.vpcf", PATTACH_POINT_FOLLOW, hHomingMissile)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hHomingMissile, PATTACH_POINT_FOLLOW, "attach_fuse", hHomingMissile:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hHomingMissile, PATTACH_POINT_FOLLOW, "attach_fuse", hHomingMissile:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:GameTimer(
	0.5,
	function()
		hHomingMissile:SetForwardVector(hDir)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile.vpcf", PATTACH_POINT_FOLLOW, hHomingMissile)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hHomingMissile, PATTACH_POINT_FOLLOW, "attach_fuse", hHomingMissile:GetAbsOrigin() + Vector(-100, 0, 0), false)
		if IsValid(hHomingMissileModifier) then
			hHomingMissileModifier:AddParticle(iParticleID, false, false, -1, false, false)
		else
			ParticleManager:DestroyParticle(iParticleID, true)
		end
		local info = {
			Target = hTarget,
			Source = hHomingMissile,
			vSpawnOrigin = hHomingMissile:GetAbsOrigin(),
			Ability = self,
			iMoveSpeed = self.iSpeed,
			bDodgeable = false,
			bProvidesVision = false,
			bDrawsOnMinimap = false,
			ExtraData = {
				hHomingMissileIndex = hHomingMissile:entindex()
			}
		}
		ProjectileManager:CreateTrackingProjectile(info)
		return
	end
	)
end
function gyro_2:OnProjectileThink_ExtraData(vLocation, ExtraData)
	if IsServer() then
		local hCaster = self:GetCaster()
		local hHomingMissile = EntIndexToHScript(ExtraData.hHomingMissileIndex)
		if IsValid(hHomingMissile) and (not IsValid(hHomingMissile.hTarget) or not hHomingMissile.hTarget:IsAlive() or hHomingMissile:IsFrozen()) then
			local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hHomingMissile:GetAbsOrigin(), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
			if #tTargets == 0 then
				hHomingMissile:ForceKill(false)
				return
			else
				hHomingMissile.hTarget = tTargets[1]
			end
		end
		if IsValid(hHomingMissile) and hHomingMissile:IsAlive() then
			hHomingMissile:SetAbsOrigin(Vector(vLocation.x, vLocation.y, hHomingMissile.hTarget:GetAbsOrigin().z))
			hHomingMissile:SetForwardVector((hHomingMissile.hTarget:GetAbsOrigin() - hHomingMissile:GetAbsOrigin()):Normalized())
			if GameRules:GetGameTime() - self.fTime >= 1 then
				self.iSpeed = self.iSpeed + self.iAcceleration
				self.fTime = GameRules:GetGameTime()
			end
			ProjectileManager:ChangeTrackingProjectileSpeed(self, self.iSpeed)
		end
	end
end
function gyro_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsServer() then
		local hHomingMissile = EntIndexToHScript(ExtraData.hHomingMissileIndex)
		local hCaster = self:GetCaster()
		if IsValid(hTarget) and IsValid(hHomingMissile) and hHomingMissile:IsAlive() then
			if hTarget:TriggerSpellAbsorb(self) then
				hHomingMissile:ForceKill(false)
				return
			end
			if IsValid(hTarget) and IsValid(hHomingMissile) then
				hTarget:TriggerSpellReflect(self)
			end
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_gyrocopter/gyro_guided_missile_explosion.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			if not hTarget:IsMagicImmune() and not hTarget:IsInvulnerable() then
				CreateModifierThinker(hCaster, self, "modifier_gyro_2_thinker", { duration = 1 }, hTarget:GetAbsOrigin(), hCaster:GetTeamNumber(), false)
			end
			hHomingMissile:ForceKill(false)
			EmitSoundOn("Hero_Gyrocopter.HomingMissile.Target", hTarget)
			EmitSoundOn("Hero_Gyrocopter.HomingMissile.Destroy", hTarget)
		end
	end
end
function gyro_2:IsHiddenWhenStolen()
	return false
end
---------------------------------------------------------------------
-- Modifiers
if modifier_gyro_2 == nil then
	modifier_gyro_2 = class({})
end
function modifier_gyro_2:IsHidden()
	return true
end
function modifier_gyro_2:IsDebuff()
	return false
end
function modifier_gyro_2:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
end
function modifier_gyro_2:IsStunDebuff()
	return false
end
function modifier_gyro_2:AllowIllusionDuplicate()
	return false
end
function modifier_gyro_2:OnCreated()
	self.iHitsToKill = self:GetAbilitySpecialValueFor("hits_to_kill_tooltip")
	self.iTowerHitsToKill = self:GetAbilitySpecialValueFor("tower_hits_to_kill_tooltip")
	AddModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, nil, self:GetParent())
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_gyro_2:OnIntervalThink()
	if IsServer() then
		if not IsValid(self:GetCaster()) then
			self:Destroy()
		end
	end
end
function modifier_gyro_2:OnAttackLanded(parmas)
	local iTotalHits = self:GetAbilitySpecialValueFor("hits_to_kill_tooltip")
	local iTowerHitsToKill = self:GetAbilitySpecialValueFor("tower_hits_to_kill_tooltip")
	if parmas.target == self:GetParent() then
		if parmas.attacker:IsTower() then
			self.iTowerHitsToKill = self.iTowerHitsToKill - 1
			self:GetParent():SetHealth(self:GetParent():GetMaxHealth() * self.iTowerHitsToKill / iTowerHitsToKill)
		end
		if parmas.attacker:IsHero() then
			self.iHitsToKill = self.iHitsToKill - 1
			self:GetParent():SetHealth(self:GetParent():GetMaxHealth() * self.iHitsToKill / iTotalHits)
		end
		if self.iTowerHitsToKill <= 0 or self.iHitsToKill <= 0 then
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_gyro_2:GetModifierIncomingDamage_Percentage(parmas)
	return -100
end
function modifier_gyro_2:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent().hTarget) then
			self:GetParent().hTarget:RemoveModifierByName("modifier_gyro_2_target")
		end
		self:GetParent():StopSound("Hero_Gyrocopter.HomingMissile")
		self:GetParent():AddNoDraw()
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ATTACK_LANDED, self, nil, self:GetParent())
end
-----------------------------------------
if modifier_gyro_2_target == nil then
	modifier_gyro_2_target = class({})
end
function modifier_gyro_2_target:IsHidden()
	return true
end
function modifier_gyro_2_target:IsDebuff()
	return true
end
function modifier_gyro_2_target:IsPurgable()
	return false
end
function modifier_gyro_2_target:IsPurgeException()
	return true
end
function modifier_gyro_2_target:IsStunDebuff()
	return false
end
function modifier_gyro_2_target:AllowIllusionDuplicate()
	return false
end
function modifier_gyro_2_target:OnCreated()
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticleForTeam("particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_guided_missile_target.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent(), self:GetCaster():GetTeamNumber())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_gyro_2_target:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PROVIDES_FOW_POSITION
	}
end
function modifier_gyro_2_target:GetModifierProvidesFOWVision()
	return 1
end
-----------------------------------------
if modifier_gyro_2_thinker == nil then
	modifier_gyro_2_thinker = class({}, nil, ParticleModifierThinker)
end
function modifier_gyro_2_thinker:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.poison = self:GetAbilitySpecialValueFor("poison")
	if IsServer() then
		self.damage = self:GetAbilitySpecialValueFor("damage")
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		hCaster:DealDamage(tTargets, self:GetAbility(), self:GetAbility():GetAbilityDamage())
		for _, hUnit in pairs(tTargets) do
			hUnit:AddBuff(hCaster, BUFF_TYPE.POISON, nil, true, { iCount = self.poison })
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_venomancer/venomancer_poison_nova.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end