LinkLuaModifier("modifier_golemB_3", "abilities/tower/golemB/golemB_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if golemB_3 == nil then
	golemB_3 = class({})
end
function golemB_3:GetIntrinsicModifierName()
	return "modifier_golemB_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_golemB_3 == nil then
	modifier_golemB_3 = class({}, nil, eom_modifier)
end
function modifier_golemB_3:OnCreated(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_golemB_3:OnRefresh(params)
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_golemB_3:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.bonus_armor,
		[MODIFIER_EVENT_ON_ATTACK] = {nil, self:GetParent() }
	}
end
function modifier_golemB_3:GetPhysicalArmorBonus()
	return self.bonus_armor
end
function modifier_golemB_3:OnAttack(params)
	if RollPercentage(self.chance) then
		params.attacker:AddBuff(self:GetParent(), BUFF_TYPE.DISARM, self:GetAbility():GetDuration())
	end
end
function modifier_golemB_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_golemB_3:OnTooltip()
	return self.bonus_armor
end