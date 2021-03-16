


modifiy_shopmall_jjzc_4 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_jjzc_4:GetTexture()
	return "rune/shopmall_jjzc_4"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_jjzc_4:IsHidden()
	return true
end
function modifiy_shopmall_jjzc_4:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		temp["jnsh"] = 5
		AttributesSet(self:GetParent(),temp)
	end
end



function modifiy_shopmall_jjzc_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifiy_shopmall_jjzc_4:GetModifierSpellAmplify_Percentage( params )
	return  5
end
function modifiy_shopmall_jjzc_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end