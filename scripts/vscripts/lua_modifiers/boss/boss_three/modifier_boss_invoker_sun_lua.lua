--火


modifier_boss_invoker_sun_lua = class({})

-----------------------------------------------------------------------------

function modifier_boss_invoker_sun_lua:OnCreated( kv )
	if IsServer() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Charge.Apex", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_team_immortal1.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150,1,1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
		
	end
end


-----------------------------------------------------------------------------

function modifier_boss_invoker_sun_lua:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Ignite", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/invoker/invoker_apex/invoker_sun_strike_immortal1.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector( 150,1,1 ) )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*2.4,
						damage_type = DAMAGE_TYPE_PURE,
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

