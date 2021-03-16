




modifier_boss_invoker_end_lua_bloodfier = class({})

-----------------------------------------------------------------------------
function modifier_boss_invoker_end_lua_bloodfier:IsDebuff()
	return false
end


function modifier_boss_invoker_end_lua_bloodfier:GetTexture( params )
    return "modifier_boss_invoker_call_lua"
end
function modifier_boss_invoker_end_lua_bloodfier:OnCreated( kv )
	if IsServer() then
			

		
	end
end


-----------------------------------------------------------------------------

function modifier_boss_invoker_end_lua_bloodfier:OnDestroy()
	if IsServer() then
		
	end
end
function modifier_boss_invoker_end_lua_bloodfier:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
-----------------------------------------------------------------------------

