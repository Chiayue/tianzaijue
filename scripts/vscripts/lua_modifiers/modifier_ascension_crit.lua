
modifier_ascension_crit = class({})

-----------------------------------------------------------------------------------------

function modifier_ascension_crit:IsPurgable()
	return false
end

----------------------------------------

function modifier_ascension_crit:OnCreated( kv )
	self:OnRefresh( kv )
end

----------------------------------------

function modifier_ascension_crit:OnRefresh( kv )
	if self:GetAbility() == nil then
		return
	end

	self.crit_chance = self:GetAbility():GetSpecialValueFor( "crit_chance" )
	self.crit_multiplier = self:GetAbility():GetSpecialValueFor( "crit_multiplier" )

	self.attack_damage_plus = self:GetAbility():GetSpecialValueFor( "attack_damage_plus" )
	self.gjdtsxsh = self:GetAbility():GetSpecialValueFor( "gjdtsxsh" )
	self.gjqtsxsh = self:GetAbility():GetSpecialValueFor( "gjqtsxsh" )
	self.gjxx = self:GetAbility():GetSpecialValueFor( "gjxx" )
	self.fsxx = self:GetAbility():GetSpecialValueFor( "fsxx" )
	self.fjsh = self:GetAbility():GetSpecialValueFor( "fjsh" )

	self.bgjyglhx = self:GetAbility():GetSpecialValueFor( "bgjyglhx" )
	self.bgjyglhl = self:GetAbility():GetSpecialValueFor( "bgjyglhl" )
	self.gjjshj = self:GetAbility():GetSpecialValueFor( "gjjshj" )
	self.gjhfxl = self:GetAbility():GetSpecialValueFor( "gjhfxl" )



	self.bIsCrit = false
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ATTACKED,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:OnTooltip( params )
	return self.crit_chance
end


--------------------------------------------------------------------------------

function modifier_ascension_crit:OnTooltip2( params )
	return self.crit_multiplier
end

--------------------------------------------------------------------------------

function modifier_ascension_crit:GetModifierPreAttack_CriticalStrike( params )
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
function modifier_ascension_crit:OnTakeDamage( params )
	if IsServer() then
		local Attacker = params.attacker
		local Target = params.unit
		local Ability = params.inflictor
		local flDamage = params.damage

		if Attacker ~= self:GetParent() or Ability == nil or Target == nil then
			return 0
		end

		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION ) == DOTA_DAMAGE_FLAG_REFLECTION then
			return 0
		end
		if bit.band( params.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL ) == DOTA_DAMAGE_FLAG_NO_SPELL_LIFESTEAL then
			return 0
		end

		local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/octarine_core_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, Attacker )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		local flLifesteal = flDamage * self.fsxx / 100
		if flLifesteal > 500000000 then
				flLifesteal = 500000000
		end
		Attacker:Heal( flLifesteal, self:GetAbility() )
	end
	return 0
end

function modifier_ascension_crit:OnAttacked( params )
	if IsServer() then
		if params.target == self:GetParent() and params.attacker ~= nil then
			if RollPercentage( 20)  then
				if self.bgjyglhx~=0 then
					self:GetParent():Heal( self.bgjyglhx, self:GetAbility() )
				end
				if self.bgjyglhl~=0 then
					local nFXIndex = ParticleManager:CreateParticle( "particles/items3_fx/mango_active.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
					ParticleManager:ReleaseParticleIndex( nFXIndex )
					self:GetParent():GiveMana( self.bgjyglhl )
				end
				
			end
		end
	end

	return 1
end
--------------------------------------------------------------------------------

function modifier_ascension_crit:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget:IsAlive() then
				if self.attack_damage_plus~=0 or self.fjsh or self.gjdtsxsh ~=0 then
					
					local damageInfo = 
					{
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = self.attack_damage_plus+ self.fjsh+self:GetCaster():GetBonusDamageFromPrimaryStat()*self.gjdtsxsh/100,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damageInfo )
				end
			end
			if self.gjxx~=0 then
				local flLifesteal = params.original_damage * self.gjxx / 100
				if flLifesteal > 100000000 then
					flLifesteal = 100000000
				end
				self:GetParent():Heal( flLifesteal, self:GetAbility() )
			end
			if self.gjjshj~=0 then
				hTarget:AddNewModifier( unit, self:GetAbility(), "modifier_ascension_crit_buff", {duration=5} )
			end
			if self.gjhfxl~=0 then
				self:GetParent():Heal( self.gjhfxl, self:GetAbility() )
			end
			if self.gjqtsxsh~=0 then
				local enemies = FindUnitsInRadius( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), nil, 200, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC , DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false )
					for _,enemy in pairs( enemies ) do
						if enemy ~= nil and enemy:IsInvulnerable() == false then

							local damageInfo = 
							{
								victim = enemy,
								attacker = self:GetCaster(),
								damage = self:GetCaster():GetBonusDamageFromPrimaryStat()*self.gjqtsxsh/100,
								damage_type = DAMAGE_TYPE_PHYSICAL,
								ability = self:GetAbility(),
							}
							ApplyDamage( damageInfo )
						end
					end
			end
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