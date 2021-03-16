boss_wood_bot_lunpan_end_lua = class({})
LinkLuaModifier( "modifier_boss_wood_bot_lunpan_end_lua","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_lunpan_end_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_bot_lunpan_end_lua_effect","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_lunpan_end_lua_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_bot_lunpan_end_lua_debuff","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_lunpan_end_lua_debuff", LUA_MODIFIER_MOTION_BOTH )


--------------------------------------------------------------------------------
function boss_wood_bot_lunpan_end_lua:OnSpellStart()
	if IsServer() then
		local hCaster = self:GetCaster()
		self.Storms = {}
		self.dragon_slave_width_initial = 250--self:GetSpecialValueFor( "dragon_slave_width_initial" )
		self.dragon_slave_width_end = 250--self:GetSpecialValueFor( "dragon_slave_width_end" )
		self.dragon_slave_distance = 10000--self:GetSpecialValueFor( "dragon_slave_distance" )
		self.storm_angle_step =120
		local ab=hCaster:FindAbilityByName("boss_wood_bot_lunpan_lua")
		if ab.lunpan then
			for i=1,#ab.lunpan do
				if ab.lunpan[i]~=nil and  not ab.lunpan[i]:IsNull() then
					if ab.lunpan[i]:IsAlive() then
						local unit=ab.lunpan[i]
						unit:AddNewModifier(nil, nil, "modifier_phased", {duration=15})
						unit.storm_speed =RandomInt(400, 1200) -- self:GetSpecialValueFor( "dragon_slave_speed" )
						local hCaster=self:GetCaster()
						EmitSoundOn( "Hero_DragonKnight.BreathFire", hCaster )
						self.storm_angle_step = self.storm_angle_step+10
						unit.angle = QAngle( 1, RandomInt(-360, 360), 0 )
						
						unit:AddNewModifier(hCaster, self, "modifier_boss_wood_bot_lunpan_end_lua_effect", {})
						if unit ~= nil then
							
							
							local info = 
							{
								EffectName = "",
								Ability = self,
								vSpawnOrigin = unit:GetOrigin(),
								fDistance = self.dragon_slave_distance,
								fStartRadius = self.dragon_slave_width_end,
								fEndRadius = self.dragon_slave_width_initial,
								Source = self:GetCaster(),
								iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
								iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
							}
							info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), unit.angle , Vector( 1, 0, 0 ) ) ) * unit.storm_speed
							unit.nProjHandle=ProjectileManager:CreateLinearProjectile( info )
							unit.y = unit.angle.y
							unit.flAngleUpdate = -3
							table.insert( self.Storms, unit )
						end
					end
				end
			end
		end
	    for i=1,4 do

	    	local point=hCaster:GetOrigin()+Vector(RandomInt(-1000,1000),RandomInt(-1000,1000))
	    	local unit=CreateUnitByName("npc_wood_bot_lunpan",point, true, hCaster, hCaster, hCaster:GetTeamNumber() )
	    	unit:AddNewModifier(hCaster, self, "modifier_boss_wood_bot_lunpan_end_lua", {})
	    	unit:AddNewModifier(hCaster, self, "modifier_boss_wood_bot_lunpan_end_lua_effect", {})
	    	unit:AddNewModifier(hCaster, self, "modifier_kill", {duration=15})
	    	unit:AddNewModifier(nil, nil, "modifier_phased", {duration=15})
	    	FindClearSpaceForUnit( unit, point, true )
	    	
			unit.storm_speed =RandomInt(400, 1200) -- self:GetSpecialValueFor( "dragon_slave_speed" )
			
			local hCaster=self:GetCaster()
			EmitSoundOn( "Hero_DragonKnight.BreathFire", hCaster )
			self.storm_angle_step = self.storm_angle_step+10
			unit.angle = QAngle( 1, RandomInt(-360, 360), 0 )
			
			if unit ~= nil then
				
				
				local info = 
				{
					EffectName = "",
					Ability = self,
					vSpawnOrigin = point,
					fDistance = self.dragon_slave_distance,
					fStartRadius = self.dragon_slave_width_end,
					fEndRadius = self.dragon_slave_width_initial,
					Source = self:GetCaster(),
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				}
				info.vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), unit.angle , Vector( 1, 0, 0 ) ) ) * unit.storm_speed 
				unit.nProjHandle=ProjectileManager:CreateLinearProjectile( info )
				unit.y = unit.angle.y
				unit.flAngleUpdate = -3
				table.insert( self.Storms, unit )
			end
	    end
	    local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 2000,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    
	    for _,enemy in pairs(enemies) do
	    	--if enemy:IsHero() then
	    		
	    		enemy:AddNewModifier( hCaster, self, "modifier_boss_wood_bot_lunpan_end_lua_debuff", {duration=15} )    			
	    		
	    		
	    	--end
	    	
	    end
	end
end

function boss_wood_bot_lunpan_end_lua:OnProjectileThinkHandle( iProjectileHandle )
	if IsServer() then

		for _,Storm in pairs( self.Storms ) do
			if Storm ~= nil and not Storm:IsNull() then
				if Storm.nProjHandle ~= nil and not Storm:IsAlive() then
					ProjectileManager:DestroyLinearProjectile( Storm.nProjHandle )				 
				end
			end
			if Storm ~= nil and Storm.nProjHandle == iProjectileHandle then
				Storm.y = Storm.y + Storm.flAngleUpdate
				Storm.flAngleUpdate = math.min( Storm.flAngleUpdate + 0.03, -1.8 )
				local angle = QAngle( 0, Storm.y, 0 )
				local vVelocity = ( RotatePosition( Vector( 0, 0, 0 ), angle, Vector( 1, 0, 0 ) ) ) * Storm.storm_speed 
				ProjectileManager:UpdateLinearProjectileDirection( iProjectileHandle, vVelocity, 1200 )
				local newvec=ProjectileManager:GetLinearProjectileLocation(iProjectileHandle)
				if  newvec then
					Storm:SetOrigin(newvec)
				end
			end
		end
	end
end
function boss_wood_bot_lunpan_end_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		
			local hCaster=self:GetCaster()
			
			EmitSoundOn( "hero_jakiro.projectileImpact", hTarget )
			local damageInfo =
						{
							victim = hTarget,
							attacker = self:GetCaster(),
							damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*3.8,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self,
						}
					ApplyDamage( damageInfo )
			
			
		
		
	end

	return false
end
