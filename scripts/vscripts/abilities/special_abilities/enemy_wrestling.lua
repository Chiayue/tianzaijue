LinkLuaModifier("modifier_enemy_wrestling", "abilities/special_abilities/enemy_wrestling.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_wrestling_wrestled", "abilities/special_abilities/enemy_wrestling.lua", LUA_MODIFIER_MOTION_BOTH)
-- LinkLuaModifier("modifier_enemy_wrestling_counter", "abilities/special_abilities/enemy_wrestling.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_wrestling == nil then
	enemy_wrestling = class({})
end
function enemy_wrestling:GetIntrinsicModifierName()
	return "modifier_enemy_wrestling"
end
function enemy_wrestling:GetBehavior()
	local iBehavior = self.BaseClass.GetBehavior(self)
	return iBehavior
end
function enemy_wrestling:CastFilterResultTarget(hTarget)
	local hCaster = self:GetCaster()
	if IsServer() then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for i = #tTargets, 1, -1 do
			local hTarget = tTargets[i]
			if hTarget == hCaster or hTarget:HasModifier("modifier_enemy_wrestling_wrestled") then
				table.remove(tTargets, i)
			end
		end
	end
	return UnitFilter(hTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, hCaster:GetTeamNumber())
end
function enemy_wrestling:CastFilterResultLocation(vLocation)
	local hCaster = self:GetCaster()
	if IsServer() then
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius"), DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		for i = #tTargets, 1, -1 do
			local hTarget = tTargets[i]
			if hTarget == hCaster or hTarget:HasModifier("modifier_enemy_wrestling_wrestled") then
				table.remove(tTargets, i)
			end
		end
	end
	return UF_SUCCESS
end
function enemy_wrestling:OnSpellStart()

	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, self:GetSpecialValueFor("grab_radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
	for i = #tTargets, 1, -1 do
		local hTarget = tTargets[i]
		if hTarget == hCaster or hTarget:HasModifier("modifier_enemy_wrestling_wrestled") then
			table.remove(tTargets, i)
		end
	end
	local hTossTarget = tTargets[1]

	if IsValid(hTossTarget) then
		hCaster:StartGesture(ACT_TINY_TOSS)

		-- local hTarget = self:GetCursorTarget()
		local vPosition = hTossTarget:GetAbsOrigin() - (hCaster:GetForwardVector() * self:GetSpecialValueFor("distance"))



		hTossTarget:AddNewModifier(hCaster, self, "modifier_enemy_wrestling_wrestled", {
			-- target_entindex = IsValid(hTarget) and hTarget:entindex() or nil,
			target_position = VectorToString(vPosition) or nil
		})

		hCaster:EmitSound("Ability.TossThrow")
		EmitSoundOnLocationWithCaster(hTossTarget:GetAbsOrigin(), "Hero_Tiny.Toss.Target", hCaster)
	end
end

---------------------------------------------------------------------
if modifier_enemy_wrestling_wrestled == nil then
	modifier_enemy_wrestling_wrestled = class({})
end
function modifier_enemy_wrestling_wrestled:IsHidden()
	return true
end
function modifier_enemy_wrestling_wrestled:IsDebuff()
	return false
end
function modifier_enemy_wrestling_wrestled:IsPurgable()
	return false
end
function modifier_enemy_wrestling_wrestled:IsPurgeException()
	return false
end
function modifier_enemy_wrestling_wrestled:IsStunDebuff()
	return false
end
function modifier_enemy_wrestling_wrestled:AllowIllusionDuplicate()
	return false
end
function modifier_enemy_wrestling_wrestled:RemoveOnDeath()
	return false
end
function modifier_enemy_wrestling_wrestled:GetEffectName()
	return ParticleManager:GetParticleReplacement("particles/units/heroes/hero_tiny/tiny_toss_blur.vpcf", self:GetCaster())
end
function modifier_enemy_wrestling_wrestled:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end
function modifier_enemy_wrestling_wrestled:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.radius = self:GetAbilitySpecialValueFor("grab_radius")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")

	if IsServer() then
		self.iCount = params.count or 0

		local hParent = self:GetParent()

		self.vTargetPosition = StringToVector(params.target_position)
		-- self.hTossTarget = EntIndexToHScript(params.target_entindex or -1)
		-- self.duration = self.duration * math.pow(1 - self.imba_bounce_reduction * 0.01, self.iCount)
		local sefAttack = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) or self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)
		self.toss_damage = self.damage_factor * sefAttack * 0.01

		if self.vTargetPosition == nil then
			self:Destroy()
			return
		end

		self.vTargetPosition = IsValid(self.hTossTarget) and self.hTossTarget:GetAbsOrigin() or self.vTargetPosition

		if self:ApplyHorizontalMotionController() and self:ApplyVerticalMotionController() then
			self.vStartPosition = GetGroundPosition(hParent:GetAbsOrigin(), hParent)

			self.fAcceleration = -3250
			self.fStartVerticalVelocity = -self.fAcceleration * self.duration / 2
			self.fGroundHeight = GetGroundHeight(hParent:GetAbsOrigin(), hParent)
			self.fStartTime = GameRules:GetGameTime()
		else
			self:Destroy()
		end
	end
end
function modifier_enemy_wrestling_wrestled:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		local hParent = self:GetParent()

		local vPosition = hParent:GetAbsOrigin()

		hParent:RemoveHorizontalMotionController(self)
		hParent:RemoveVerticalMotionController(self)

		FindClearSpaceForUnit(hParent, self.vTargetPosition, false)

		if not IsValid(hCaster) or not IsValid(hAbility) then
			return
		end

		EmitSoundOnLocationWithCaster(vPosition, "Ability.TossImpact", hCaster)

		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
		-- ApplyDamage({
		-- 	victim = hTarget,
		-- 	attacker = hCaster,
		-- 	damage = fDamage,
		-- 	damage_type = DAMAGE_TYPE_MAGICAL,
		-- 	ability = hAbility,
		-- })
		for _, hTarget in pairs(tTargets) do
			local fDamage = self.toss_damage

			ApplyDamage({
				victim = hTarget,
				attacker = hCaster,
				damage = fDamage,
				damage_type = DAMAGE_TYPE_MAGICAL,
				ability = hAbility,
			})
		end
	end
end

function modifier_enemy_wrestling_wrestled:UpdateHorizontalMotion(hParent, dt)
	if IsServer() then
		local constantPosition = self.vTargetPosition
		local vTargetPosition = constantPosition or self.vTargetPosition
		local fTime = GameRules:GetGameTime() - self.fStartTime

		hParent:SetAbsOrigin(VectorLerp(fTime / self.duration, self.vStartPosition, vTargetPosition))
		self.vTargetPosition = vTargetPosition
	end
end
function modifier_enemy_wrestling_wrestled:UpdateVerticalMotion(hParent, dt)
	if IsServer() then
		if GameRules:GetGameTime() - self.fStartTime < self.duration then
			local fGroundHeight = GetGroundHeight(hParent:GetAbsOrigin(), hParent)
			local fGroundDifference = fGroundHeight - self.fGroundHeight
			local fTime = GameRules:GetGameTime() - self.fStartTime
			local vPosition = self.vStartPosition + Vector(0, 0, fGroundDifference + self.fStartVerticalVelocity * fTime + self.fAcceleration * fTime * fTime / 2)
			hParent:SetAbsOrigin(vPosition)

			self.fGroundHeight = fGroundHeight
		else
			self:Destroy()
		end
	end
end
function modifier_enemy_wrestling_wrestled:OnHorizontalMotionInterrupted()
	if IsServer() then
	end
end
function modifier_enemy_wrestling_wrestled:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_enemy_wrestling_wrestled:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_enemy_wrestling_wrestled:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
end
function modifier_enemy_wrestling_wrestled:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_wrestling == nil then
	modifier_enemy_wrestling = class({}, nil, eom_modifier)
end
function modifier_enemy_wrestling:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_wrestling:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_wrestling:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_wrestling:DeclareFunctions()
	return {
	}
end
function modifier_enemy_wrestling:OnIntervalThink()
	local hAblt = self:GetAbility()
	local hParent = self:GetParent()
	if IsServer() then
		if hAblt:IsCooldownReady() and hAblt then
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 250, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)

			local hTarget = tTargets[RandomInt(1, #tTargets)]
			if IsValid(hTarget) and not IsCommanderTower(hTarget) then
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, hTarget, hAblt)
			end
		end
	end
end