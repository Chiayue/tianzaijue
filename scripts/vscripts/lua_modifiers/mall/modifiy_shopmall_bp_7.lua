


modifiy_shopmall_bp_7 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_bp_7:GetTexture()
	return "rune/shopmall_bp_7"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_bp_7:IsHidden()
	return true
end
function modifiy_shopmall_bp_7:OnCreated( kv )
	if IsServer(  ) then
		
	end
end
function modifiy_shopmall_bp_7:OnRefresh()
	
end


function modifiy_shopmall_bp_7:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	
	}
	return funcs
end
function modifiy_shopmall_bp_7:GetModifierConstantManaRegen( params )
	return 2
end

function modifiy_shopmall_bp_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end