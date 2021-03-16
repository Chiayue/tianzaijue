modifier_leifa_slow_nothing = class({})
--------------------------------------------------------------------------------

function modifier_leifa_slow_nothing:IsDebuff()
	return true
end
function modifier_leifa_slow_nothing:IsHidden()
	return false
end

function modifier_leifa_slow_nothing:GetTexture( params )
    return "sword/stun_modifier"
end
function modifier_leifa_slow_nothing:OnCreated( kv )
    if IsServer() then
        
        self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
        
         local damageInfo = 
        {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = 0.8*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
        }

        ApplyDamage( damageInfo )
    end
    
end
function modifier_leifa_slow_nothing:OnRefresh( kv )
    if IsServer() then
        
        
        
         local damageInfo = 
        {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = 0.8*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
        }

        ApplyDamage( damageInfo )
    end
end
function modifier_leifa_slow_nothing:OnDestroy()
	if IsServer() then
		if  self.nFXIndex~=nil then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_leifa_slow_nothing:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_leifa_slow_nothing:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
function modifier_leifa_slow_nothing:GetModifierMoveSpeedBonus_Percentage( params )
	return -90
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
