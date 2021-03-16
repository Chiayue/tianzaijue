
modifier_bw_5_11 = class({})
--------------------------------------------------------------------------------

function modifier_bw_5_11:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_5_11:IsHidden()
	return true
end
function modifier_bw_5_11:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_11:OnRefresh()
	
end


function modifier_bw_5_11:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end

function modifier_bw_5_11:GetModifierBaseDamageOutgoing_Percentage( params )
	return  666
end

function modifier_bw_5_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end