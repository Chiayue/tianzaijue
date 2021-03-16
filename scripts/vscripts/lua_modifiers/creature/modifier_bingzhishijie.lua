
modifier_bingzhishijie = class({})

-----------------------------------------------------------------------------
function modifier_bingzhishijie:IsHidden()
    return true
end
function modifier_bingzhishijie:OnCreated( kv )
    self.delay_time=self:GetAbility():GetSpecialValueFor("delay_time")
    
    if IsServer() then
        if self:GetAbility():GetLevel()==0 then
            self:GetParent():RemoveModifierByName(self:GetName())
            return 
        end
        self:StartIntervalThink(1)
        self:OnIntervalThink()
	end
end


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_bingzhishijie:OnIntervalThink()
    if IsServer() then
        local hCaster=self:GetCaster()
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive() then
          
            local hThinker = CreateModifierThinker( hCaster, self:GetAbility(), "modifier_bingzhishijie_thinker", { duration = self.delay_time }, hCaster:GetOrigin(), hCaster:GetTeamNumber(), false )
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
            
	end
end

-----------------------------------------------------------------------------

