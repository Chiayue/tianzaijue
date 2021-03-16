modifier_throw_attack_slow_debuff = class({})
--------------------------------------------------------------------------------

function modifier_throw_attack_slow_debuff:IsDebuff()
	return true
end
function modifier_throw_attack_slow_debuff:IsHidden()
	return false
end

function modifier_throw_attack_slow_debuff:GetTexture( params )
    return "sword/stun_modifier"
end
function modifier_throw_attack_slow_debuff:OnCreated( kv )
    if IsServer() then
        
        self.nFXIndex = ParticleManager:CreateParticle("particles/units/heroes/hero_monkey_king/monkey_king_strike_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.nFXIndex, 0, self:GetParent():GetOrigin())
    
    end
    
end
function modifier_throw_attack_slow_debuff:OnRefresh( kv )
    if IsServer() then
        
      
    end
end
function modifier_throw_attack_slow_debuff:OnDestroy()
	if IsServer() then
		if  self.nFXIndex~=nil then
			ParticleManager:DestroyParticle(self.nFXIndex, false)
		end
	end
end

--------------------------------------------------------------------------------

function modifier_throw_attack_slow_debuff:DeclareFunctions()
	local funcs = {
        
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_throw_attack_slow_debuff:GetOverrideAnimation( params )
	return ACT_DOTA_DISABLED
end
function modifier_throw_attack_slow_debuff:GetModifierMoveSpeedBonus_Percentage( params )
	return -60
end


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
