LinkLuaModifier("modifier_sniper_2", "abilities/tower/sniper/sniper_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sniper_2_jump", "abilities/tower/sniper/sniper_2.lua", LUA_MODIFIER_MOTION_BOTH)
--Abilities
if sniper_2 == nil then
	sniper_2 = class({})
end
function sniper_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local vForward = hCaster:GetForwardVector()
	local launch_duration = self:GetSpecialValueFor("launch_duration")

	local duration = self:GetDuration()
	hCaster:AddNewModifier(hCaster, self, "modifier_sniper_2_jump", { duration = launch_duration + duration })
end
function sniper_2:GetIntrinsicModifierName()
	return "modifier_sniper_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_sniper_2 == nil then
	modifier_sniper_2 = class({}, nil, BaseModifier)
end
function modifier_sniper_2:OnCreated(params)
	self.jump_horizontal_distance = self:GetAbilitySpecialValueFor('jump_horizontal_distance')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sniper_2:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and self:GetParent():GetAttackTarget() ~= nil then
		-- local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, self:GetParent():Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		-- if IsValid(tTargets[1]) then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
		})
		self:GetParent():SetForwardVector((self:GetParent():GetAttackTarget():GetAbsOrigin() - self:GetParent():GetAbsOrigin() + Vector(0, 0, -200)):Normalized())
		-- end
	end
end
---------------------------------------------------------------------
if modifier_sniper_2_jump == nil then
	modifier_sniper_2_jump = class({})
end
function modifier_sniper_2_jump:IsHidden()
	return true
end
function modifier_sniper_2_jump:OnCreated(params)
	self.bonus_attack_range = self:GetAbilitySpecialValueFor('bonus_attack_range')
	if IsServer() then
		self.launch_duration = self:GetAbilitySpecialValueFor('launch_duration')
		self.duration = self:GetAbility():GetDuration()
		self.jump_height = self:GetAbilitySpecialValueFor('jump_height')
		self.horizontal_distance = self:GetAbilitySpecialValueFor('horizontal_distance')
		self.vVelocity = -self:GetParent():GetForwardVector()
		self.flTime = 0
		self.bLanding = false
		self:StartIntervalThink(self.launch_duration)
		self:GetParent():StartGesture(ACT_DOTA_DIE)
		if not self:ApplyVerticalMotionController() or not self:ApplyHorizontalMotionController() then
			self:Destroy()
			return
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/sniper_rocket_left.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/sniper_rocket_right.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end

end
function modifier_sniper_2_jump:OnIntervalThink()
	self:StartIntervalThink(-1)
	self:GetParent():FadeGesture(ACT_DOTA_DIE)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/sniper_2.vpcf", PATTACH_CENTER_FOLLOW, self:GetParent())
	self:AddParticle(iParticleID, true, false, -1, false, false)
end
function modifier_sniper_2_jump:OnDestroy(params)
	if IsServer() then
		self:GetParent():RemoveVerticalMotionController(self)
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin(), true)
		self:GetParent():FadeGesture(ACT_DOTA_SPAWN)
		local vForward = self:GetParent():GetForwardVector()
		vForward.z = 0
		self:GetParent():SetForwardVector(vForward)
	end
end
function modifier_sniper_2_jump:UpdateVerticalMotion(me, dt)
	if IsServer() then
		if self.flTime < self.launch_duration then
			me:SetAbsOrigin(me:GetAbsOrigin() + self.jump_height / self.launch_duration * dt)
		else
			me:SetAbsOrigin(me:GetAbsOrigin() - self.jump_height / self.duration * dt)
			if self.flTime > self.duration + self.launch_duration - 0.3 and self.bLanding == false then
				self:GetParent():StartGesture(ACT_DOTA_SPAWN)
				self.bLanding = true
			end
		end
		self.flTime = self.flTime + dt
	end
end
function modifier_sniper_2_jump:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sniper_2_jump:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		if self.flTime < self.launch_duration then
			me:SetAbsOrigin(me:GetAbsOrigin() + self.vVelocity * self.horizontal_distance / self.launch_duration * dt)
		end
	end
end
function modifier_sniper_2_jump:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_sniper_2_jump:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		-- MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS
	}
end
function modifier_sniper_2_jump:GetActivityTranslationModifiers()
	return "overkilled"
end
function modifier_sniper_2_jump:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = self.flTime < self.launch_duration and true or false,
	}
end
function modifier_sniper_2_jump:GetModifierAttackRangeBonus(params)
	return self.bonus_attack_range
end
function modifier_sniper_2_jump:GetOverrideAnimation(params)
	return ACT_DOTA_FLAIL_STATUE
end