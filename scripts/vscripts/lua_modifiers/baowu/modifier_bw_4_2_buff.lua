
modifier_bw_4_2_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_4_2_buff:GetTexture()
	return "item_treasure/modifier_bw_4_2_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_4_2_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_4_2_buff:OnRefresh()
	
end


function modifier_bw_4_2_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifier_bw_4_2_buff:GetModifierPhysicalArmorBonus( params )
	return -40
end