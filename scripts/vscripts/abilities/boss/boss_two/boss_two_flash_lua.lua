boss_two_flash_lua = class({})
LinkLuaModifier( "modifier_boss_two_flash_lua_slow","lua_modifiers/boss/boss_two/modifier_boss_two_flash_lua_slow", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_two_flash_lua_thinker","lua_modifiers/boss/boss_two/modifier_boss_two_flash_lua_thinker", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "add_attackspeed","lua_modifiers/boss/add_attackspeed", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_two_flash_lua:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_PhantomAssassin.Blur", self:GetCaster() )
		local hCaster = self:GetCaster()
		local impact_radius=self:GetSpecialValueFor("impact_radius")
		local speed_duration=self:GetSpecialValueFor("duration")
		local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(impact_radius,1,1)  )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, impact_radius,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
	    if #enemies>0 then
	    	self.target=enemies[1]
	    	for _,enemy in pairs(enemies) do
	    		if enemy:GetHealthPercent()<self.target:GetHealthPercent() then
	    			self.target=enemy
	    		end
	    		
	    	end
	    	
	    	self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_slardar/slardar_amp_damage.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target )
			ParticleManager:SetParticleControl( self.nFXIndex, 0, self.target :GetOrigin() )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 2, self.target, PATTACH_OVERHEAD_FOLLOW, "", self.target:GetOrigin(), true )
			Timers:CreateTimer(speed_duration,function ()
						hCaster:SetForceAttackTarget(nil)
						ParticleManager:DestroyParticle(self.nFXIndex ,true)
						end)
	    	
	    end
		
	end
	return true
end

function boss_two_flash_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local speed_duration=self:GetSpecialValueFor("duration")
	local damage=self:GetSpecialValueFor("damage")
	EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )

	if self.target then
		local point2 = self.target:GetOrigin()+100*(-self.target:GetForwardVector())
	--	if GridNav:CanFindPath(hCaster:GetAbsOrigin(), point2)  then
			--Teleport(hCaster,point2)
			FindClearSpaceForUnit( hCaster, point2, true )
			hCaster:SetForceAttackTarget(self.target)
	--	end
		local buff=hCaster:AddNewModifier( hCaster, self, "add_attackspeed", {duration=speed_duration} )
		buff:SetStackCount(math.ceil(hCaster:GetDisplayAttackSpeed())*damage/100)
	end
	
end


function boss_two_flash_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end
function boss_two_flash_lua:GetCastPoint()
	return self.BaseClass.GetCastPoint( self )
end

