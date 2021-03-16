LinkLuaModifier("modifier_tinker_3", "abilities/tower/tinker/tinker_3.lua", LUA_MODIFIER_MOTION_NONE)
if tinker_3 == nil then
	tinker_3 = class({iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET}, nil, ability_base_ai)
end
function tinker_3:GetAOERadius()
	return self:GetSpecialValueFor("distance")
end
function tinker_3:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius")
		local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("damage_factor") * 0.01
		local flAoeDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self:GetSpecialValueFor("aoe_damage_factor") * 0.01

		local vPosition = vLocation
		if IsValid(hTarget) then
			-- 直接伤害
			hCaster:DealDamage(hTarget, self, flDamage)
			-- 命中音效
			hTarget:EmitSound("Hero_Tinker.Heat-Seeking_Missile.Impact")
			hCaster:KnockBack(hCaster:GetAbsOrigin(), hTarget, self:GetSpecialValueFor("knockback_distance"), 0, self:GetSpecialValueFor("knockback_duration"), false)

			vPosition = hTarget:GetAbsOrigin()
		end

		-- 范围伤害
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, radius, self)
		hCaster:DealDamage(tTargets, self, flAoeDamage)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_tinker/tinker_missle_explosion.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, vLocation)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
	return true
end
function tinker_3:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_tinker_3", nil)
end
---------------------------------------------------------------------
-- Modifiers
if modifier_tinker_3 == nil then
	modifier_tinker_3 = class({}, nil, ModifierHidden)
end
function modifier_tinker_3:OnCreated(params)
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.missile_count = self:GetAbilitySpecialValueFor("missile_count")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + self.missile_count)
		self:StartIntervalThink(self.interval)
		self:OnIntervalThink()
	end
end
function modifier_tinker_3:OnRefresh(params)
	self.speed = self:GetAbilitySpecialValueFor("speed")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.missile_count = self:GetAbilitySpecialValueFor("missile_count")
	self.interval = self:GetAbilitySpecialValueFor("interval")
	if IsServer() then
		self:SetStackCount(self:GetStackCount() + self.missile_count)
	end
end
function modifier_tinker_3:OnStackCountChanged(iStackCount)
	if IsServer() then
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
	end
end
function modifier_tinker_3:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		local hAbility = self:GetAbility()
		if not IsValid(hAbility) or not IsValid(hCaster) then
			self:Destroy()
			return
		end

		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), self.distance, hAbility)
		if #tTargets > 0 then
			local hEnemy = GetRandomElement(tTargets)
			local tInfo = {
				Ability = hAbility,
				Target = hEnemy,
				iMoveSpeed = self.speed,
				vSourceLoc = hCaster:GetAttachmentOrigin(hCaster:ScriptLookupAttachment("attach_attack3")),
				EffectName = "particles/units/heroes/tinker/tinker_missile.vpcf",
			}
			ProjectileManager:CreateTrackingProjectile(tInfo)
			hCaster:EmitSound("Hero_Tinker.Heat-Seeking_Missile")

			self:DecrementStackCount()
		end

		self:StartIntervalThink(self.interval)
	end
end