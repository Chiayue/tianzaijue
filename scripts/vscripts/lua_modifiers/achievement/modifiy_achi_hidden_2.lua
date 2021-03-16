


modifiy_achi_hidden_2 = class({})

--------------------------------------------------------------------------------

function modifiy_achi_hidden_2:GetTexture()
	return "item_treasure/幽冥披巾"
end
--------------------------------------------------------------------------------
function modifiy_achi_hidden_2:IsHidden()
	return true
end
function modifiy_achi_hidden_2:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		temp["jnsh"] = 10
		AttributesSet(self:GetParent(),temp)
	end
end



function modifiy_achi_hidden_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifiy_achi_hidden_2:GetModifierSpellAmplify_Percentage( params )
	return  10
end
function modifiy_achi_hidden_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end