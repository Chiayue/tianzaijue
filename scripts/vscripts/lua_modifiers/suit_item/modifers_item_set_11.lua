
modifers_item_set_11 = class({})


function modifers_item_set_11:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function modifers_item_set_11:GetModifierHealthBonus( params )	--智力
	
	return 8000
end
function modifers_item_set_11:GetModifierBonusStats_Intellect( params )	--智力
	
	return 2000
end
function modifers_item_set_11:GetModifierPhysicalArmorBonus( params )	--智力
	
	return 10
end


--------------------------------------------------------------------------------

function modifers_item_set_11:IsDebuff()
	return false
end

function modifers_item_set_11:GetTexture( params )
   return "tz/幽魂"
end
function modifers_item_set_11:IsHidden()
	return false
	-- body
end
function modifers_item_set_11:OnCreated( kv )
	if IsServer() then
 	end
end

function modifers_item_set_11:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end

function modifers_item_set_11:IsAura()
    return true
end

--------------------------------------------------------------------------------

function modifers_item_set_11:GetModifierAura()
    return "modifers_item_set_11_aura_debuff"
end

--------------------------------------------------------------------------------

function modifers_item_set_11:GetAuraSearchTeam()
    return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifers_item_set_11:GetAuraSearchType()
    return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end

--------------------------------------------------------------------------------

function modifers_item_set_11:GetAuraSearchFlags()
    return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

--------------------------------------------------------------------------------

function modifers_item_set_11:GetAuraRadius()
    return 1200
end