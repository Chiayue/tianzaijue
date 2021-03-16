
add_movespeed = class({})


function add_movespeed:DeclareFunctions()
    local funcs = {
       
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    
    }
    return funcs
end
--------------------------------------------------------------------------------

function add_movespeed:IsDebuff()
	return false
end
function add_movespeed:GetModifierMoveSpeedBonus_Percentage( params )
    return self:GetStackCount()
end


function add_movespeed:GetTexture( params )
    return "add_movespeed"
end
function add_movespeed:IsHidden()
	return false
	-- body
end
function add_movespeed:OnCreated( kv )
 	

end

function add_movespeed:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
