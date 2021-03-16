
modifier_boss_shakeground_lua_slow = class({})

--------------------------------------------------------------------------------

function modifier_boss_shakeground_lua_slow:IsHidden()
    return false
end
function modifier_boss_shakeground_lua_slow:IsDebuff()
    return true
end
--------------------------------------------------------------------------------

function modifier_boss_shakeground_lua_slow:IsPurgable()
    return true
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function modifier_boss_shakeground_lua_slow:DeclareFunctions()
    local funcs =
    {
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
    }
    return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_shakeground_lua_slow:GetModifierMoveSpeedBonus_Percentage( params )
    return -self:GetStackCount()
end

--------------------------------------------------------------------------------
function modifier_boss_shakeground_lua_slow:OnCreated( kv )
    if IsServer() then
        local hCaster=self:GetParent()
        self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, hCaster)
        ParticleManager:SetParticleControl(self.nFXIndex, 0, hCaster:GetOrigin())

        
        
    end
end
function modifier_boss_shakeground_lua_slow:OnDestroy( kv )
    if IsServer() then
       ParticleManager:DestroyParticle(self.nFXIndex,false)
        

        
        
    end
end

