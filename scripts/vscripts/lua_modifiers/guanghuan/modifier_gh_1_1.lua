
modifier_gh_1_1 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_1:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_1:IsHidden()
	return true
end

function modifier_gh_1_1:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/guanghuan/1_001.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_gh_1_1:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_gh_1_1:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_gh_1_1:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_gh_1_1:GetModifierPhysicalArmorBonus( params )
	return 10
end

function modifier_gh_1_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end