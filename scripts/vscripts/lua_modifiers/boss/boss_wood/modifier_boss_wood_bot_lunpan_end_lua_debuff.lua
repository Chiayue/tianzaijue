modifier_boss_wood_bot_lunpan_end_lua_debuff = class({})
--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_end_lua_debuff:IsDebuff()
    return true
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_TURNING,
    }
    return funcs
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:CheckState()
    local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_BLIND] = true,
    
    }

    return state
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:IsHidden()
    return true
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:GetModifierDisableTurning(params)
    if IsServer() then
        return true
    end
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:OnCreated( kv )
    if IsServer() then
        --self:StartIntervalThink(0.02)
        

        if self:ApplyHorizontalMotionController() == false then
            self:Destroy()
            return
        end

        
        self.flDuration        = kv.duration
        self.bLanded=false
        self.vDirection        =(self:GetCaster():GetOrigin()-self:GetParent():GetOrigin()):Normalized()
        self.flHorizontalSpeed = 40
        self.vZ=0
        self:GetAbility().position=self.vStartPosition
    end
    
end


--------------------------------------------------------------------------------
function modifier_boss_wood_bot_lunpan_end_lua_debuff:OnDestroy()
    if IsServer() then
        
        

        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
       
    end
end
function modifier_boss_wood_bot_lunpan_end_lua_debuff:IsPurgable()
    return false
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:RemoveOnDeath()
    return true
end


function modifier_boss_wood_bot_lunpan_end_lua_debuff:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
    }
    return funcs
end
function modifier_boss_wood_bot_lunpan_end_lua_debuff:GetOverrideAnimation()
    return ACT_DOTA_RUN
end
function modifier_boss_wood_bot_lunpan_end_lua_debuff:GetOverrideAnimationRate()
    return 2
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:UpdateHorizontalMotion(me, dt)
    if IsServer() then
        local vOldPosition = me:GetOrigin()
        self.vDirection=(self:GetCaster():GetOrigin()-self:GetParent():GetOrigin()):Normalized()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
        if (self:GetCaster():GetOrigin()-self:GetParent():GetOrigin()):Length2D()<=200 then
           vNewPos= vOldPosition
        end
        vNewPos.z  = 0
        
        me:SetOrigin(vNewPos)
    end
end

function modifier_boss_wood_bot_lunpan_end_lua_debuff:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end