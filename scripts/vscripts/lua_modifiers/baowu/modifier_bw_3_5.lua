
modifier_bw_3_5 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_5:GetTexture()
	return "item_treasure/永恒遗物"
end
--------------------------------------------------------------------------------
function modifier_bw_3_5:IsHidden()
	return true
end
function modifier_bw_3_5:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_5:OnRefresh()
	
end


function modifier_bw_3_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifier_bw_3_5:GetModifierSpellAmplify_Percentage( params )
	return 80
end
function modifier_bw_3_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end