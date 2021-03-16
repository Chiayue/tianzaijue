if modifier_ogre_med == nil then
	modifier_ogre_med = class({}, nil, ModifierHidden)
end
function modifier_ogre_med:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/ogre_hero_color.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, 1, false, false)
	end
end