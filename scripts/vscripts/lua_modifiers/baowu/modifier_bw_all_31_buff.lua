
modifier_bw_all_31_buff = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_31_buff:GetTexture()
	return "item_treasure/modifier_bw_all_31_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_all_31_buff:OnCreated( kv )
	
	self:OnRefresh()
end
function modifier_bw_all_31_buff:IsHidden()
	return true
end

function modifier_bw_all_31_buff:OnRefresh()
	
end


function modifier_bw_all_31_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
	return funcs
end
function modifier_bw_all_31_buff:GetModifierTotal_ConstantBlock( params )
	if IsServer() then
		
		return 9999999
		
	end
	return 0
	
end

function modifier_bw_all_31_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end