modifier_boss_wood_bot_lunpan_end_lua_effect = class({})

--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_end_lua_effect:IsHidden()
	return true
end




--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_end_lua_effect:OnCreated( kv )
	
	if IsServer() then
		
		
	end
end


function modifier_boss_wood_bot_lunpan_end_lua_effect:CheckState()
	local state = {
	[MODIFIER_STATE_UNSELECTABLE] = true,
	[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	[MODIFIER_STATE_INVULNERABLE] = true,
	[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}

	return state
end

function modifier_boss_wood_bot_lunpan_end_lua_effect:OnDestroy( kv )
	
	
end
--------------------------------------------------------------------------------