if modifier_axe == nil then
	modifier_axe = class({}, nil, ModifierHidden)
end
function modifier_axe:OnCreated(params)
	if IsServer() then
	else
	end
end
function modifier_axe:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
end
function modifier_axe:GetAttackSound()
	return "Hero_Axe.Attack.Jungle"
end