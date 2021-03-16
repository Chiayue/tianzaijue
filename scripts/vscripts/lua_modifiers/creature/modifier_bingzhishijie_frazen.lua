modifier_bingzhishijie_frazen = class({})
--------------------------------------------------------------------------------

function modifier_bingzhishijie_frazen:IsDebuff()
	return true
end


function modifier_bingzhishijie_frazen:GetTexture( params )
    return "sword/stun_modifier"
end
function modifier_bingzhishijie_frazen:OnCreated( kv )
 
    if IsServer() then
        EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "hero_Crystal.frostbite", self:GetCaster() )
         self.partic = ParticleManager:CreateParticle( "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
    	 ParticleManager:SetParticleControl(self.partic,0,self:GetParent():GetOrigin())
         
         local damageInfo = 
        {
            victim = self:GetParent(),
            attacker = self:GetCaster(),
            damage = 3.2*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self:GetAbility(),
        }

        ApplyDamage( damageInfo )
    end
end

function modifier_bingzhishijie_frazen:OnDestroy()
	if IsServer() then
		if  self.partic~=nil then
			ParticleManager:DestroyParticle(self.partic, false)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_bingzhishijie_frazen:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bingzhishijie_frazen:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end

--------------------------------------------------------------------------------


function modifier_bingzhishijie_frazen:CheckState()
	local state = {
    [MODIFIER_STATE_FROZEN] = true,
    [MODIFIER_STATE_ROOTED] = true,
    
	}

	return state
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
