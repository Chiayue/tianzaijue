
modifier_bw_all_17 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_17:GetTexture()
	return "item_treasure/智力冥想"
end

function modifier_bw_all_17:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_all_17:OnCreated( kv )
	self:OnRefresh()
end
function modifier_bw_all_17:OnRefresh()

end

--------------------------------------------------------------------------------

function modifier_bw_all_17:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
	
	}
	return funcs
end
function modifier_bw_all_17:GetModifierConstantManaRegen( params )
	return 20
end
function modifier_bw_all_17:GetModifierManaBonus( params )
	return 200
end



function modifier_bw_all_17:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

