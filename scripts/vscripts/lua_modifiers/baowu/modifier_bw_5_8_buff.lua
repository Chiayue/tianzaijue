
modifier_bw_5_8_buff = class({})


function modifier_bw_5_8_buff:GetTexture()
	return "item_treasure/bw_5_8"
end
--------------------------------------------------------------------------------


function modifier_bw_5_8_buff:IsHidden()
	return false
end
function modifier_bw_5_8_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_8_buff:OnRefresh()
	
end




function modifier_bw_5_8_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end