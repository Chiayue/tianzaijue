pudge_meat_hook_lua = class({})
LinkLuaModifier("modifier_pudge_meat_hook_followthrough_lua", "lua_modifiers/boss/boss_pudge/modifier_pudge_meat_hook_followthrough_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier("modifier_pudge_meat_hook_lua", "lua_modifiers/boss/boss_pudge/modifier_pudge_meat_hook_lua", LUA_MODIFIER_MOTION_BOTH )

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnAbilityPhaseStart()
	self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnAbilityPhaseInterrupted()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnSpellStart()
    
    self.Projectile={}
	if self.hVictim ~= nil then
		self.hVictim:InterruptMotionControllers( true )
	end
    local hCaster = self:GetCaster()
	--local range=self:GetCastRange(hCaster:GetOrigin(),hCaster)
	local enemies = FindUnitsInRadius(
        hCaster:GetTeamNumber(),
        hCaster:GetOrigin(),
        nil,
        2000,
        2,
        DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
        0,
        0,
        false
    )
    for i=1,#enemies do
    	if i > 10 then
    		return 
    	end
        self.hook_damage = self:GetSpecialValueFor( "hook_damage" )  
        self.hook_speed = self:GetSpecialValueFor( "hook_speed" )
        self.hook_width = self:GetSpecialValueFor( "hook_width" )
        self.hook_distance = self:GetSpecialValueFor( "hook_distance" )
        self.hook_followthrough_constant = self:GetSpecialValueFor( "hook_followthrough_constant" )

        self.vision_radius = self:GetSpecialValueFor( "vision_radius" )  
        self.vision_duration = self:GetSpecialValueFor( "vision_duration" )  
        
        if self:GetCaster() and self:GetCaster():IsHero() then
            local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
            if hHook ~= nil then
                hHook:AddEffects( EF_NODRAW )
            end
        end

        self.vStartPosition = self:GetCaster():GetOrigin()
        self.vProjectileLocation = self.vStartPosition

        local vDirection = enemies[i]:GetOrigin() - self.vStartPosition
        vDirection.z = 0.0

        local vDirection = ( vDirection:Normalized() ) * self.hook_distance
        local vTargetPosition = self.vStartPosition + vDirection

        local flFollowthroughDuration = ( self.hook_distance / self.hook_speed * self.hook_followthrough_constant )
        self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_pudge_meat_hook_followthrough_lua", { duration = flFollowthroughDuration } )

        self.vHookOffset = Vector( 0, 0, 96 )
        local vHookTarget = vTargetPosition + self.vHookOffset
        local vKillswitch = Vector( ( ( self.hook_distance / self.hook_speed ) * 2 ), 0, 0 )

        local nChainParticleFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook.vpcf", PATTACH_CUSTOMORIGIN, self:GetCaster() )
        ParticleManager:SetParticleAlwaysSimulate( nChainParticleFXIndex )
        ParticleManager:SetParticleControlEnt( nChainParticleFXIndex, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true )
        ParticleManager:SetParticleControl( nChainParticleFXIndex, 1, vHookTarget )
        ParticleManager:SetParticleControl( nChainParticleFXIndex, 2, Vector( self.hook_speed, self.hook_distance, self.hook_width ) )
        ParticleManager:SetParticleControl( nChainParticleFXIndex, 3, vKillswitch )
        ParticleManager:SetParticleControl( nChainParticleFXIndex, 4, Vector( 1, 0, 0 ) )
        ParticleManager:SetParticleControl( nChainParticleFXIndex, 5, Vector( 0, 0, 0 ) )
        ParticleManager:SetParticleControlEnt( nChainParticleFXIndex, 7, self:GetCaster(), PATTACH_CUSTOMORIGIN, nil, self:GetCaster():GetOrigin(), true )

        EmitSoundOn( "Hero_Pudge.AttackHookExtend", self:GetCaster() )

        local info = {
            Ability = self,
            vSpawnOrigin = self:GetCaster():GetOrigin(),
            vVelocity = vDirection:Normalized() * self.hook_speed,
            fDistance = self.hook_distance,
            fStartRadius = self.hook_width ,
            fEndRadius = self.hook_width ,
            Source = self:GetCaster(),
            iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
            iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
            iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ANCIENTS,
        }

        local temp=ProjectileManager:CreateLinearProjectile( info )
        self.Projectile[temp]={}
        self.Projectile[temp].bRetracting=false
        self.Projectile[temp].hVictim=nil
        self.Projectile[temp].nChainParticleFXIndex=nChainParticleFXIndex
        self.Projectile[temp].vProjectileLocation=self.vStartPosition
        self.Projectile[temp].vStartPosition=self.vStartPosition
        self.Projectile[temp].bChainAttached = false
        self.Projectile[temp].vTargetPosition = vTargetPosition
        
        --self.bRetracting = false
        --self.hVictim = nil
        --self.bDiedInHook = false
    end
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnProjectileHitHandle( hTarget, vLocation ,projectileHandle)
	if hTarget == self:GetCaster() then
		return false
	end
	if hTarget and hTarget:HasModifier("modifier_pudge_meat_hook_tiny_lua") then  --如果已经被小屠夫勾了就不再被勾
		return false
	end
    if self.Projectile[projectileHandle].bRetracting == false then
		if hTarget ~= nil and ( not ( hTarget:IsCreep() or hTarget:IsConsideredHero() ) ) then
			Msg( "Target was invalid")
			return false
		end

		local bTargetPulled = false
		if hTarget ~= nil then
			EmitSoundOn( "Hero_Pudge.AttackHookImpact", hTarget )

			hTarget:AddNewModifier( self:GetCaster(), self, "modifier_pudge_meat_hook_lua", nil )
			
			if hTarget:GetTeamNumber() ~= self:GetCaster():GetTeamNumber() then
				local damage = {
                    victim = hTarget,
                    attacker = self:GetCaster(),
                    damage =self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
                    damage_type = DAMAGE_TYPE_PURE,		
                    ability = this
                }

				ApplyDamage( damage )
				if not hTarget:IsMagicImmune() then
					hTarget:Interrupt()
				end
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_pudge/pudge_meathook_impact.vpcf", PATTACH_CUSTOMORIGIN, hTarget )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
            AddFOWViewer( self:GetCaster():GetTeamNumber(), hTarget:GetOrigin(), self.vision_radius, self.vision_duration, false )
			self.Projectile[projectileHandle].hVictim = hTarget
			bTargetPulled = true
		end

		local vHookPos = self.Projectile[projectileHandle].vTargetPosition
		local flPad = self:GetCaster():GetPaddedCollisionRadius()
		if hTarget ~= nil then
			vHookPos = hTarget:GetOrigin()
			flPad = flPad + hTarget:GetPaddedCollisionRadius()
		end

		--Missing: Setting target facing angle
		local vVelocity = self.vStartPosition - vHookPos
		vVelocity.z = 0.0

		local flDistance = vVelocity:Length2D() - flPad
		vVelocity = vVelocity:Normalized() * self.hook_speed

		local info = {
			Ability = self,
			vSpawnOrigin = vHookPos,
			vVelocity = vVelocity,
			fDistance = flDistance,
			Source = self:GetCaster(),
		}

		local temp=ProjectileManager:CreateLinearProjectile( info )
        self.Projectile[temp]={}
        if hTarget then
            self.Projectile[temp]=self.Projectile[projectileHandle]
        end
		--self.vProjectileLocation = vHookPos
        self.Projectile[projectileHandle].vProjectileLocation= vHookPos
        self.Projectile[temp].vProjectileLocation= vHookPos
		if hTarget ~= nil and ( not hTarget:IsInvisible() ) and bTargetPulled then
			ParticleManager:SetParticleControlEnt( self.Projectile[projectileHandle].nChainParticleFXIndex, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin() + self.vHookOffset, true )
			ParticleManager:SetParticleControl( self.Projectile[projectileHandle].nChainParticleFXIndex, 4, Vector( 0, 0, 0 ) )
			ParticleManager:SetParticleControl( self.Projectile[projectileHandle].nChainParticleFXIndex, 5, Vector( 1, 0, 0 ) )
		else
			ParticleManager:SetParticleControlEnt( self.Projectile[projectileHandle].nChainParticleFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_weapon_chain_rt", self:GetCaster():GetOrigin() + self.vHookOffset, true);
		end

		EmitSoundOn( "Hero_Pudge.AttackHookRetract", hTarget )

		if self:GetCaster():IsAlive() then
			self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
			self:GetCaster():StartGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
		end

		self.Projectile[projectileHandle].bRetracting = true
	else
		if self:GetCaster() and self:GetCaster():IsHero() then
			local hHook = self:GetCaster():GetTogglableWearable( DOTA_LOADOUT_TYPE_WEAPON )
			if hHook ~= nil then
				hHook:RemoveEffects( EF_NODRAW )
			end
		end

		if self.Projectile[projectileHandle].hVictim ~= nil then
			local vFinalHookPos = vLocation
			self.Projectile[projectileHandle].hVictim:InterruptMotionControllers( true )
			self.Projectile[projectileHandle].hVictim:RemoveModifierByName( "modifier_pudge_meat_hook_lua" )

			local vVictimPosCheck = self.Projectile[projectileHandle].hVictim:GetOrigin() - vFinalHookPos 
			local flPad = self:GetCaster():GetPaddedCollisionRadius() + self.Projectile[projectileHandle].hVictim:GetPaddedCollisionRadius()
			if vVictimPosCheck:Length2D() > flPad then
				FindClearSpaceForUnit( self.Projectile[projectileHandle].hVictim, self.vStartPosition, false )
			end
		end

		self.Projectile[projectileHandle].hVictim = nil
		if self.Projectile[projectileHandle].nChainParticleFXIndex then
			ParticleManager:DestroyParticle( self.Projectile[projectileHandle].nChainParticleFXIndex, true )
		end
		EmitSoundOn( "Hero_Pudge.AttackHookRetractStop", self:GetCaster() )
	end

	return true
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnProjectileThinkHandle( projectileHandle )
    
	self.Projectile[projectileHandle].vProjectileLocation =ProjectileManager:GetLinearProjectileLocation(projectileHandle)
end

--------------------------------------------------------------------------------

function pudge_meat_hook_lua:OnOwnerDied()
	self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 );
	self:GetCaster():RemoveGesture( ACT_DOTA_CHANNEL_ABILITY_1 );
end

--------------------------------------------------------------------------------