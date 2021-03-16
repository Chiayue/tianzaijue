modifier_boss_wood_passive_lua = class({})


function modifier_boss_wood_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
	return funcs
end
function modifier_boss_wood_passive_lua:GetModifierHealthRegenPercentage( params )	--智力
	return 0.1
end

--------------------------------------------------------------------------------

function modifier_boss_wood_passive_lua:IsDebuff()
	return false
end

function modifier_boss_wood_passive_lua:GetTexture( params )
    return "modifier_boss_wood_passive_lua"
end
function modifier_boss_wood_passive_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_wood_passive_lua:OnCreated( kv )
	

end

function modifier_boss_wood_passive_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
