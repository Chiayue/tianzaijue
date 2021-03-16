
modifers_item_set_03 = class({})


--------------------------------------------------------------------------------

function modifers_item_set_03:IsDebuff()
	return false
end

function modifers_item_set_03:GetTexture( params )
    return "modifers_item_set_03"
end
function modifers_item_set_03:IsHidden()
	return true
	-- body
end
function modifers_item_set_03:OnCreated( kv )
 

end

function modifers_item_set_03:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifers_item_set_03:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifers_item_set_03:GetModifierAura()
    return "tz/潮汐水灵"
end

--------------------------------------------------------------------------------

function modifers_item_set_03:GetModifierAura()
    return "modifers_item_set_03_aura"
end

function modifers_item_set_03:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifers_item_set_03:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifers_item_set_03:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifers_item_set_03:GetAuraRadius()
    return 1500
end
