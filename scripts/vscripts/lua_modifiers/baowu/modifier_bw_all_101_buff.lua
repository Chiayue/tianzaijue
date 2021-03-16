
modifier_bw_all_101_buff = class({})


function modifier_bw_all_101_buff:GetTexture()
	return "item_treasure/modifier_bw_all_101_buff"
end
--------------------------------------------------------------------------------


function modifier_bw_all_101_buff:IsHidden()
	return false
end
function modifier_bw_all_101_buff:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_101_buff:OnRefresh()
	
end


function modifier_bw_all_101_buff:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_all_101_buff:GetModifierSpellAmplify_Percentage( params )
	return  self:GetStackCount()
end

function modifier_bw_all_101_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end