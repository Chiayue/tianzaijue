LinkLuaModifier("modifier_enemy_ice", "abilities/special_abilities/enemy_ice.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_ice == nil then
	enemy_ice = class({})
end
function enemy_ice:GetIntrinsicModifierName()
	return "modifier_enemy_ice"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_ice == nil then
	modifier_enemy_ice = class({}, nil, eom_modifier)
end
function modifier_enemy_ice:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.ice_duration = self:GetAbilitySpecialValueFor("ice_duration")
	if IsServer() then
	end
end
function modifier_enemy_ice:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.ice_duration = self:GetAbilitySpecialValueFor("ice_duration")
	if IsServer() then
	end
end
function modifier_enemy_ice:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_ice:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_enemy_ice:OnAttackLanded(params)
	if params.attacker ~= self:GetParent()
	or not IsValid(params.target)
	then return end
	if RollPercentage(self.chance) and self:GetAbility():IsCooldownReady() then
		self:GetAbility():UseResources(false, false, true)
		params.target:AddBuff(self:GetParent(), BUFF_TYPE.FROZEN, self.ice_duration)
	end
end