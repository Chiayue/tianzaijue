LinkLuaModifier("modifier_enigma_3_thinker", "abilities/tower/enigma/enigma_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enigma_3_pull", "abilities/tower/enigma/enigma_3.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if enigma_3 == nil then
	enigma_3 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function enigma_3:GetIntrinsicModifierName()
	return "modifier_enigma_3"
end
function enigma_3:GetAOERadius()
	return self:GetSpecialValueFor("pull_radius")
end
function enigma_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	CreateModifierThinker(hCaster, self, "modifier_enigma_3_thinker", { duration = duration }, vPosition + Vector(0, 0, 46), hCaster:GetTeamNumber(), false)
end
---------------------------------------------------------------------
--Modifiers
if modifier_enigma_3_thinker == nil then
	modifier_enigma_3_thinker = class({})
end
function modifier_enigma_3_thinker:IsHidden()
	return true
end
function modifier_enigma_3_thinker:IsDebuff()
	return false
end
function modifier_enigma_3_thinker:IsPurgable()
	return false
end
function modifier_enigma_3_thinker:IsPurgeException()
	return false
end
function modifier_enigma_3_thinker:IsStunDebuff()
	return false
end
function modifier_enigma_3_thinker:AllowIllusionDuplicate()
	return false
end
function modifier_enigma_3_thinker:IsAura()
	return true
end
function modifier_enigma_3_thinker:GetAuraRadius()
	return self.pull_radius
end
function modifier_enigma_3_thinker:GetModifierAura()
	return "modifier_enigma_3_pull"
end
function modifier_enigma_3_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end
function modifier_enigma_3_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_COURIER
end
function modifier_enigma_3_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES
end
function modifier_enigma_3_thinker:OnCreated(params)
	self.pull_radius = self:GetAbilitySpecialValueFor("pull_radius")
	if IsServer() then
		local hParent = self:GetParent()
		hParent:EmitSound("Hero_Enigma.Black_Hole")
		self.vPosition = hParent:GetAbsOrigin()

		-- particle
		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/econ/items/enigma/enigma_world_chasm/enigma_blackhole_ti5.vpcf", self:GetCaster()), PATTACH_WORLDORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, self.vPosition)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		self:StartIntervalThink(0)
	end
end
function modifier_enigma_3_thinker:OnRemoved()
	if IsServer() then
		StopSoundOn("Hero_Enigma.Black_Hole", self:GetParent())
		self:GetParent():EmitSound("Hero_Enigma.Black_Hole.Stop")
		self:GetParent():RemoveSelf()
	end
end
function modifier_enigma_3_thinker:OnIntervalThink()
	if IsServer() then
		if not IsValid(self:GetCaster()) or not IsValid(self:GetAbility()) then
			self:StartIntervalThink(-1)
			self:Destroy()
			return
		end
	end
end
function modifier_enigma_3_thinker:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
	}
end
---------------------------------------------------------------------
if modifier_enigma_3_pull == nil then
	modifier_enigma_3_pull = class({})
end
function modifier_enigma_3_pull:IsHidden()
	return false
end
function modifier_enigma_3_pull:IsDebuff()
	return true
end
function modifier_enigma_3_pull:IsPurgable()
	return false
end
function modifier_enigma_3_pull:IsPurgeException()
	return false
end
function modifier_enigma_3_pull:IsStunDebuff()
	return true
end
function modifier_enigma_3_pull:AllowIllusionDuplicate()
	return false
end
function modifier_enigma_3_pull:OnCreated(params)
	local duration = self:GetAbilitySpecialValueFor("duration")
	self.animation_rate = 0.2
	self.pull_speed = 30
	self.pull_radius = self:GetAbilitySpecialValueFor("pull_radius")
	self.tick_rate = 0.1
	self.pull_rotate_speed = 0.25
	self.far_radius = 700
	self.near_radius = 420
	self.damage_percent = self:GetAbilitySpecialValueFor("damage_percent")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
		self.time = 0
		self.aura_origin_x = params.aura_origin_x
		self.aura_origin_y = params.aura_origin_y
		self.vOrigin = GetGroundPosition(Vector(params.aura_origin_x, params.aura_origin_y, 0), self:GetParent())

		local iDistance = (self:GetParent():GetAbsOrigin() - self.vOrigin):Length2D()
		self.near = iDistance < self.near_radius and true or false

		self:StartIntervalThink(0)

		if not self:GetParent():IsBoss() and not self:GetParent():IsGoldWave() then
			if self:ApplyHorizontalMotionController() then
				-- self:GetParent():RemoveHorizontalMotionController(self)
			end
		end
	end
end
function modifier_enigma_3_pull:OnIntervalThink()
	if IsServer() then
		if self:GetAuraOwner() == nil then
			self:StartIntervalThink(-1)
			self:Destroy()
		end
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		if self.time < 29 then
			self.time = self.time + 1
		else
			self.time = 1
			local iDistance = (hParent:GetAbsOrigin() - self.vOrigin):Length2D()
			self.near = iDistance < self.near_radius and true or false
			local fDamage = hParent:GetMaxHealth() * self.damage_percent*0.01
			if hParent:IsBoss() or hParent:IsGoldWave() then
				fDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.damage_factor*0.01
			end
			ApplyDamage({
				ability = hAbility,
				attacker = hCaster,
				victim = hParent,
				damage = fDamage,
				damage_type = hAbility:GetAbilityDamageType()
			})
		end
	end
end
function modifier_enigma_3_pull:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_enigma_3_pull:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local vLocation = me:GetAbsOrigin()
		-- 到达中心后不再移动
		if (vLocation - self.vOrigin):Length2D() <= self.pull_speed * dt then
			me:SetAbsOrigin(self.vOrigin)
		else
			local vDirection = (self.vOrigin - vLocation):Normalized()
			vDirection.z = 0
			local iDistance = self.pull_speed * dt
			local vPoint = vLocation + vDirection * iDistance

			local x = math.cos(self.pull_rotate_speed * dt) * (vPoint.x - self.vOrigin.x) - math.sin(self.pull_rotate_speed * dt) * (vPoint.y - self.vOrigin.y) + self.vOrigin.x
			local y = math.sin(self.pull_rotate_speed * dt) * (vPoint.x - self.vOrigin.x) + math.cos(self.pull_rotate_speed * dt) * (vPoint.y - self.vOrigin.y) + self.vOrigin.y

			me:SetAbsOrigin(Vector(x, y, vLocation.z))
		end
	end
end
function modifier_enigma_3_pull:OnHorizontalMotionInterrupted()
	if IsServer() then

	end
end
function modifier_enigma_3_pull:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = self.near,
		[MODIFIER_STATE_SILENCED] = self.near,
	}
end
function modifier_enigma_3_pull:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
	}
end
function modifier_enigma_3_pull:GetOverrideAnimation(params)
	if not self:GetParent():IsBoss() and not self:GetParent():IsGoldWave() then
		return ACT_DOTA_FLAIL
	end
end
function modifier_enigma_3_pull:GetOverrideAnimationRate(params)
	if not self:GetParent():IsBoss() and not self:GetParent():IsGoldWave() then
		return self.animation_rate
	end
end