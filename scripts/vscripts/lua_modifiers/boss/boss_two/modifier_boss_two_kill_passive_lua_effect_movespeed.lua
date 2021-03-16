
modifier_boss_two_kill_passive_lua_effect_movespeed = class({})


function modifier_boss_two_kill_passive_lua_effect_movespeed:DeclareFunctions()
    local funcs = {
       
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    
    }
    return funcs
end
--------------------------------------------------------------------------------

function modifier_boss_two_kill_passive_lua_effect_movespeed:IsDebuff()
	return false
end
function modifier_boss_two_kill_passive_lua_effect_movespeed:GetModifierMoveSpeedBonus_Percentage( params )
    return self.move_speed*self:GetStackCount()
end


function modifier_boss_two_kill_passive_lua_effect_movespeed:GetTexture( params )
    return "modifier_boss_two_kill_passive_lua_effect_movespeed"
end
function modifier_boss_two_kill_passive_lua_effect_movespeed:IsHidden()
	return true
	-- body
end
function modifier_boss_two_kill_passive_lua_effect_movespeed:OnCreated( kv )
 	self.move_speed=self:GetAbility():GetSpecialValueFor("move_speed")

end

function modifier_boss_two_kill_passive_lua_effect_movespeed:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
