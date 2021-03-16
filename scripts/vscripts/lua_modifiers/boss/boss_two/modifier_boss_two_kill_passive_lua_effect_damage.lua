
modifier_boss_two_kill_passive_lua_effect_damage = class({})


function modifier_boss_two_kill_passive_lua_effect_damage:DeclareFunctions()
    local funcs = {
       
        MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
        
    
    }
    return funcs
end
--------------------------------------------------------------------------------


function modifier_boss_two_kill_passive_lua_effect_damage:IsDebuff()
	return false
end
function modifier_boss_two_kill_passive_lua_effect_damage:GetModifierPreAttack_BonusDamage( params )
    return self:GetStackCount()
end


function modifier_boss_two_kill_passive_lua_effect_damage:GetTexture( params )
    return "modifier_boss_two_kill_passive_lua_effect_damage"
end
function modifier_boss_two_kill_passive_lua_effect_damage:IsHidden()
	return true
	-- body
end
function modifier_boss_two_kill_passive_lua_effect_damage:OnCreated( kv )
 	

end

function modifier_boss_two_kill_passive_lua_effect_damage:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
