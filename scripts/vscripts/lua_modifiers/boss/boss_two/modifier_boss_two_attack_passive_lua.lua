
modifier_boss_two_attack_passive_lua = class({})


function modifier_boss_two_attack_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end


--------------------------------------------------------------------------------

function modifier_boss_two_attack_passive_lua:IsDebuff()
	return false
end

function modifier_boss_two_attack_passive_lua:GetTexture( params )
    return "modifier_boss_two_attack_passive_lua"
end
function modifier_boss_two_attack_passive_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_two_attack_passive_lua:OnCreated( kv )
	
	self.percent=self:GetAbility():GetSpecialValueFor("percent")
	self.damage=self:GetAbility():GetSpecialValueFor("damage")
	
end

function modifier_boss_two_attack_passive_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end



function modifier_boss_two_attack_passive_lua:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then
        local hTarget = params.target
        local hAttacker = params.attacker
        if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
            if RollPercentage(self.percent) then -- expose RollPseudoRandomPercentage?
               	EmitSoundOn( "Hero_PhantomAssassin.CoupDeGrace", hAttacker)
               	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
            	return self.damage
            end
        end
    end
    return 0.0
end
