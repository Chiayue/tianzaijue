modifier_boss_wood_charge_lua = class({})
--------------------------------------------------------------------------------

function modifier_boss_wood_charge_lua:IsDebuff()
    return false
end
function modifier_boss_wood_charge_lua:IsHidden()
    return false
end
function modifier_boss_wood_charge_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_DISABLE_TURNING,
    }
    return funcs
end

function modifier_boss_wood_charge_lua:CheckState()
    local state = {
    [MODIFIER_STATE_UNSELECTABLE] = true,
    [MODIFIER_STATE_BLIND] = true,
    
    }

    return state
end

function modifier_boss_wood_charge_lua:GetModifierDisableTurning(params)
    if IsServer() then
        return true
    end
end

function modifier_boss_wood_charge_lua:OnCreated( kv )
    if IsServer() then
        --self:StartIntervalThink(0.02)
        if self:ApplyHorizontalMotionController() == false then
            
            self:Destroy()
            return
        end

        self.vStartPosition    = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
        
        self.vTargetPosition   = self:GetAbility().targetPoint
        
        self.flDuration        = kv.duration
        self.bLanded=false
        self.vDirection        = (self.vTargetPosition - self.vStartPosition):Normalized()
        self.flDistance        = (self.vTargetPosition - self.vStartPosition):Length2D()

        self.flHorizontalSpeed = self.flDistance/self.flDuration
        self.vZ=0
        self:GetAbility().position=self.vStartPosition
    end
    
end


--------------------------------------------------------------------------------
function modifier_boss_wood_charge_lua:OnDestroy()
    if IsServer() then
        
        

        GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 300, false )

        self:GetParent():RemoveHorizontalMotionController(self)
        self:GetParent():RemoveVerticalMotionController(self)
       
    end
end
function modifier_boss_wood_charge_lua:IsPurgable()
    return false
end

function modifier_boss_wood_charge_lua:RemoveOnDeath()
    return true
end


function modifier_boss_wood_charge_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION_RATE,
    }
    return funcs
end
function modifier_boss_wood_charge_lua:GetOverrideAnimation()
    return ACT_DOTA_RUN
end
function modifier_boss_wood_charge_lua:GetOverrideAnimationRate()
    return 2
end

function modifier_boss_wood_charge_lua:UpdateHorizontalMotion(me, dt)
    if IsServer() then
         local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 350,
                        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        
        for _,enemy in pairs(enemies) do
            local vLocation=self:GetParent():GetAbsOrigin()
            local kv_knockback =
            {
                center_x = vLocation.x,
                center_y = vLocation.y,
                center_z = vLocation.z,
                should_stun = true, 
                duration = 0.3,
                knockback_duration = 0.3,
                knockback_distance = 300,
                knockback_height = 100,
            }
            
            enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_knockback", kv_knockback )
            enemy:AddNewModifier( self:GetParent(), self:GetAbility(), "modifier_boss_wood_charge_lua_effect", {duration=1} )
        end

        local vOldPosition = me:GetOrigin()
        local vNewPos      = vOldPosition + self.vDirection * self.flHorizontalSpeed * dt
 
        vNewPos.z  = 0
        if (self:GetCaster():GetOrigin()-self.vTargetPosition):Length2D()<=100 then
           vNewPos= vOldPosition
           if GridNav:CanFindPath(me:GetAbsOrigin(), vNewPos)  then
               FindClearSpaceForUnit( self:GetParent(), vNewPos, true )
            end
        else
          --  if GridNav:CanFindPath(me:GetAbsOrigin(), vNewPos)  then
                 --me:SetOrigin(vNewPos)
                 FindClearSpaceForUnit( me, vNewPos, true )

          --  end
        end
        
        local location=GetGroundPosition( vNewPos, self:GetParent() )
        local tt=true
        if not GridNav:CanFindPath(self:GetAbility().position,location+Vector(0,1,0)*30) then
            tt=false
        end
        if not GridNav:CanFindPath(self:GetAbility().position,location+Vector(0,-1,0)*30) then
            tt=false
        end
        if not GridNav:CanFindPath(self:GetAbility().position,location+Vector(1,0,0)*30) then
            tt=false
        end
        if not GridNav:CanFindPath(self:GetAbility().position,location+Vector(-1,0,0)*30) then
            tt=false
        end
        if tt then
            self:GetAbility().position=location
        end
       
        

    end
end

function modifier_boss_wood_charge_lua:OnHorizontalMotionInterrupted()
    if IsServer() then
        self:Destroy()
    end
end