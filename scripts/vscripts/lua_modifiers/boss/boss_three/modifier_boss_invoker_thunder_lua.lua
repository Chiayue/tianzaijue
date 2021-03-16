

modifier_boss_invoker_thunder_lua = class({})

-----------------------------------------------------------------------------

function modifier_boss_invoker_thunder_lua:OnCreated( kv )
	if IsServer() then
		EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Zuus.Righteous.Layer", self:GetCaster() )
		
		ParticleMgr.CreateWarnRing(self:GetParent(),nil,150,1.5)
		
	end
end


-----------------------------------------------------------------------------

function modifier_boss_invoker_thunder_lua:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Zuus.LightningBolt", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_zuus/zuus_lightning_bolt.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin()+Vector(0,0,1500) )
			ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), 150, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_boss_invoker_thunder_lua_effect", {duration=1} )
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*4,
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

