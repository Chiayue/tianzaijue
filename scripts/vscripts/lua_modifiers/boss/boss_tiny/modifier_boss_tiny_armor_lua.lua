

modifier_boss_tiny_armor_lua = class({})

-----------------------------------------------------------------------------
function modifier_boss_tiny_armor_lua:DeclareFunctions()
    local funcs = {
       
        MODIFIER_EVENT_ON_TAKEDAMAGE,
    
    }
    return funcs
end
function modifier_boss_tiny_armor_lua:OnTakeDamage( params )
    if IsServer() then
    
        if params.unit == self:GetParent() and params.attacker:IsRealHero()  then
        	if RollPercentage(20) then
        		local hCaster=self:GetCaster()

        		
				if hCaster ~= nil and hCaster:IsAlive() then
					local point = hCaster:GetAbsOrigin()
					local point2 = hCaster:GetOrigin()
					local vDirection = point+RandomVector(2000) 
					local units= FindAlliesInRadiusExdd(hCaster,hCaster:GetAbsOrigin(),2000)
					local unit = nil
					local i = 0
					if units then
						for k,v in pairs(units) do		
							if i == 0 then	
								i = i +1
								unit = v
								local jd = GetForwardVector(hCaster:GetAbsOrigin(),unit:GetAbsOrigin())
								vDirection= hCaster:GetAbsOrigin()+jd *2000	
							end
						end
					end

					--self.twoplace= hCaster:GetOrigin()+RandomVector(2500)
					local nFXIndex = ParticleManager:CreateParticle( "particles/basic_boss/ab_line/range_finder_cone.vpcf", PATTACH_CUSTOMORIGIN, nil )
					ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", point, true )
					ParticleManager:SetParticleControl( nFXIndex, 1, point )
					ParticleManager:SetParticleControl( nFXIndex, 2, vDirection )
					ParticleManager:SetParticleControl( nFXIndex, 3, Vector(55,55,0) )
					ParticleManager:SetParticleControl( nFXIndex, 4, Vector(158,3,3) )
					--ParticleManager:ReleaseParticleIndex(nFXIndex)
					

					self.dragon_slave_speed =300-- self:GetSpecialValueFor( "dragon_slave_speed" )
					self.dragon_slave_width_initial = 55--self:GetSpecialValueFor( "dragon_slave_width_initial" )
					self.dragon_slave_width_end = 55--self:GetSpecialValueFor( "dragon_slave_width_end" )
					self.dragon_slave_distance = 2500
					

					EmitSoundOn( "Ability.TossThrow", self:GetCaster() )


					vDirection = vDirection - point2
					vDirection.z = 0.0
					vDirection = vDirection:Normalized()
					TimerUtil.createTimerWithDelay(0.5,
					function()
						ParticleManager:DestroyParticle(nFXIndex,true)

					end)
					self.dragon_slave_speed = self.dragon_slave_speed * ( self.dragon_slave_distance / ( self.dragon_slave_distance - self.dragon_slave_width_initial ) )
					local default_pat="particles/basic_boss/tiny_st/tiny_avalanche_projectile.vpcf"
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
            
           -- local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_skeletonking/wraith_king_vampiric_aura_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() )
           -- ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, nil, self:GetParent():GetOrigin(), true )
           -- ParticleManager:SetParticleControlEnt( nFXIndex, 1, params.attacker, PATTACH_ABSORIGIN_FOLLOW, nil, params.attacker:GetOrigin(), true )
           --ParticleManager:ReleaseParticleIndex( nFXIndex )
        end 
    end

    return 0
end

function modifier_boss_tiny_armor_lua:OnCreated( kv )
	if IsServer() then

					
	end
end
function modifier_boss_tiny_armor_lua:IsHidden()
	return true
	-- body
end

-----------------------------------------------------------------------------

function modifier_boss_tiny_armor_lua:OnDestroy()
	if IsServer() then
	
		
	end
end

-----------------------------------------------------------------------------

