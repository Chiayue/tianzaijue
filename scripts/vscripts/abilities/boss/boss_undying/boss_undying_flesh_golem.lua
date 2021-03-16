
boss_undying_flesh_golem = class({})

LinkLuaModifier( "modifier_boss_undying_flesh_golem_effect","lua_modifiers/boss/boss_undying/modifier_boss_undying_flesh_golem_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_undying_flesh_golem_effect_enemy","lua_modifiers/boss/boss_undying/modifier_boss_undying_flesh_golem_effect_enemy", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_undying_flesh_golem:OnSpellStart()
	
    local hCaster = self:GetCaster()
    hCaster:AddNewModifier(hCaster, self, "modifier_boss_undying_flesh_golem_effect", {duration=30})
    
end
--------------------------------------------------------------------------------

