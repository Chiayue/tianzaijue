


modifiy_maplevel_3 = class({})

--------------------------------------------------------------------------------

function modifiy_maplevel_3:GetTexture()
	return "item_treasure/幽冥披巾"
end
--------------------------------------------------------------------------------
function modifiy_maplevel_3:IsHidden()
	return true
end
function modifiy_maplevel_3:OnCreated( kv )
	if IsServer(  ) then
		
	end
end



function modifiy_maplevel_3:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end

function modifiy_maplevel_3:GetModifierAttackSpeedBonus_Constant( params )
	return  10
end
function modifiy_maplevel_3:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end