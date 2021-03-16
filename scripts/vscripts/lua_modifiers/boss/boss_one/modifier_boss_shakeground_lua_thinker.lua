




modifier_boss_shakeground_lua_thinker = class({})

-----------------------------------------------------------------------------

function modifier_boss_shakeground_lua_thinker:OnCreated( kv )
	if IsServer() then
		local difficulty = GameRules:GetCustomGameDifficulty() 
		self.radius = self:GetAbility():GetSpecialValueFor("radius")+ difficulty * 33
		self.damage =  self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self:GetAbility():GetSpecialValueFor("i")
		self:StartIntervalThink( 1 )
	end
end

-----------------------------------------------------------------------------

function modifier_boss_shakeground_lua_thinker:OnIntervalThink()
	if IsServer() then
		if self:GetCaster():IsAlive()  then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Leshrac.Split_Earth", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf", PATTACH_WORLDORIGIN,  self:GetCaster()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetAbsOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( self.radius,1,1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetCaster():GetAbsOrigin(), self:GetParent(), self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self.damage,
						damage_type = self:GetAbility():GetAbilityDamageType(),
						ability = self,
					}

					ApplyDamage( damageInfo )
				end
			end
			

			ScreenShake( self:GetParent():GetOrigin(), 10.0, 100.0, 0.5, 1300.0, 0, true )
		else
			--print( string.format( "Caster is nil, dead, or stunned, removing smash thinker" ) )
			UTIL_Remove( self:GetParent() )
			return -1
		end
	end
end

-----------------------------------------------------------------------------

function modifier_boss_shakeground_lua_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------------

