boss_two_endaoe_lua = class({})
LinkLuaModifier( "modifier_boss_two_endaoe_lua","lua_modifiers/boss/boss_two/modifier_boss_two_endaoe_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "add_attackspeed","lua_modifiers/boss/add_attackspeed", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_two_endaoe_lua:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn( "Hero_Brewmaster.PrimalSplit.Spawn", self:GetCaster() )
		local hCaster = self:GetCaster()
		local impact_radius=self:GetSpecialValueFor("impact_radius")
		local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, hCaster, PATTACH_POINT_FOLLOW, "", hCaster:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(impact_radius,1,1)  )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, impact_radius,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    	
    	self.target=nil
	    if #enemies>0 then
	    	self.target=enemies[1]
	    	local nFXIndex3 = ParticleManager:CreateParticle( "particles/econ/items/sniper/sniper_charlie/sniper_crosshair_charlie.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target )
			ParticleManager:SetParticleControl( nFXIndex3, 0, self.target :GetOrigin() )
			TimerUtil.createTimerWithDelay(3.5, function()
				ParticleManager:DestroyParticle(nFXIndex3, true)
			end)
			local time = 3
			TimerUtil.createTimer(function ()
				if time >0 then
					local nFXIndex2 = ParticleManager:CreateParticle( "particles/units/daojishi/demonartist_darkartistry_counter_number.vpcf", PATTACH_OVERHEAD_FOLLOW, self.target )
					ParticleManager:SetParticleControl( nFXIndex2, 0,self.target:GetOrigin())
					ParticleManager:SetParticleControl( nFXIndex2, 1, Vector(time,1,0) )
					time = time - 1
					TimerUtil.createTimerWithDelay(0.9, function()
						ParticleManager:DestroyParticle(nFXIndex2, true)
					--	ParticleManager:ReleaseParticleIndex(avalanche)
					end)
				return 1
				end
			end)
			

		end
		
		hCaster:AddNewModifier( hCaster, self, "modifier_item_invisibility_edge_windwalk", {duration=3} )
		return true
	end

end


function boss_two_endaoe_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local speed_duration=self:GetSpecialValueFor("duration")
	local damage=self:GetSpecialValueFor("damage")
	local aoe_radius=self:GetSpecialValueFor("aoe_radius")
	
	EmitSoundOn( "Hero_PhantomAssassin.CoupDeGrace ", self:GetCaster() )

	if self.target then

		local nFXIndex = ParticleManager:CreateParticle( "particles/add_custom/boss_warning/aoe_warning.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControlEnt( nFXIndex, 0, self.target, PATTACH_POINT_FOLLOW, "", self.target:GetOrigin(), true )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(aoe_radius,1,1)  )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
		
		local enemies = FindUnitsInRadius(self.target:GetTeamNumber(), self.target:GetAbsOrigin(), nil, aoe_radius,
                    DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
	    if #enemies>0 then
	    	for _,enemy in pairs(enemies) do
		        local damageInfo =
				{
					victim = enemy,
					attacker = self:GetCaster(),
					damage = self.target:GetMaxHealth()*0.75/#enemies,
					damage_type = DAMAGE_TYPE_PURE,
					ability = self,
				}
			ApplyDamage( damageInfo )
		    end		
		end

		if self.target:IsAlive() then
			self.target:AddNewModifier( hCaster, self, "stun_nothing", {duration=5} )
		else
			hCaster:AddNewModifier( hCaster, self, "modifier_boss_two_endaoe_lua", {duration=20} )
		end
		
	end

end


function boss_two_endaoe_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end
function boss_two_endaoe_lua:GetCastPoint()
	
	return self.BaseClass.GetCastPoint( self )
end

