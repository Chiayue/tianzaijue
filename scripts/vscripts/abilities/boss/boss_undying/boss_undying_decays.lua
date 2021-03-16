--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
boss_undying_decays = class({})
LinkLuaModifier( "modifier_boss_undying_decays_effect_debuff","lua_modifiers/boss/boss_undying/modifier_boss_undying_decays_effect_debuff", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_undying_decays_effect","lua_modifiers/boss/boss_undying/modifier_boss_undying_decays_effect", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_undying_decays:OnAbilityPhaseStart()
    if IsServer() then
        
        local hCaster = self:GetCaster()
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
            Vector(1500, 1, 1)
        )
        ParticleManager:ReleaseParticleIndex(nFXIndex)
    end
    return true
end
function boss_undying_decays:OnSpellStart()
	
    local hCaster = self:GetCaster()
    local point = self:GetCaster():GetOrigin()
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
    for ____, enemy in ipairs(enemies) do
        local strength=enemy:GetStrength()
        if enemy:IsRealHero() and enemy:GetStrength()>1 then
            local value=math.ceil(strength*0.3)
        --  then
        -- Is this unit a boss?
            --local damage = {victim = enemy, attacker = hCaster, damage = 100, damage_type = 1, ability = self}
            --ApplyDamage(damage)
           local buff= enemy:AddNewModifier( hCaster, self, "modifier_boss_undying_decays_effect_debuff", {duration=30} )
           buff:SetStackCount(buff:GetStackCount()+value)
           local buff= hCaster:AddNewModifier( hCaster, self, "modifier_boss_undying_decays_effect", {duration=30} )
           buff:SetStackCount(buff:GetStackCount()+value)
        end
    end
end
--------------------------------------------------------------------------------

