if modifier_courier_nian == nil then
	modifier_courier_nian = class({}, nil, ModifierHidden)
end
function modifier_courier_nian:OnCreated(params)
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/courier/status_effect_courier_nian.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, -1, false, false)
	end
end
function modifier_courier_nian:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_VISUAL_Z_DELTA
	}
end
function modifier_courier_nian:GetVisualZDelta()
	return 256
end