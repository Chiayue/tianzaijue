
modifier_yj_1_1 = class({})

--------------------------------------------------------------------------------

function modifier_yj_1_1:GetTexture()
	return "xhp/战吼药剂"
end
--------------------------------------------------------------------------------

function modifier_yj_1_1:IsHidden()
	return false
end

function modifier_yj_1_1:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_yj_1_1:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_yj_1_1:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_yj_1_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function modifier_yj_1_1:GetModifierBaseDamageOutgoing_Percentage( params )
	return 50
end

function modifier_yj_1_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE 
end