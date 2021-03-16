


modifiy_shopmall_gjzc_4 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_gjzc_4:GetTexture()
	return "rune/shopmall_gjzc_4"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_gjzc_4:IsHidden()
	return false
end
function modifiy_shopmall_gjzc_4:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		temp["jnsh"] = 20
		AttributesSet(self:GetParent(),temp)
	end
end



function modifiy_shopmall_gjzc_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifiy_shopmall_gjzc_4:GetModifierSpellAmplify_Percentage( params )
	return  20
end
function modifiy_shopmall_gjzc_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end