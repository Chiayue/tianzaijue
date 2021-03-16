LinkLuaModifier("modifier_sniper_2_buff", "abilities/tower/sniper/sniper_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sniper_2_attackspeed", "abilities/tower/sniper/sniper_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sniper_2_knockback", "abilities/tower/sniper/sniper_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
--Abilities
if sniper_2 == nil then
	sniper_2 = class({}, nil, ability_base_ai)
end
function sniper_2:OnAbilityPhaseStart()
	local hCaster = self:GetCaster()
	hCaster:AddNewModifier(hCaster, self, "modifier_sniper_2_buff", { duration = self:GetDuration() })
	hCaster:EmitSound("Ability.AssassinateLoad")
	return true
end
function sniper_2:OnChannelFinish(bInterrupted)
	if bInterrupted == false then
		local hCaster = self:GetCaster()
		hCaster:AddNewModifier(hCaster, self, "modifier_sniper_2_attackspeed", { duration = self:GetSpecialValueFor("duration") })
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), -1, self, FIND_CLOSEST)
		if IsValid(tTargets[1]) then
			local hTarget = tTargets[1]
			local info = {
				EffectName = "particles/econ/items/sniper/sniper_charlie/sniper_assassinate_charlie.vpcf",
				Ability = self,
				iMoveSpeed = 2000,
				Source = hCaster,
				Target = hTarget,
				iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
				vSourceLoc = hCaster:GetAbsOrigin(),
				bDodgeable = true,
				ExtraData = {
					vStartX = hCaster:GetAbsOrigin().x,
					vStartY = hCaster:GetAbsOrigin().y
				}
			}
			ProjectileManager:CreateTrackingProjectile(info)
			hCaster:EmitSound("Hero_Sniper.Projection")
			hCaster:EmitSound("Hero_Sniper.AssassinateProjectile")
		end
	end
end
function sniper_2:OnProjectileHit_ExtraData(hTarget, vLocation, ExtraData)
	if IsValid(hTarget) then
		local hCaster = self:GetCaster()
		local vStart = Vector(ExtraData.vStartX, ExtraData.vStartY, 0)
		local flDistance = (vStart - vLocation):Length2D()
		local vDir = (vLocation - vStart):Normalized()
		local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetSpecialValueFor("damage_per_distance") * 0.01 * flDistance / self:GetSpecialValueFor("distance")
		hCaster:DealDamage(hTarget, self, flDamage)
		if flDistance < self:GetSpecialValueFor("knockback_distance") then
			hTarget:AddNewModifier(hCaster, self, "modifier_sniper_2_knockback", { duration = (self:GetSpecialValueFor("knockback_distance") - flDistance) / self:GetSpecialValueFor("knockback_speed"), vDir = vDir })
		end
		hCaster:EmitSound("Hero_Sniper.AssassinateDamage")
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_sniper_2_buff == nil then
	modifier_sniper_2_buff = class({}, nil, BaseModifier)
end
function modifier_sniper_2_buff:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_charlie/sniper_crosshair_charlie.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_sniper_2_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_sniper_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
	}
end
function modifier_sniper_2_buff:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_FROZEN] = self:GetElapsedTime() > 1.98,
	}
end
function modifier_sniper_2_buff:GetModifierInvisibilityLevel()
	return 1
end
function modifier_sniper_2_buff:GetActivityTranslationModifiers()
	return "instagib"
end
---------------------------------------------------------------------
if modifier_sniper_2_attackspeed == nil then
	modifier_sniper_2_attackspeed = class({}, nil, eom_modifier)
end
function modifier_sniper_2_attackspeed:OnCreated(params)
	self.bonus_attackspeed = self:GetAbilitySpecialValueFor("bonus_attackspeed")
end
function modifier_sniper_2_attackspeed:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.bonus_attackspeed,
	}
end
function modifier_sniper_2_attackspeed:GetAttackSpeedBonus()
	return self.bonus_attackspeed
end
function modifier_sniper_2_attackspeed:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_sniper_2_attackspeed:OnTooltip()
	return self.bonus_attackspeed
end
---------------------------------------------------------------------
if modifier_sniper_2_knockback == nil then
	modifier_sniper_2_knockback = class({}, nil, HorizontalModifier)
end
function modifier_sniper_2_knockback:OnCreated(params)
	if IsServer() then
		self.knockback_speed = self:GetAbilitySpecialValueFor("knockback_speed")
		self.vDir = StringToVector(params.vDir)

		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	end
end
function modifier_sniper_2_knockback:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveHorizontalMotionController(self)
	end
end
function modifier_sniper_2_knockback:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		me:SetAbsOrigin(me:GetAbsOrigin() + self.vDir * self.knockback_speed * dt)
	end
end
function modifier_sniper_2_knockback:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sniper_2_knockback:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_sniper_2_knockback:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
end
function modifier_sniper_2_knockback:GetOverrideAnimation()
	return ACT_DOTA_DISABLED
end