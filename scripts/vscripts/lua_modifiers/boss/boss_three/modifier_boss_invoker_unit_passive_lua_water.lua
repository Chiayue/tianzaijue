
modifier_boss_invoker_unit_passive_lua_water = class({})


function modifier_boss_invoker_unit_passive_lua_water:DeclareFunctions()
    local funcs = {
       
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_boss_invoker_unit_passive_lua_water:IsDebuff()
	return false
end
function modifier_boss_invoker_unit_passive_lua_water:GetModifierMoveSpeedBonus_Percentage( params )
    return -20
end


function modifier_boss_invoker_unit_passive_lua_water:GetTexture( params )
    return "modifier_boss_invoker_unit_passive_lua_water"
end
function modifier_boss_invoker_unit_passive_lua_water:IsHidden()
	return false
	-- body
end
function modifier_boss_invoker_unit_passive_lua_water:OnCreated( kv )
 	

end

function modifier_boss_invoker_unit_passive_lua_water:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
