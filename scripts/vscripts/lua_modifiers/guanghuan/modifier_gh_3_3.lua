
modifier_gh_2_3 = class({})

--------------------------------------------------------------------------------

function modifier_gh_2_3:GetTexture()
	return "item_treasure/刃甲"
end
--------------------------------------------------------------------------------

function modifier_gh_2_3:IsHidden()
	return true
end

function modifier_gh_2_3:OnCreated( kv )
	self:OnRefresh()
end
function modifier_gh_2_3:OnDestroy( kv )
	
end

function modifier_gh_2_3:OnRefresh()
	if IsServer() then
	
	end
end
function modifier_gh_2_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifier_gh_2_3:GetModifierHealthRegenPercentage( params )
	return 0.75
end

function modifier_gh_2_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end