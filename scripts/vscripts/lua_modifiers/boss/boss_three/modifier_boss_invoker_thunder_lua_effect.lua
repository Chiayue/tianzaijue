
modifier_boss_invoker_thunder_lua_effect = class({})


function modifier_boss_invoker_thunder_lua_effect:DeclareFunctions()
    local funcs = {
       MODIFIER_EVENT_ON_ATTACK_LANDED,
    
    }
    return funcs
end

function modifier_boss_invoker_thunder_lua_effect:CheckState()
	local state =
	{
		[ MODIFIER_STATE_DISARMED ] = true,
		[ MODIFIER_STATE_FROZEN ] = true,
	}

	return state
end

function modifier_boss_invoker_thunder_lua_effect:OnAttackLanded(params)
    if IsServer() then
        if self:GetCaster()==params.attacker then
            
        end
    end

end
--------------------------------------------------------------------------------

function modifier_boss_invoker_thunder_lua_effect:IsDebuff()
	return false
end

function modifier_boss_invoker_thunder_lua_effect:GetTexture( params )
    return "modifier_boss_invoker_thunder_lua_effect"
end
function modifier_boss_invoker_thunder_lua_effect:IsHidden()
	return false
	-- body
end
function modifier_boss_invoker_thunder_lua_effect:OnCreated( kv )
 	

end

function modifier_boss_invoker_thunder_lua_effect:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
