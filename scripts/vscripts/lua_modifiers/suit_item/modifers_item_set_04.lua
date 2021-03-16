
modifers_item_set_04 = class({})


function modifers_item_set_04:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end
function modifers_item_set_04:GetModifierHealthBonus( params )	--智力
	
	return 1200
end
function modifers_item_set_04:GetModifierBonusStats_Agility( params )	--智力
	
	return 50
end
function modifers_item_set_04:GetModifierBonusStats_Strength( params )	--智力
	
	return 50
end
function modifers_item_set_04:GetModifierBonusStats_Intellect( params )	--智力
	
	return 200
end
function modifers_item_set_04:GetModifierSpellAmplify_Percentage( params )	--智力
	
	return 20
end
--------------------------------------------------------------------------------

function modifers_item_set_04:IsDebuff()
	return false
end

function modifers_item_set_04:GetTexture( params )
    return "tz/冰霜亡灵"
end
function modifers_item_set_04:IsHidden()
	return false
	-- body
end
function modifers_item_set_04:OnCreated( kv )
 

end

function modifers_item_set_04:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifers_item_set_04:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifers_item_set_04:GetModifierAura()
    return "modifers_item_set_04_aura_debuff"
end

--------------------------------------------------------------------------------

function modifers_item_set_04:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifers_item_set_04:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifers_item_set_04:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifers_item_set_04:GetAuraRadius()
    return 800
end
