LinkLuaModifier("modifier_enemy_implate", "abilities/special_abilities/enemy_implate.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_impale_motion", "abilities/special_abilities/enemy_implate.lua", LUA_MODIFIER_MOTION_VERTICAL)
--Abilities
if enemy_implate == nil then
	enemy_implate = class({})
end
function enemy_implate:GetIntrinsicModifierName()
	return "modifier_enemy_implate"
end
function enemy_implate:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = self:GetCursorPosition()

	if IsValid(hTarget) then
		vPosition = hTarget:GetAbsOrigin()
	end

	local vOrigin = hCaster:GetAbsOrigin()
	local vDirection = CalculateDirection(vPosition, hCaster)
	local fDistance = self:GetSpecialValueFor("range")

	self:Fire(vOrigin, vDirection, fDistance)

	local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_lion/lion_spell_impale_staff.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("Hero_Lion.Impale")
end

function enemy_implate:Fire(vOrigin, vDirection, fDistance, tHashtable)
	local bIsBranch = true
	if tHashtable == nil then
		tHashtable = CreateHashtable()
		tHashtable.iCount = 0
		tHashtable.tTargets = {}
		bIsBranch = false
	end
	local hCaster = self:GetCaster()
	local width = self:GetSpecialValueFor("width")
	local speed = self:GetSpecialValueFor("speed")

	local fDuration = fDistance / speed + FrameTime()
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_impale_ground.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vOrigin)
	ParticleManager:SetParticleControlForward(iParticleID, 0, vDirection)
	ParticleManager:SetParticleControl(iParticleID, 1, GetGroundPosition(vOrigin + vDirection * speed * fDuration, hCaster))
	ParticleManager:SetParticleControl(iParticleID, 2, Vector(1 / (fDuration * 3), fDuration * 3, 1))
	ParticleManager:ReleaseParticleIndex(iParticleID)

	iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_impale.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vOrigin)
	ParticleManager:SetParticleControl(iParticleID, 1, vDirection * speed)

	local tProjectileInfo = {
		Source = hCaster,
		Ability = self,
		vSpawnOrigin = vOrigin,

		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,

		EffectName = "",
		fDistance = fDistance,
		fStartRadius = width,
		fEndRadius = width,
		vVelocity = vDirection * speed,

		ExtraData = {
			iParticleID = iParticleID,
			iHashtableIndex = GetHashtableIndex(tHashtable),
			bIsBranch = bIsBranch and 1 or 0,
			vDirection = VectorToString(vDirection),
		}
	}
	ProjectileManager:CreateLinearProjectile(tProjectileInfo)
end
function enemy_implate:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	local tHashtable = GetHashtableByIndex(ExtraData.iHashtableIndex)
	if not IsValid(hTarget) then
		ParticleManager:DestroyParticle(ExtraData.iParticleID, false)
		ParticleManager:ReleaseParticleIndex(ExtraData.iParticleID)
		if tHashtable.iCount <= 0 then
			RemoveHashtable(tHashtable)
		end
		return true
	end

	if TableFindKey(tHashtable.tTargets, hTarget) ~= nil then
		return false
	end

	table.insert(tHashtable.tTargets, hTarget)

	if hTarget:TriggerSpellAbsorb(self) then
		return false
	end

	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")

	hTarget:AddBuff(self:GetCaster(), BUFF_TYPE.STUN, duration)
	hTarget:RemoveModifierByName("modifier_enemy_impale_motion")
	hTarget:AddNewModifier(hCaster, self, "modifier_enemy_impale_motion", { duration = duration })

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lion/lion_spell_impale_hit_spikes.vpcf", PATTACH_ABSORIGIN, hTarget)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Lion.ImpaleHitTarget", hCaster)
end

---------------------------------------------------------------------
if modifier_enemy_impale_motion == nil then
	modifier_enemy_impale_motion = class({}, nil, VerticalModifier)
end
function modifier_enemy_impale_motion:IsHidden()
	return true
end
function modifier_enemy_impale_motion:IsDebuff()
	return true
end
function modifier_enemy_impale_motion:IsPurgable()
	return false
end
function modifier_enemy_impale_motion:IsPurgeException()
	return true
end
function modifier_enemy_impale_motion:IsStunDebuff()
	return true
end
function modifier_enemy_impale_motion:AllowIllusionDuplicate()
	return false
end
function modifier_enemy_impale_motion:GetPriority()
	return MODIFIER_PRIORITY_HIGH
end
function modifier_enemy_impale_motion:OnCreated(params)
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
		self.fMotionDuration = 0.5
		self.fHeight = 350
		if self:ApplyVerticalMotionController() then
			self.fTime = 0
			local fHeightDifference = self.fHeight - (self:GetParent():GetAbsOrigin()).z
			self.vAcceleration = -self:GetParent():GetUpVector() * 10000
			self.vStartVerticalVelocity = Vector(0, 0, fHeightDifference) / self.fMotionDuration - self.vAcceleration * self.fMotionDuration / 2
		else
			self:Destroy()
		end
	end
end
function modifier_enemy_impale_motion:OnDestroy()
	if IsServer() then
		if IsValid(self:GetCaster()) and IsValid(self:GetParent()) then
			local fDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) or self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)
			local damage_table =			{
				ability = self:GetAbility(),
				attacker = self:GetCaster(),
				victim = self:GetParent(),
				damage = self.damage_factor * fDamage,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			ApplyDamage(damage_table)
		end
		self:GetParent():RemoveVerticalMotionController(self)
	end
end
function modifier_enemy_impale_motion:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_enemy_impale_motion:UpdateVerticalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin() + (self.vAcceleration * self.fTime + self.vStartVerticalVelocity) * dt)
		self.fTime = self.fTime + dt
		if self.fTime > self.fMotionDuration then
			self:Destroy()
		end
	end
end
function modifier_enemy_impale_motion:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_enemy_impale_motion:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_implate == nil then
	modifier_enemy_implate = class({}, nil, eom_modifier)
end
function modifier_enemy_implate:OnCreated(params)
	self.trigger_stack = self:GetAbilitySpecialValueFor("trigger_stack")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	end
end
function modifier_enemy_implate:OnRefresh(params)
	self.trigger_stack = self:GetAbilitySpecialValueFor("trigger_stack")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	end
end
function modifier_enemy_implate:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_implate:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_enemy_implate:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	-- if not self:GetParent():IsIllusion() and self:GetStackCount() <= self.trigger_stack then
	-- self:IncrementStackCount()
	-- else
	if hAbility and self:GetParent():IsAbilityReady(hAbility) then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.range, self:GetAbility(), FIND_ANY_ORDER)
		hTarget = tTargets[1]
		if IsValid(hTarget) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, hTarget, self:GetAbility())
		end
		-- self:SetStackCount(0)
		-- end
	end

end