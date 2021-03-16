
modifier_gh_1_3 = class({})

--------------------------------------------------------------------------------

function modifier_gh_1_3:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_1_3:IsHidden()
	return true
end

function modifier_gh_1_3:OnCreated( kv )
	if IsServer() then
		self.nFXIndex = ParticleManager:CreateParticle( "particles/guanghuan/1_003.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetParent():GetOrigin() )
	end
	self:OnRefresh()
end
function modifier_gh_1_3:OnDestroy( kv )
	if IsServer() then
		if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
	end
end

function modifier_gh_1_3:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_gh_1_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifier_gh_1_3:GetModifierHealthRegenPercentage( params )
	return 1
end

function modifier_gh_1_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end