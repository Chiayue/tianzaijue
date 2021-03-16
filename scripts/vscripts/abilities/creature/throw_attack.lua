throw_attack = class({})
LinkLuaModifier( "modifier_throw_attack","lua_modifiers/creature/modifier_throw_attack", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_throw_attack_slow_debuff","lua_modifiers/creature/modifier_throw_attack_slow_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_throw_attack_deepdamge_debuff","lua_modifiers/creature/modifier_throw_attack_deepdamge_debuff", LUA_MODIFIER_MOTION_NONE )


--------------------------------------------------------------------------------
function throw_attack:Precache( context )
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning_se.vpcf", context )
    PrecacheResource( "particle", "particles/add_custom/boss_warning/aoe_warning.vpcf", context )
    

end
function throw_attack:GetIntrinsicModifierName()
	return "modifier_throw_attack"
end


function throw_attack:GetCastRange( vLocation, hTarget )
    if  IsServer() then
        
        return self:GetCaster():GetBaseAttackRange()	
    end
	return self.BaseClass.GetCastRange( self, vLocation, hTarget )
end
function throw_attack:OnProjectileHit( hTarget, vLocation )
    if hTarget ~= nil  then
        local hCaster=self:GetCaster()
        local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(), hTarget:GetOrigin(), hTarget, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        
        for _,enemy in pairs( enemies ) do
            enemy:AddNewModifier( self:GetCaster(), self, "modifier_throw_attack_slow_debuff", {duration=3} )
            enemy:AddNewModifier( self:GetCaster(), self, "modifier_throw_attack_deepdamge_debuff", {duration=20} )
        end
        hTarget:RemoveSelf()
    end

	return true
end