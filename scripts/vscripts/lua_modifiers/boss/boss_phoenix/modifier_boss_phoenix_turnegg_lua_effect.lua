
modifier_boss_phoenix_turnegg_lua_effect = class({})


function modifier_boss_phoenix_turnegg_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
	}
	return funcs
end
function modifier_boss_phoenix_turnegg_lua_effect:GetModifierDamageOutgoing_Percentage( params )	--智力
	return self:GetStackCount()*30
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_turnegg_lua_effect:IsDebuff()
	return false
end

function modifier_boss_phoenix_turnegg_lua_effect:GetTexture( params )
    return "phoenix_supernova"
end
function modifier_boss_phoenix_turnegg_lua_effect:IsHidden()
	return false
	-- body
end
function modifier_boss_phoenix_turnegg_lua_effect:OnCreated( kv )
	
end

function modifier_boss_phoenix_turnegg_lua_effect:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
