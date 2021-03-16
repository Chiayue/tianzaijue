


modifiy_shopmall_bp_12 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_bp_12:GetTexture()
	return "rune/shopmall_bp_12"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_bp_12:IsHidden()
	return true
end
function modifiy_shopmall_bp_12:OnCreated( kv )
	if IsServer(  ) then
		
	end
end
function modifiy_shopmall_bp_12:OnRefresh()
	
end

function modifiy_shopmall_bp_12:DeclareFunctions()
	local funcs = 
	{
		
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifiy_shopmall_bp_12:GetModifierSpellAmplify_Percentage( params )
	return 5
end

function modifiy_shopmall_bp_12:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end