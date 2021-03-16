LinkLuaModifier("modifier_chaos_knight_3", "abilities/tower/chaos_knight/chaos_knight_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_chaos_knight_3_buff", "abilities/tower/chaos_knight/chaos_knight_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if chaos_knight_3 == nil then
	chaos_knight_3 = class({iBehavior = DOTA_ABILITY_BEHAVIOR_POINT, iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET}, nil, ability_base_ai)
end
function chaos_knight_3:GetAOERadius()
	return self:GetSpecialValueFor("width")
end
function chaos_knight_3:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/chaos_knight/chaos_knight_3.vpcf", context)
end
function chaos_knight_3:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	local vCastPoint = self:GetCursorPosition()
	local vDirection = (vCastPoint - hCaster:GetAbsOrigin()):Normalized()
	self.iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_chaos_knight/chaos_knight_reality_rift.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(self.iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(self.iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControl(self.iParticleID, 2,hCaster:GetAbsOrigin() + vDirection * 200)
	ParticleManager:SetParticleControlForward(self.iParticleID, 2, vDirection)
	hCaster:EmitSound("Hero_ChaosKnight.RealityRift.Cast")
	return true
end
function chaos_knight_3:OnAbilityPhaseInterrupted()
	ParticleManager:DestroyParticle(self.iParticleID, false)
end
function chaos_knight_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local vCastPoint = self:GetCursorPosition()
	local vDirection = (vCastPoint - vCasterLoc):Normalized()
	local width = self:GetSpecialValueFor("width")
	local distance = self:GetCastRange(vec3_invalid, nil)
	local vPoint = vCasterLoc + vDirection * distance
	local duration = self:GetSpecialValueFor("duration")
	local vStartPosition = vCasterLoc - vDirection * width

	-- 冲锋buff
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_chaos_knight_3_buff", {duration = self:GetDuration()})
	end, UnitType.AllFirends)

	-- 特效
	local particleID = ParticleManager:CreateParticle("particles/units/heroes/chaos_knight/chaos_knight_3.vpcf", PATTACH_CUSTOMORIGIN, nil)
	-- ParticleManager:SetParticleControlEnt(particleID, 2, hCaster, PATTACH_CUSTOMORIGIN_FOLLOW, nil, vCasterLoc, true)
	ParticleManager:SetParticleControl(particleID, 0, vCasterLoc)
	ParticleManager:SetParticleControlForward(particleID, 0, vDirection)
	ParticleManager:SetParticleControl(particleID, 1, vPoint)
	ParticleManager:SetParticleControlForward(particleID, 3, vDirection)
	ParticleManager:ReleaseParticleIndex(particleID)
	-- 投射物
	local info = {
		EffectName = "",
		Ability = self,
		vSpawnOrigin = vStartPosition,
		fDistance = distance + width / 2,
		vVelocity = vDirection * (distance + width / 2),
		fStartRadius = width,
		fEndRadius = width,
		Source = hCaster,
		iUnitTargetTeam = self:GetAbilityTargetTeam(),
		iUnitTargetType = self:GetAbilityTargetType(),
		iUnitTargetFlags = self:GetAbilityTargetFlags(),
		fExpireTime = GameRules:GetGameTime() + 1
	}

	ProjectileManager:CreateLinearProjectile(info)

	hCaster:EmitSound("Hero_Centaur.Stampede.Cast")
end
function chaos_knight_3:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local hCaster = self:GetCaster()
	if hTarget then
		hCaster:DealDamage(hTarget, self, 0)
	end
end
function chaos_knight_3:GetIntrinsicModifierName()
	return "modifier_chaos_knight_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_chaos_knight_3 == nil then
	modifier_chaos_knight_3 = class({}, nil, ModifierHidden)
end
function modifier_chaos_knight_3:OnCreated(params)
	if IsServer() then
		self.distance = self:GetAbility():GetCastRange(vec3_invalid, nil)
		self:StartIntervalThink(1)
	end
end
function modifier_chaos_knight_3:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAbilityReady(self:GetAbility()) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.distance, self:GetAbility())
		if IsValid(tTargets[1]) then
			hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_POSITION, {vPosition = tTargets[1]:GetAbsOrigin(), iAnimationRate = 1.5, bIgnoreBackswing = 1})
		end
	end
end
------------------------------------------------------------------------------
if modifier_chaos_knight_3_buff == nil then
	modifier_chaos_knight_3_buff = class({}, nil, eom_modifier)
end
function modifier_chaos_knight_3_buff:OnCreated(params)
	self.move_speed_bonus_pct = self:GetAbilitySpecialValueFor("move_speed_bonus_pct")
	self.max_movespeed_pct = self:GetAbilitySpecialValueFor("max_movespeed_pct")
	self.damage_bonus_per_speed = self:GetAbilitySpecialValueFor("damage_bonus_per_speed")
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor("damage_bonus_pct")
	if IsServer() then

	end
end
function modifier_chaos_knight_3_buff:OnRefresh(params)
	self.move_speed_bonus_pct = self:GetAbilitySpecialValueFor("move_speed_bonus_pct")
	self.max_movespeed_pct = self:GetAbilitySpecialValueFor("max_movespeed_pct")
	self.damage_bonus_per_speed = self:GetAbilitySpecialValueFor("damage_bonus_per_speed")
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor("damage_bonus_pct")
	if IsServer() then
	end
end
function modifier_chaos_knight_3_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_chaos_knight_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT
	}
end
function modifier_chaos_knight_3_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_chaos_knight_3_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end
function modifier_chaos_knight_3_buff:GetModifierMoveSpeedBonus_Percentage()
	return RemapValClamped(self:GetElapsedTime(), 0, self:GetDuration() / 2, self.max_movespeed_pct, self.move_speed_bonus_pct)
end
function modifier_chaos_knight_3_buff:GetPhysicalAttackBonusPercentage()
	local fBase = self:GetParent():GetBaseMoveSpeed()
	local fMoveSpeed = self:GetParent():GetMoveSpeedModifier(fBase, false)
	return fMoveSpeed / self.damage_bonus_per_speed * self.damage_bonus_pct
end
function modifier_chaos_knight_3_buff:OnTooltip()
	local fBase = self:GetParent():GetBaseMoveSpeed()
	local fMoveSpeed = self:GetParent():GetMoveSpeedModifier(fBase, false)
	return fMoveSpeed / self.damage_bonus_per_speed * self.damage_bonus_pct
end