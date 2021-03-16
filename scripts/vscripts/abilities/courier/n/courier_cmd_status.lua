LinkLuaModifier("modifier_courier_cmd_status", "abilities/courier/n/courier_cmd_status.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_cmd_status_buff", "abilities/courier/n/courier_cmd_status.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_cmd_status == nil then
	courier_cmd_status = class({})
end
function courier_cmd_status:GetIntrinsicModifierName()
	return "modifier_courier_cmd_status"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_cmd_status == nil then
	modifier_courier_cmd_status = class({}, nil, eom_modifier)
end
function modifier_courier_cmd_status:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local iPlayerID = self:GetPlayerID()
		local hCommander = Commander:GetCommander(iPlayerID)
		hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_courier_cmd_status_buff", nil)
	end
end
function modifier_courier_cmd_status:OnRefresh(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		local iPlayerID = self:GetPlayerID()
		local hCommander = Commander:GetCommander(iPlayerID)
		hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_courier_cmd_status_buff", nil)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_cmd_status_buff == nil then
	modifier_courier_cmd_status_buff = class({}, nil, eom_modifier)
end
function modifier_courier_cmd_status_buff:OnCreated(params)
	self.cmd_max_hp_bonus = self:GetAbilitySpecialValueFor('cmd_max_hp_bonus')
	self.cmd_attackpct = self:GetAbilitySpecialValueFor('cmd_attackpct')
end
function modifier_courier_cmd_status_buff:OnRefresh(params)
	self.cmd_max_hp_bonus = self:GetAbilitySpecialValueFor('cmd_max_hp_bonus')
	self.cmd_attackpct = self:GetAbilitySpecialValueFor('cmd_attackpct')
end
function modifier_courier_cmd_status_buff:EDeclareFunctions()
	return {
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = self.cmd_max_hp_bonus,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.cmd_attackpct,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.cmd_attackpct
	}
end
function modifier_courier_cmd_status_buff:GetStatusHealthBonusPercentage()
	return self.cmd_max_hp_bonus
end
function modifier_courier_cmd_status_buff:GetPhysicalAttackBonusPercentage()
	return self.cmd_attackpct
end
function modifier_courier_cmd_status_buff:GetMagicalAttackBonusPercentage()
	return self.cmd_attackpct
end