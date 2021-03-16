
modifier_gh_1_201 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_201:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_201:IsHidden()
	return true
end

function modifier_gh_1_201:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/guanghuan/1_201.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, Vector(200,0,0))
	end
	self:OnRefresh()
end
function modifier_gh_1_201:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_gh_1_201:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_gh_1_201:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
	return funcs
end
function modifier_gh_1_201:GetModifierHealthRegenPercentage( params )
	return 1
end
function modifier_gh_1_201:GetModifierConstantManaRegen( params )
	return 3
end
function modifier_gh_1_201:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end