modifier_boss_one_bloodfire_lua_nodead_buff = class({})


function modifier_boss_one_bloodfire_lua_nodead_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifier_boss_one_bloodfire_lua_nodead_buff:GetModifierHealthRegenPercentage( params )	--智力
	return 2
end

--------------------------------------------------------------------------------

function modifier_boss_one_bloodfire_lua_nodead_buff:IsDebuff()
	return false
end

function modifier_boss_one_bloodfire_lua_nodead_buff:GetTexture( params )
    return "modifier_boss_one_bloodfire_lua_nodead_buff"
end
function modifier_boss_one_bloodfire_lua_nodead_buff:IsHidden()
	return false
	-- body
end
function modifier_boss_one_bloodfire_lua_nodead_buff:OnCreated( kv )
	if IsServer() then
		
	end
end

function modifier_boss_one_bloodfire_lua_nodead_buff:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
