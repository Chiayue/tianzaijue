LinkLuaModifier("modifier_ogre_med_3", "abilities/tower/ogre_med/ogre_med_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ogre_med_3 == nil then
	ogre_med_3 = class({})
end
function ogre_med_3:Action()
	if self:GetLevel() > 0 then
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_ogre_med_3", { duration = self:GetDuration() })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_ogre_med_3 == nil then
	modifier_ogre_med_3 = class({}, nil, eom_modifier)
end
function modifier_ogre_med_3:OnCreated(params)
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
	end
end
function modifier_ogre_med_3:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_ogre_med_3:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
	}
end
function modifier_ogre_med_3:GetPhysicalAttackBonusPercentage()
	return self.bonus_damage_pct * self:GetStackCount()
end
function modifier_ogre_med_3:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_ogre_med_3:OnTooltip()
	self.iTooltip = ((self.iTooltip or -1) + 1) % 2
	if 0 == self.iTooltip then
		return self:GetPhysicalAttackBonusPercentage()
	end
	return self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, self)
end