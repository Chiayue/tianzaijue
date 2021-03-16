if modifier_sp_caster == nil then
	modifier_sp_caster = class({}, nil, eom_modifier_aura)
end
local public = modifier_sp_caster
function public:GetAuraUnitType()
	return UnitType.AllFirends - UnitType.AllDerivatives
end
function public:GetAuraEntityReject(hEntity)
	return hEntity == self:GetParent()
end
function public:GetModifierAura()
	return "modifier_sp_aura"
end
function public:SetAuraModifier(hUnit)
	return hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), self:GetModifierAura(), nil)
end
function public:IsBattleAura()
	return false
end
