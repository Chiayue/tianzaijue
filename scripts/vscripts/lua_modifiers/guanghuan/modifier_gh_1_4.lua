
modifier_gh_1_4 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_4:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_4:IsHidden()
	return true
end

function modifier_gh_1_4:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/guanghuan/1_004.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_gh_1_4:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_gh_1_4:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_gh_1_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
function modifier_gh_1_4:GetModifierConstantManaRegen( params )
	return 3
end

function modifier_gh_1_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end