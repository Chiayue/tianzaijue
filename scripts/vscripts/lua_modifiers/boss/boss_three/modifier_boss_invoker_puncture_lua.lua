--土系

modifier_boss_invoker_puncture_lua = class({})

-----------------------------------------------------------------------------

function modifier_boss_invoker_puncture_lua:OnCreated( kv )
	if IsServer() then
		local hCaster=self:GetCaster()
		self.twoplace= hCaster:GetOrigin()+RandomVector(1800)
		if RollPercent(50) then		--50%的概率，技能会对着人放，可能会对单人不太友好,到时候根据玩家数量设置概率吧
			local units= FindAlliesInRadiusExdd(hCaster,hCaster:GetAbsOrigin(),1800)
			local unit = nil
			if units then
				for k,v in pairs(units) do			
					unit = v
					jd = GetForwardVector(hCaster:GetAbsOrigin(),unit:GetAbsOrigin())
					self.twoplace= hCaster:GetAbsOrigin()+jd *1800	
					self.nFXIndex = ParticleManager:CreateParticle( "particles/basic_boss/ab_line/range_finder_cone.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
					ParticleManager:SetParticleControl( self.nFXIndex, 1, hCaster:GetOrigin() )
					ParticleManager:SetParticleControl( self.nFXIndex, 2, self.twoplace )
					ParticleManager:SetParticleControl( self.nFXIndex, 4, Vector(158,3,3) )
					self.point = hCaster:GetAbsOrigin()
					return						 
				end
			end
		end
		self.nFXIndex = ParticleManager:CreateParticle( "particles/basic_boss/ab_line/range_finder_cone.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
		ParticleManager:SetParticleControl( self.nFXIndex, 1, hCaster:GetOrigin() )
		ParticleManager:SetParticleControl( self.nFXIndex, 2, self.twoplace )
		ParticleManager:SetParticleControl( self.nFXIndex, 4, Vector(158,3,3) )
		self.point = hCaster:GetAbsOrigin()
	end
end


-----------------------------------------------------------------------------

function modifier_boss_invoker_puncture_lua:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.nFXIndex ,true)
		local hCaster=self:GetCaster()
		if hCaster ~= nil and hCaster:IsAlive() then
			self.dragon_slave_speed =1800-- self:GetSpecialValueFor( "dragon_slave_speed" )
			self.dragon_slave_width_initial = 150--self:GetSpecialValueFor( "dragon_slave_width_initial" )
			self.dragon_slave_width_end = 150--self:GetSpecialValueFor( "dragon_slave_width_end" )
			self.dragon_slave_distance = 1800
			

			EmitSoundOn( "Hero_Lion.Impale", self:GetCaster() )

			local vDirection = self.twoplace - hCaster:GetOrigin()
			vDirection.z = 0.0
			vDirection = vDirection:Normalized()

			self.dragon_slave_speed = self.dragon_slave_speed * ( self.dragon_slave_distance / ( self.dragon_slave_distance - self.dragon_slave_width_initial ) )
			local default_pat="particles/units/heroes/hero_lion/lion_spell_impale.vpcf"
			local info = {
				EffectName = default_pat,
				Ability = self:GetAbility(),
				vSpawnOrigin = self.point, 
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
end

-----------------------------------------------------------------------------

