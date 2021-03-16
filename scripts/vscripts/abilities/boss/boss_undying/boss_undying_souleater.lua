--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
boss_undying_souleater = class({})
--LinkLuaModifier( "modifier_boss_undying_souleater_effect_debuff","lua_modifiers/boss/boss_undying/modifier_boss_undying_souleater_effect_debuff", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_boss_undying_souleater_effect","lua_modifiers/boss/boss_undying/modifier_boss_undying_souleater_effect", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_undying_souleater:OnAbilityPhaseStart()
    if IsServer() then
        
        local hCaster = self:GetCaster()
        local range=self:GetCastRange(hCaster:GetOrigin(),hCaster)
        EmitSoundOn("Hero_Undying.Mausoleum", hCaster)
        local nFXIndex = ParticleManager:CreateParticle("particles/boss/tsq_red/clicked_rings_red.vpcf", 2, hCaster)
        ParticleManager:SetParticleControl(
            nFXIndex,
            0,
            hCaster:GetOrigin()
        )
        ParticleManager:SetParticleControl(
            nFXIndex,
            1,
            Vector(range, 1, 1)
        )
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
    return true
end
function boss_undying_souleater:OnSpellStart()
	
    local hCaster = self:GetCaster()
    local point = self:GetCaster():GetOrigin()
    local hTarget=self:GetCursorTarget()
    EmitSoundOn("Hero_Undying.SoulRip.Cast", hCaster)
    
    local enemies = FindUnitsInRadius(
        hCaster:GetTeamNumber(),
        point,
        nil,
        1500,
        2,
        1,
        0,
        0,
        false
    )
    
   if hTarget:GetTeam()~=hCaster:GetTeam() then
        local damage = {victim = hTarget, attacker = hCaster, damage = #enemies*0.05*hCaster:GetBaseDamageMax(), damage_type = DAMAGE_TYPE_MAGICAL, ability = self}
        ApplyDamage(damage)
   else
        hTarget:Heal(#enemies*0.1*hCaster:GetBaseDamageMax(), self)
   end
    
end
--------------------------------------------------------------------------------

