modifier_firefly_damage = class({})

-----------------------------------------------------------------------------

function modifier_firefly_damage:OnCreated( kv )
	
	
	if IsServer() then
        local damageInfo = 
        {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = 0.5*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
        }

        ApplyDamage( damageInfo )
	end
end

