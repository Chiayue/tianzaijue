modifier_boss_phoenix_fire_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:GetModifierAura()
	return "modifier_boss_phoenix_fire_lua_effect"
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:GetAuraRadius()
	
	if IsServer() then
		if self:GetParent():HasModifier("modifier_boss_phoenix_turnegg_lua") then
			return 2000
		else
			return 900
		end
	end	
	return 900
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:OnCreated( kv )
	
end

--------------------------------------------------------------------------------

function modifier_boss_phoenix_fire_lua:OnRefresh( kv )
	
end

--------------------------------------------------------------------------------