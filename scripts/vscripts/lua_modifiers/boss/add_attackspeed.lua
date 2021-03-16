
add_attackspeed = class({})


function add_attackspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function add_attackspeed:GetModifierAttackSpeedBonus_Constant( params )	--智力
	
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function add_attackspeed:IsDebuff()
	return false
end

function add_attackspeed:GetTexture( params )
    return "add_attackspeed"
end
function add_attackspeed:IsHidden()
	return true
	-- body
end
function add_attackspeed:OnCreated( kv )
 

end

function add_attackspeed:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
