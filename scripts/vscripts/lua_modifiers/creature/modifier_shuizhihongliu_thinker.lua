modifier_shuizhihongliu_thinker = class({})

-----------------------------------------------------------------------------

function modifier_shuizhihongliu_thinker:OnCreated( kv )
	self.stun_duration=self:GetAbility():GetSpecialValueFor("stun_duration")
	self.damage_radius=self:GetAbility():GetSpecialValueFor("damage_radius")
	
	if IsServer() then
        EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.pre.Torrent", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_bubbles_fxset.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetOrigin(), true )
			--ParticleManager:SetParticleControl( nFXIndex, 1, Vector(300,1,1)  )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			
			
		
	end
end


-----------------------------------------------------------------------------

function modifier_shuizhihongliu_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.Torrent", self:GetCaster() )
			--EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.SunStrike.Ignite", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/kunkka/divine_anchor/hero_kunkka_dafx_skills/kunkka_spell_torrent_splash_fxset.vpcf", PATTACH_WORLDORIGIN,  self:GetParent()  )
			ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
			ParticleManager:ReleaseParticleIndex( nFXIndex )
			
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					--enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "stun_nothing", {duration=self.stun_duration} )
					local kv =
						{
							center_x = self:GetParent():GetAbsOrigin().x,
							center_y = self:GetParent():GetAbsOrigin().y,
							center_z = self:GetParent():GetAbsOrigin().z,
							should_stun = true, 
							duration = self.stun_duration,
							knockback_duration = 1,
							knockback_distance = 0,
							knockback_height = 300,
						}

					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_knockback", kv )
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = 1.2*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
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

