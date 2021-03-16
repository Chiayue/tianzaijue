modifier_yunshi_thinker = class({})

-----------------------------------------------------------------------------

function modifier_yunshi_thinker:OnCreated( kv )
	self.stun_duration=self:GetAbility():GetSpecialValueFor("stun_duration")
	self.damage_radius=self:GetAbility():GetSpecialValueFor("damage_radius")
	
	if IsServer() then
            
			local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "", self:GetParent():GetOrigin(), true )
			ParticleManager:SetParticleControl( nFXIndex, 1, Vector(self.damage_radius,1,1)  )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
            
            
            
			self:StartIntervalThink(1)
            self.init=true
	end
end

function modifier_yunshi_thinker:OnIntervalThink()
    if IsServer() then
        if self.init then
            local vDirection =  (self:GetCaster():GetOrigin()+Vector(0,0,1000))-self:GetParent():GetOrigin() 
            vDirection.z = 0.0
            vDirection = vDirection:Normalized()
            EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.ChaosMeteor.Cast", self:GetCaster() )
            local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_invoker/invoker_chaos_meteor_fly.vpcf", PATTACH_CUSTOMORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin()+vDirection*800+Vector(0,0,800) )
            ParticleManager:SetParticleControl( nFXIndex, 1, self:GetParent():GetOrigin()+Vector(0,0,-100) )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
            self.init=false
        end
		
            
	end
end
-----------------------------------------------------------------------------

function modifier_yunshi_thinker:OnDestroy()
	if IsServer() then
        if self:GetCaster() ~= nil and self:GetCaster():IsAlive() then
            EmitSoundOnLocationWithCaster( self:GetParent():GetOrigin(), "Hero_Invoker.ChaosMeteor.Impact", self:GetCaster() )
			local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
			for _,enemy in pairs( enemies ) do
				if enemy ~= nil and enemy:IsInvulnerable() == false then
					enemy:AddNewModifier( self:GetCaster(), self:GetAbility(), "stun_nothing", {duration=self.stun_duration} )
					local damageInfo = 
					{
						victim = enemy,
						attacker = self:GetCaster(),
						damage = 0.8*self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
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

