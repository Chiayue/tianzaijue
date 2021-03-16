
lower_movespeed = class({})


function lower_movespeed:DeclareFunctions()
    local funcs = {
       
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    
    }
    return funcs
end
--------------------------------------------------------------------------------

function lower_movespeed:IsDebuff()
	return true
end
function lower_movespeed:GetModifierMoveSpeedBonus_Percentage( params )
    return -self:GetStackCount()
end


function lower_movespeed:GetTexture( params )
    return "lower_movespeed"
end
function lower_movespeed:IsHidden()
	return false
	-- body
end
function lower_movespeed:OnCreated( kv )
 	

end

function lower_movespeed:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
