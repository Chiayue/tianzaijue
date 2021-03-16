
modifier_ascension_magic_immunity_autocast = class({})

-----------------------------------------------------------------------------

function modifier_ascension_magic_immunity_autocast:OnCreated( kv )
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
function modifier_ascension_magic_immunity_autocast:IsHidden()
    return true
end
	

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_ascension_magic_immunity_autocast:OnIntervalThink()
    if IsServer() then
        local hCaster=self:GetCaster()
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive() then
            hCaster:AddNewModifier( hCaster, self:GetAbility(), "modifier_ascension_magic_immunity", { duration = self.flDuration } )
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
            
	end
end

-----------------------------------------------------------------------------

