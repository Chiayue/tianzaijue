modifier_boss_tiny_jump_lua = class({})

--------------------------------------------------------------------------------

local AMOEBA_MINIMUM_HEIGHT_ABOVE_LOWEST = 400
local AMOEBA_MINIMUM_HEIGHT_ABOVE_HIGHEST = 200
local AMOEBA_ACCELERATION_Z = 1250  --可控制时间，越大跳跃时间越短
local AMOEBA_MAX_HORIZONTAL_ACCELERATION = 1500

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:RemoveOnDeath()
	return false
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:OnCreated( kv )
	if IsServer() then
		self.bHorizontalMotionInterrupted = false
		self.bDamageApplied = false
		self.bTargetTeleported = false

		if self:ApplyHorizontalMotionController() == false or self:ApplyVerticalMotionController() == false then 
			self:Destroy()
			return
		end

		self.vStartPosition = GetGroundPosition( self:GetParent():GetOrigin(), self:GetParent() )
		self.flCurrentTimeHoriz = 0.0
		self.flCurrentTimeVert = 0.0

		self.vLoc = self:GetAbility().targetPoint
		self.vLastKnownTargetPos = self.vLoc

		local duration = 0
		
		local flDesiredHeight = AMOEBA_MINIMUM_HEIGHT_ABOVE_LOWEST * duration * duration
		
		local flLowZ = math.min( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flHighZ = math.max( self.vLastKnownTargetPos.z, self.vStartPosition.z )
		local flArcTopZ = math.max( flLowZ + flDesiredHeight, flHighZ + AMOEBA_MINIMUM_HEIGHT_ABOVE_HIGHEST )
		
		local flArcDeltaZ = flArcTopZ - self.vStartPosition.z
		self.flInitialVelocityZ = math.sqrt( 2.0 * flArcDeltaZ * AMOEBA_ACCELERATION_Z )

		local flDeltaZ = self.vLastKnownTargetPos.z - self.vStartPosition.z
		local flSqrtDet = math.sqrt( math.max( 0, ( self.flInitialVelocityZ * self.flInitialVelocityZ ) - 2.0 * AMOEBA_ACCELERATION_Z * flDeltaZ ) )
        self.flPredictedTotalTime = math.max( ( self.flInitialVelocityZ + flSqrtDet) / ( AMOEBA_ACCELERATION_Z ), ( self.flInitialVelocityZ - flSqrtDet) / ( AMOEBA_ACCELERATION_Z ) )
        
		self.vHorizontalVelocity = ( self.vLastKnownTargetPos - self.vStartPosition ) / self.flPredictedTotalTime
		self.vHorizontalVelocity.z = 0.0
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:OnDestroy()
	if IsServer() then
		
        EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )
        local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_CUSTOMORIGIN, nil )
            ParticleManager:SetParticleControl( nFXIndex, 0, self:GetParent():GetOrigin() )
            ParticleManager:SetParticleControl( nFXIndex, 1, Vector(500,1,1)  )
            ParticleManager:ReleaseParticleIndex(nFXIndex)
         local enemies = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), nil, 500,
                        DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                        DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
        local target
        for _,enemy in pairs(enemies) do
            enemy:AddNewModifier( self:GetParent(), self, "stun_nothing", {duration=2.5} )
            local damage = {
                victim = enemy,
                attacker = self:GetCaster(),
                damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*3,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
            }
            ApplyDamage( damage )
        end

        GridNav:DestroyTreesAroundPoint( self:GetParent():GetOrigin(), 300, false )
        self:GetParent():RemoveHorizontalMotionController( self )
        self:GetParent():RemoveVerticalMotionController( self )
        
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:CheckState()
	local state =
	{
		[MODIFIER_STATE_STUNNED] = false,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:UpdateHorizontalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeHoriz = math.min( self.flCurrentTimeHoriz + dt, self.flPredictedTotalTime )
		local t = self.flCurrentTimeHoriz / self.flPredictedTotalTime
		local vStartToTarget = self.vLastKnownTargetPos - self.vStartPosition
		local vDesiredPos = self.vStartPosition + t * vStartToTarget

		local vOldPos = me:GetOrigin()
		local vToDesired = vDesiredPos - vOldPos
		vToDesired.z = 0.0
		local vDesiredVel = vToDesired / dt
		local vVelDif = vDesiredVel - self.vHorizontalVelocity
		local flVelDif = vVelDif:Length2D()
		vVelDif = vVelDif:Normalized()
		local flVelDelta = math.min( flVelDif, AMOEBA_MAX_HORIZONTAL_ACCELERATION )

		self.vHorizontalVelocity = self.vHorizontalVelocity + vVelDif * flVelDelta * dt
		local vNewPos = vOldPos + self.vHorizontalVelocity * dt
		me:SetOrigin( vNewPos )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:UpdateVerticalMotion( me, dt )
	if IsServer() then
		self.flCurrentTimeVert = self.flCurrentTimeVert + dt
		local bGoingDown = ( -AMOEBA_ACCELERATION_Z * self.flCurrentTimeVert + self.flInitialVelocityZ ) < 0
		
		local vNewPos = me:GetOrigin()
		vNewPos.z = self.vStartPosition.z + ( -0.5 * AMOEBA_ACCELERATION_Z * ( self.flCurrentTimeVert * self.flCurrentTimeVert ) + self.flInitialVelocityZ * self.flCurrentTimeVert )

		local flGroundHeight = GetGroundHeight( vNewPos, self:GetParent() )
		local bLanded = false
		if ( vNewPos.z < flGroundHeight and bGoingDown == true ) then
			vNewPos.z = flGroundHeight
			bLanded = true
		end

		me:SetOrigin( vNewPos )
		if bLanded == true then
			if self.bHorizontalMotionInterrupted == false then
				
			end

			self:Destroy()
		end
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:OnHorizontalMotionInterrupted()
	if IsServer() then
		self.bHorizontalMotionInterrupted = true
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end

--------------------------------------------------------------------------------

function modifier_boss_tiny_jump_lua:DeclareFunctions()
	local funcs =
	{
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}
	return funcs
end



function modifier_boss_tiny_jump_lua:GetOverrideAnimation( params )
	return ACT_DOTA_CAST_ABILITY_ROT
end
