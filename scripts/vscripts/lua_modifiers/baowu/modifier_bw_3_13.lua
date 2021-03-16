
modifier_bw_3_13 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_13:GetTexture()
	return "item_treasure/代达罗斯之殇"
end
--------------------------------------------------------------------------------
function modifier_bw_3_13:IsHidden()
	return true
end
function modifier_bw_3_13:OnCreated( kv )
	self.crit_chance = 20
	self.crit_multiplier =1350
	self.bIsCrit = false
	self:OnRefresh()
end


function modifier_bw_3_13:OnRefresh()
	
end


function modifier_bw_3_13:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_3_13:GetModifierPreAttack_BonusDamage( params )
	
	return 12000
end

function modifier_bw_3_13:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) 
				and hAttacker and ( hAttacker == self:GetParent() )
				and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if RollPseudoRandomPercentage( self.crit_chance, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, hAttacker ) == true then
				self.bIsCrit = true
				return self.crit_multiplier
			end
		end
	end

	return 0.0
end

--------------------------------------------------------------------------------

function modifier_bw_3_13:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and self.bIsCrit then

				local vDir = ( self:GetParent():GetAbsOrigin() - hTarget:GetAbsOrigin() ):Normalized()

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetAbsOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, vDir )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )

				EmitSoundOn( "Ability.CoupDeGrace", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0

end

function modifier_bw_3_13:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end