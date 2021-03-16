
modifier_yj_1_2 = class({})

--------------------------------------------------------------------------------

function modifier_yj_1_2:GetTexture()
	return "xhp/狂暴药剂"
end
--------------------------------------------------------------------------------

function modifier_yj_1_2:IsHidden()
	return false
end

function modifier_yj_1_2:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_bloodseeker/bloodseeker_bloodrage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_yj_1_2:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_yj_1_2:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_yj_1_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function modifier_yj_1_2:GetModifierAttackSpeedBonus_Constant( params )
	return 50
end

function modifier_yj_1_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_NONE 
end