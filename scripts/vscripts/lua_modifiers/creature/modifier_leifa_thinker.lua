modifier_leifa_thinker = class({})

-----------------------------------------------------------------------------

function modifier_leifa_thinker:OnCreated( kv )
	self.slow_duration=self:GetAbility():GetSpecialValueFor("slow_duration")
	self.damage_radius=self:GetAbility():GetSpecialValueFor("damage_radius")
	
	if IsServer() then
        --EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Ability.pre.Torrent", self:GetCaster() )
        local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
        ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetOrigin(), true )
        ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.damage_radius,1,1)  )
        ParticleManager:ReleaseParticleIndex(nFXIndex)
		 local particleID= ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zeus_loadout.vpcf",PATTACH_CUSTOMORIGIN,self:GetParent())
           -- ParticleManager:SetParticleControl(particleID,0,self:GetParent():GetOrigin()+Vector(0,0,1200))
            ParticleManager:SetParticleControl(particleID,0,self:GetParent():GetOrigin())
            ParticleManager:ReleaseParticleIndex(particleID)
            
		
	end
end


-----------------------------------------------------------------------------

function modifier_leifa_thinker:OnDestroy()
	if IsServer() then
		if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
			EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(),"Hero_Zuus.LightningBolt", hCaster )
			particleID= ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf",PATTACH_CUSTOMORIGIN,self:GetParent())
            ParticleManager:SetParticleControl(particleID,0,self:GetParent():GetOrigin())
            ParticleManager:ReleaseParticleIndex(particleID)	
			
			
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "modifier_leifa_slow_nothing", {duration=self.slow_duration} )
				end
			end
			UTIL_Remove( self:GetParent() )
		end
	end
end

-----------------------------------------------------------------------------

