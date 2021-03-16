

modifier_boss_phoenix_fireline_lua = class({})

-----------------------------------------------------------------------------

function modifier_boss_phoenix_fireline_lua:OnCreated( kv )
	if IsServer() then

		local hCaster=self:GetCaster()
		self.twoplace= hCaster:GetOrigin()+RandomVector(2000)
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_jakiro/jakiro_macropyre.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
		ParticleManager:SetParticleControl( nFXIndex, 1,self.twoplace)
		ParticleManager:SetParticleControl( nFXIndex, 2,Vector(12,1,1))
		ParticleManager:ReleaseParticleIndex( nFXIndex )
		self:StartIntervalThink( 1)	
	end
end

function modifier_boss_phoenix_fireline_lua:OnIntervalThink()
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then
			self.dragon_slave_speed =1600-- self:GetSpecialValueFor( "dragon_slave_speed" )
			self.dragon_slave_width_initial = 300--self:GetSpecialValueFor( "dragon_slave_width_initial" )
			self.dragon_slave_width_end = 300--self:GetSpecialValueFor( "dragon_slave_width_end" )
			self.dragon_slave_distance = 2000
			
			EmitSoundOn( "hero_jakiro.projectileImpact", target )
			local vDirection = self.twoplace - hCaster:GetOrigin()
			vDirection.z = 0.0
			vDirection = vDirection:Normalized()
			
			

			self.dragon_slave_speed = self.dragon_slave_speed * ( self.dragon_slave_distance / ( self.dragon_slave_distance - self.dragon_slave_width_initial ) )
			local default_pat=""
			local info = {
				EffectName = default_pat,
				Ability = self:GetAbility(),
				vSpawnOrigin = hCaster:GetOrigin(), 
				fStartRadius = self.dragon_slave_width_initial,
				fEndRadius = self.dragon_slave_width_end,
				vVelocity = vDirection * self.dragon_slave_speed,
				fDistance = self.dragon_slave_distance,
				Source = hCaster,
				iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
				iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			}

		   ProjectileManager:CreateLinearProjectile( info )
		end
end
-----------------------------------------------------------------------------

function modifier_boss_phoenix_fireline_lua:OnDestroy()
	if IsServer() then
		
		
	end
end

-----------------------------------------------------------------------------

