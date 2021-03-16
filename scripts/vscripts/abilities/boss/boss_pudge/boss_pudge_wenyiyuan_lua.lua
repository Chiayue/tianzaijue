boss_pudge_wenyiyuan_lua = class({})
LinkLuaModifier( "modifier_boss_pudge_wenyiyuan_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_wenyiyuan_lua", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------

function boss_pudge_wenyiyuan_lua:OnSpellStart()
        local hCaster = self:GetCaster()
        hCaster:AddNewModifier( hCaster, self, "modifier_boss_pudge_wenyiyuan_lua", {} )
        
end

--------------------------------------------------------------------------------