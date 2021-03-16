
modifier_bw_2_2 = class({})

--------------------------------------------------------------------------------

function modifier_bw_2_2:GetTexture()
	return "item_treasure/挑战头巾"
end
--------------------------------------------------------------------------------

function modifier_bw_2_2:IsHidden()
	return true
end

function modifier_bw_2_2:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_2:OnRefresh()
	if IsServer() then
		
	end
end
function modifier_bw_2_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
	return funcs
end
function modifier_bw_2_2:GetModifierHealthRegenPercentage( params )
	return 5
end
function modifier_bw_2_2:GetModifierMagicalResistanceBonus( params )
	return 20
end
function modifier_bw_2_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

