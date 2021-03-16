--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
boss_undying_tombstone = class({})
--LinkLuaModifier( "modifier_boss_undying_tombstone_effect_debuff","lua_modifiers/boss/boss_undying/modifier_boss_undying_tombstone_effect_debuff", LUA_MODIFIER_MOTION_NONE )
--LinkLuaModifier( "modifier_boss_undying_tombstone_effect","lua_modifiers/boss/boss_undying/modifier_boss_undying_tombstone_effect", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_undying_tombstone:OnAbilityPhaseStart()
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
function boss_undying_tombstone:OnSpellStart()
	
    local hCaster = self:GetCaster()
    local range=self:GetCastRange(hCaster:GetOrigin(),hCaster)
    local hTarget=self:GetCursorTarget()
    EmitSoundOn("Hero_Undying.SoulRip.Cast", hCaster)
    
    -- Creates a DOTA unit by its dota_npc_units.txt name

    local enemies = FindUnitsInRadius(
        hCaster:GetTeamNumber(),
        hCaster:GetOrigin(),
        nil,
        range,
        2,
        1,
        0,
        0,
        false
    )
    for i=0,#enemies do
        local point = self:GetCaster():GetOrigin()+Vector(RandomInt(-2000,2000),RandomInt(-2000,2000))
        local tempunit=CreateUnitByName("npc_boss_undying_tombstone", point, true, hCaster, hCaster, hCaster:GetTeam() )
        
        -- Sets this entity's owner
        FindClearSpaceForUnit(sxxx,point,true)
        tempunit:AddNewModifier(hCaster, self, "modifier_kill", {duration=30})
        tempunit:SetMaxHealth(hCaster:GetMaxHealth()*0.2)
        tempunit:SetPhysicalArmorBaseValue(hCaster:GetPhysicalArmorValue(false ))
        
        tempunit:SetBaseMagicalResistanceValue(hCaster:GetMagicalArmorValue()*100)
        -- Returns current physical armor value.)
        tempunit:SetMaxHealth(hCaster:GetMaxHealth()*0.2)
        tempunit:SetHealth(hCaster:GetMaxHealth()*0.2)
    end
   
    
end
--------------------------------------------------------------------------------

