

modifier_boss_tiny_throw_lua = class({})

-----------------------------------------------------------------------------


function modifier_boss_tiny_throw_lua:OnCreated( kv )
	if IsServer() then
	self:StartIntervalThink(1.5)		
	self.thrownum=0
			self.tt=RandomInt(-180,180)
	end
end
function modifier_boss_tiny_throw_lua:CheckState()
	local state = {
	[MODIFIER_STATE_STUNNED] = true,
	}

	return state
end

-----------------------------------------------------------------------------

function modifier_boss_tiny_throw_lua:OnIntervalThink()
	if IsServer() then
		if  self:GetCaster():IsAlive() then
			if self.thrownum==6 then
				
				self:GetAbility():StartCooldown(-1)
				self:GetCaster():RemoveModifierByName("modifier_boss_tiny_throw_lua")
				return nil
			end
			self.thrownum=self.thrownum+1
			local hCaster=self:GetCaster()
			
				self.dragon_slave_speed =400-- self:GetSpecialValueFor( "dragon_slave_speed" )
				self.dragon_slave_width_initial = 55--self:GetSpecialValueFor( "dragon_slave_width_initial" )
				self.dragon_slave_width_end = 55--self:GetSpecialValueFor( "dragon_slave_width_end" )
				self.dragon_slave_distance = 2500
				

				EmitSoundOn( "Ability.TossThrow", self:GetCaster() )
				for i=1,24 do
					local vDirection = hCaster:GetOrigin()+RandomVector(2000) - hCaster:GetOrigin()
					vDirection.z = 0.0
					vDirection = vDirection:Normalized()
					self.tt=RandomInt(-180,180)
				--	self.dragon_slave_speed = self.dragon_slave_speed * ( self.dragon_slave_distance / ( self.dragon_slave_distance - self.dragon_slave_width_initial ) )
					local default_pat="particles/basic_boss/tiny_st/tiny_avalanche_projectile.vpcf"
					local info = {
						EffectName = default_pat,
						Ability = self:GetAbility(),
						vSpawnOrigin = hCaster:GetOrigin(), 
						fStartRadius = self.dragon_slave_width_initial,
						fEndRadius = self.dragon_slave_width_end,
						vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), QAngle(0, self.tt+30*i, 0 ), Vector( 1, 0, 0 ) ) ) * self.dragon_slave_speed,
						fDistance = self.dragon_slave_distance,
						Source = hCaster,
						iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
						iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					}

				   ProjectileManager:CreateLinearProjectile( info )
				end
			
		end
	end
end

-----------------------------------------------------------------------------

function modifier_boss_tiny_throw_lua:OnDestroy()
	if IsServer() then
		
		
	end
end

-----------------------------------------------------------------------------

