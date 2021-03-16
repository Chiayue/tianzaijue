
modifier_boss_pudge_bot_bome_lua_effect = class({})



--------------------------------------------------------------------------------
function modifier_boss_pudge_bot_bome_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE 
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_bot_bome_lua_effect:GetModifierExtraHealthPercentage( params )
	return self:GetStackCount()* 50
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_bot_bome_lua_effect:GetModifierDamageOutgoing_Percentage( params )
	return self:GetStackCount() * 50
end
function modifier_boss_pudge_bot_bome_lua_effect:IsDebuff()
	return false
end

function modifier_boss_pudge_bot_bome_lua_effect:GetTexture( params )
    return "modifier_boss_pudge_bot_bome_lua_effect"
end
function modifier_boss_pudge_bot_bome_lua_effect:IsHidden()
	return false
	-- body
end
function modifier_boss_pudge_bot_bome_lua_effect:OnCreated( kv )
	
	if IsServer() then
		self:SetStackCount( 1 )
	end
end
function modifier_boss_pudge_bot_bome_lua_effect:OnRefresh( kv )
	
	if IsServer() then
		self:SetStackCount( self:GetStackCount()+1 )
	end
end
function modifier_boss_pudge_bot_bome_lua_effect:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	