


modifiy_maplevel_11 = class({})

--------------------------------------------------------------------------------

function modifiy_maplevel_11:GetTexture()
	return "item_treasure/幽冥披巾"
end
--------------------------------------------------------------------------------
function modifiy_maplevel_11:IsHidden()
	return true
end
function modifiy_maplevel_11:OnCreated( kv )
	if IsServer(  ) then
		local temp={}
		temp["jnsh"] = 5
		AttributesSet(self:GetParent(),temp)
	end
end



function modifiy_maplevel_11:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end

function modifiy_maplevel_11:GetModifierSpellAmplify_Percentage( params )
	return  5
end
function modifiy_maplevel_11:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end