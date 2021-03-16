
modifier_gh_1_101 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_101:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_101:IsHidden()
	return true
end

function modifier_gh_1_101:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/guanghuan/1_101.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(200,0,0))
	end
	self:OnRefresh()
end
function modifier_gh_1_101:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end
function modifier_gh_1_101:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_gh_1_101:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_gh_1_101:GetModifierPhysicalArmorBonus( params )
	return 10
end
function modifier_gh_1_101:GetModifierMagicalResistanceBonus( params )
	return 10
end
function modifier_gh_1_101:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end