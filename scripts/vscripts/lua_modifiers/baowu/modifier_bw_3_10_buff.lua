
modifier_bw_3_10_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_10_buff:GetTexture()
	return "item_treasure/modifier_bw_3_10_buff"
end
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function modifier_bw_3_10_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_10_buff:OnRefresh()
	
end


function modifier_bw_3_10_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_bw_3_10_buff:GetModifierPhysicalArmorBonus( params )
	return -20
end
