LinkLuaModifier("modifier_enemy_knockback", "abilities/special_abilities/enemy_knockback.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_knockback == nil then
	enemy_knockback = class({})
end
function enemy_knockback:GetIntrinsicModifierName()
	return "modifier_enemy_knockback"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_knockback == nil then
	modifier_enemy_knockback = class({}, nil, eom_modifier)
end
function modifier_enemy_knockback:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.push_distance = self:GetAbilitySpecialValueFor("push_distance")
	self.knockback_duration = self:GetAbilitySpecialValueFor("knockback_duration")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_knockback:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.push_distance = self:GetAbilitySpecialValueFor("push_distance")
	self.knockback_duration = self:GetAbilitySpecialValueFor("knockback_duration")
	if IsServer() then
	end
end
function modifier_enemy_knockback:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_knockback:OnIntervalThink()

end
function modifier_enemy_knockback:EDeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_TAKEDAMAGE,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
-- function modifier_enemy_knockback:OnTakeDamage(params)
-- 	if self:GetParent() ~= params.attacker
-- 	then return end
-- 	local hParent = self:GetParent()
-- 	local vCenter = hParent:GetAbsOrigin()
-- 	if not params.unit:FindModifierByName('modifier_knockback') and RollPercentage(self.chance) then
-- 		if self:GetAbility():IsCooldownReady() then
-- 			self:GetAbility():UseResources(false, false, true)
-- 			hParent:KnockBack(vCenter, params.unit, self.push_distance, 0, 0.15, false)
-- 		end
-- 	end
-- end
function modifier_enemy_knockback:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	local hParent = self:GetParent()
	-- if IsAttackMiss(tAttackInfo) then return end
	local vCenter = hParent:GetAbsOrigin()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		if not hTarget:FindModifierByName('modifier_knockback') and RollPercentage(self.chance) then
			if self:GetAbility():IsCooldownReady() then
				self:GetAbility():UseResources(true, false, true)
				hParent:KnockBack(vCenter, hTarget, self.push_distance, 0, 0.15, false)
			end
		end
	end
end