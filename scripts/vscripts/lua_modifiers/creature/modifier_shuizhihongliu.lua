
modifier_shuizhihongliu = class({})

-----------------------------------------------------------------------------
function modifier_shuizhihongliu:IsHidden()
    return true
end
function modifier_shuizhihongliu:OnCreated( kv )
    self.delay_time=self:GetAbility():GetSpecialValueFor("delay_time")
    self.enemy_radius=self:GetAbility():GetSpecialValueFor("enemy_radius")
    
    if IsServer() then
        if self:GetAbility():GetLevel()==0 then
            self:GetParent():RemoveModifierByName(self:GetName())
            return 
        end
        self:OnIntervalThink()
        self:StartIntervalThink(1)
	end
end


-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_shuizhihongliu:OnIntervalThink()
    
    if IsServer() then
        local hCaster=self:GetCaster()
        if self:GetAbility():IsCooldownReady()and hCaster:IsAlive()  then
            
            local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(),hCaster:GetOrigin(), hCaster, self.enemy_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
           local num = 0
            for _,enemy in pairs( enemies ) do
                if enemy ~= nil and enemy:IsInvulnerable() == false then
                    num = num + 1
                    local hThinker = CreateModifierThinker( hCaster, self:GetAbility(), "modifier_shuizhihongliu_thinker", { duration = self.delay_time }, enemy:GetOrigin(), hCaster:GetTeamNumber(), false )
                    if num > 15 then
                        break
                    end
                end
            end
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
            
	end
end

-----------------------------------------------------------------------------

