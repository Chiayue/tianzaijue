modifier_boss_pudge_rot_creatwenyi_damage = class({})

-----------------------------------------------------------------------------

function modifier_boss_pudge_rot_creatwenyi_damage:OnCreated( kv )
	
	
	if IsServer() then
        if self:GetParent():GetTeamNumber()== self:GetCaster():GetTeamNumber() then
            if self:GetParent()~=self:GetCaster() then
                self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_pudge_rot_creatwenyi_effect_lua", {} )
            end
        else
            local damageInfo = 
            {
                victim = self:GetParent(),
                attacker = self:GetCaster(),
                damage = 0.1*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
            }

            ApplyDamage( damageInfo )
        end
        
        
	end
end

