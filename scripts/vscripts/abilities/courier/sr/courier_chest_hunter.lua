LinkLuaModifier("modifier_courier_chest_hunter", "abilities/courier/sr/courier_chest_hunter.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_chest_hunter_buff", "abilities/courier/sr/courier_chest_hunter.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_chest_hunter == nil then
	courier_chest_hunter = class({})
end
function courier_chest_hunter:GetIntrinsicModifierName()
	return "modifier_courier_chest_hunter"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_chest_hunter == nil then
	modifier_courier_chest_hunter = class({}, nil, eom_modifier)
end
function modifier_courier_chest_hunter:IsHidden()
	return true
end
function modifier_courier_chest_hunter:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_SPAWNED, self.OnSpawned }
	}
end
function modifier_courier_chest_hunter:OnSpawned(tEvent)
	if tEvent.hUnit:IsGoldWave() then
		tEvent.hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_courier_chest_hunter_buff", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_chest_hunter_buff == nil then
	modifier_courier_chest_hunter_buff = class({}, nil, eom_modifier)
end
function modifier_courier_chest_hunter_buff:IsDebuff()
	return true
end
function modifier_courier_chest_hunter_buff:OnCreated(params)
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor('damage_bonus_pct')
end
function modifier_courier_chest_hunter_buff:OnRefresh(params)
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor('damage_bonus_pct')
end
function modifier_courier_chest_hunter_buff:EDeclareFunctions()
	return {
		[EMDF_INCOMING_PERCENTAGE] = self.damage_bonus_pct,
	}
end
function modifier_courier_chest_hunter_buff:GetIncomingPercentage()
	return self.damage_bonus_pct
end