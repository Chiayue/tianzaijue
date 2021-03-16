
modifier_boss_undying_flesh_golem_effect = class({})

LinkLuaModifier( "modifier_boss_undying_flesh_golem_effect_buff","lua_modifiers/boss/boss_undying/modifier_boss_undying_flesh_golem_effect_buff", LUA_MODIFIER_MOTION_NONE )
function modifier_boss_undying_flesh_golem_effect:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE,MODIFIER_PROPERTY_MODEL_CHANGE,
	}
	return funcs
end
function modifier_boss_undying_flesh_golem_effect:GetModifierModelChange( params )	
	return "models/items/undying/flesh_golem/ti8_undying_miner_flesh_golem/ti8_undying_miner_flesh_golem.vmdl"
end
function modifier_boss_undying_flesh_golem_effect:GetModifierExtraHealthPercentage( params )	--
    if IsServer() then
       if  self:GetParent():HasModifier("modifier_boss_undying_tombstone_zombie_night") then
        return 100
       end
    end
    return 50
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect:IsDebuff()
	return false
end

function modifier_boss_undying_flesh_golem_effect:GetTexture( params )
    return "modifier_boss_undying_flesh_golem_effect"
end
function modifier_boss_undying_flesh_golem_effect:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_flesh_golem_effect:OnCreated( kv )
    if  IsServer() then
        self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_boss_undying_flesh_golem_effect_enemy", {})
    end
	
end
function modifier_boss_undying_flesh_golem_effect:OnDestroy( kv )
    if  IsServer() then
        self:GetParent():RemoveModifierByName( "modifier_boss_undying_flesh_golem_effect_enemy" )
        -- Removes a modifier.
    end
	
end

function modifier_boss_undying_flesh_golem_effect:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end



function modifier_boss_undying_flesh_golem_effect:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect:GetModifierAura()
	return "modifier_boss_undying_flesh_golem_effect_buff"
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS
end

--------------------------------------------------------------------------------

function modifier_boss_undying_flesh_golem_effect:GetAuraRadius()
	return 600
end


	