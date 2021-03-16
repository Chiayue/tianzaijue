if modifier_lina == nil then
	modifier_lina = class({}, nil, ModifierHidden)
end
function modifier_lina:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_hand_old.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack2", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, true, 1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_flame_hand_old.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, true, 1, false, false)
	end
end