
modifier_firefly_autocast = class({})

-----------------------------------------------------------------------------
function modifier_firefly_autocast:IsHidden()
    return true
end
function modifier_firefly_autocast:OnCreated( kv )
    self.flDuration = self:GetAbility():GetSpecialValueFor( "duration" )
    self.enemy_radius=1500
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

function modifier_firefly_autocast:OnIntervalThink()
    if IsServer() then
        local hCaster=self:GetCaster()
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive()  then
            local enemies = FindUnitsInRadius( hCaster:GetTeamNumber(),hCaster:GetOrigin(), hCaster, self.enemy_radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
            for i=1,math.min(RandomInt(3, 5),#enemies) do
                if enemies[i] then
                    if enemies[i] ~= nil and enemies[i]:IsInvulnerable() == false and self:GetCaster()~=enemies[i] then
                        if not enemies[i]:HasModifier("modifier_firefly") then
                            enemies[i]:AddNewModifier( hCaster, self:GetAbility(), "modifier_firefly", { duration = self.flDuration } )
                        end
                    end
                end
            end
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
            
	end
end

-----------------------------------------------------------------------------

