
lower_attackspeed = class({})


function lower_attackspeed:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
	}
	return funcs
end
function lower_attackspeed:GetModifierAttackSpeedBonus_Constant( params )	--智力
	
	return -self:GetStackCount()
end

--------------------------------------------------------------------------------

function lower_attackspeed:IsDebuff()
	return true
end

function lower_attackspeed:GetTexture( params )
    return "lower_attackspeed"
end
function lower_attackspeed:IsHidden()
	return true
	-- body
end
function lower_attackspeed:OnCreated( kv )
 

end

function lower_attackspeed:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
