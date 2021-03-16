modifier_bingzhishijie_thinker = class({})

-----------------------------------------------------------------------------

function modifier_bingzhishijie_thinker:OnCreated( kv )
	self.stun_duration=self:GetAbility():GetSpecialValueFor("stun_duration")
	self.enemy_radius=self:GetAbility():GetSpecialValueFor("enemy_radius")
	
	if IsServer() then
            EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Crystal.CrystalNova", self:GetCaster() )
			local nFXIndex = ParticleManager:CreateParticle( "particles/boss/tsq/clicked_rings_red.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.enemy_radius,1,1)  )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			local nFXIndex2 = ParticleManager:CreateParticle( "particles/boss/tsq2/clicked_rings_red.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex2, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex2, 1, Vector(self.enemy_radius,1,1)  )
			ParticleManager:ReleaseParticleIndex(nFXIndex2)
			
		
	end
end


-----------------------------------------------------------------------------

function modifier_bingzhishijie_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.enemy_radius-100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_bingzhishijie_frazen", {duration=self.stun_duration} )
					
				end
			end
			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------------

