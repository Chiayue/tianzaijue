
modifier_boss_undying_flesh_golem_effect_enemy = class({})

LinkLuaModifier( "modifier_boss_undying_flesh_golem_effect_enemy_buff","lua_modifiers/boss/boss_undying/modifier_boss_undying_flesh_golem_effect_enemy_buff", LUA_MODIFIER_MOTION_NONE )


function modifier_boss_undying_flesh_golem_effect_enemy:IsDebuff()
	return false
end

function modifier_boss_undying_flesh_golem_effect_enemy:GetTexture( params )
    return "modifier_boss_undying_flesh_golem_effect_enemy"
end
function modifier_boss_undying_flesh_golem_effect_enemy:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_flesh_golem_effect_enemy:OnCreated( kv )
    if  IsServer() then
        
    end
	
end

function modifier_boss_undying_flesh_golem_effect_enemy:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end



function modifier_boss_undying_flesh_golem_effect_enemy:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect_enemy:GetModifierAura()
	return "modifier_boss_undying_flesh_golem_effect_enemy_buff"
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect_enemy:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect_enemy:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect_enemy:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect_enemy:GetAuraRadius()
	return 600
end


	