




modifier_boss_phoenix_stone_lua = class({})

-----------------------------------------------------------------------------

function modifier_boss_phoenix_stone_lua:OnCreated( kv )
	if IsServer() then
			
			ParticleMgr.CreateWarnRing(self:GetParent(),nil,300,1.3)
			
		--	local meteor_fly_original_point = (self:GetParent():GetOrigin() - (velocity_per_second * keys.LandTime)) + Vector (0, 0, 1000)  --Start the meteor in the air in a place where it'll be moving the same speed when flying and when rolling.
			local chaos_meteor_fly_particle_effect = ParticleManager:CreateParticle("particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_ABSORIGIN,self:GetCaster())
			ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 0, self:GetCaster():GetAbsOrigin()+ Vector (0, 0, 1000))
			ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 1, self:GetParent():GetOrigin())
			ParticleManager:SetParticleControl(chaos_meteor_fly_particle_effect, 2, Vector(1.3, 0, 0))
			
		
	end
end


-----------------------------------------------------------------------------

function modifier_boss_phoenix_stone_lua:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Warlock.Pick", self:GetCaster() )
			--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Ignite", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "stun_nothing", {duration=2} )
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*3,
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}

					ApplyDamage( damageInfo )
				end
			end
			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------------

