function yjj( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()
	local fv = GetForwardVector(caster_point,point) * radius
	point = caster_point + fv
	local mj = caster:GetAgility()
	
	if caster.yjj_baseDamage == nil then
		caster.yjj_baseDamage = 0
	end
	if caster.yjj_damage == nil then
		caster.yjj_damage = 0
	end

	local baseDamage2 = baseDamage + caster.yjj_baseDamage
	i = i + caster.yjj_damage
	local damage = (mj * i + baseDamage2 ) * x
		
	local particleID = ParticleManager:CreateParticle("particles/econ/items/ancient_apparition/aa_blast_ti_5/ancient_apparition_ice_blast_sphere_final_explosion_smoke_ti5.vpcf",PATTACH_WORLDORIGIN,caster)--火女火焰灰烬特效
	ParticleManager:SetParticleControl(particleID,0,caster:GetOrigin())
	
	
	createProjectile2(ability,caster,damage)


end



--创建御剑诀特效
function createProjectile2(ability,hero,damage)
	local projectile_velocity=hero:GetForwardVector()
--	projectile_velocity.x=projectile_velocity.x*math.cos(math.rad(jiaodu))+projectile_velocity.y*math.sin(math.rad(jiaodu))
--	projectile_velocity.y=projectile_velocity.x*math.sin(math.rad(-jiaodu))+projectile_velocity.y*math.cos(math.rad(jiaodu))

	local projectile = {
		EffectName = "particles/demo2.vpcf",
		vSpawnOrigin = hero:GetAbsOrigin() + Vector(0,0,80),--{unit=hero, attach="attach_attack1", offset=Vector(0,0,0)},
		fDistance = 1500,
		fStartRadius = false,
		fEndRadius = 450,
		Source = hero,
		fExpireTime = 1,
		vVelocity = projectile_velocity * 900, -- RandomVector(1000),
		UnitBehavior = PROJECTILES_NOTHING,
		bMultipleHits = false,
		bIgnoreSource = true,
		TreeBehavior = PROJECTILES_NOTHING,--PROJECTILES_DESTROY,
		bCutTrees = false,
		bTreeFullCollision = false,
		WallBehavior = PROJECTILES_DESTROY,
		GroundBehavior = PROJECTILES_NOTHING,
		fGroundOffset = 80,
		nChangeMax = 1,
		bRecreateOnChange = true,
		bZCheck = false,
		bGroundLock = true,
		bProvidesVision = false,
		iVisionRadius = 350,
		iVisionTeamNumber = hero:GetTeam(),
		bFlyingVision = false,
		fVisionTickTime = .1,
		fVisionLingerDuration = 1,
		draw = false,
		UnitTest = function(self, unit) return unit:GetUnitName() ~= "npc_dummy_unit" and unit:GetTeamNumber() ~= hero:GetTeamNumber() end,
		OnUnitHit = function(self, unit)
		ApplyDamageEx(hero,unit,ability,damage)
			
		local particleID = ParticleManager:CreateParticle("particles/econ/items/antimage/antimage_weapon_basher_ti5/am_manaburn_basher_ti_5_b.vpcf",PATTACH_WORLDORIGIN,unit)--火女火焰灰烬特效
		ParticleManager:SetParticleControl(particleID,0,unit:GetOrigin())
	
			
		end

	}

	Projectiles:CreateProjectile(projectile)
end







function xlzt ( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius",level)
	local i = keys.ability:GetLevelSpecialValueFor("i",level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local duration = keys.ability:GetLevelSpecialValueFor("duration", level)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local target_point = keys.target_points[1]
	local point=caster:GetAbsOrigin()
	local mj = caster:GetAgility()
	
	if caster.xlzt_baseDamage == nil then
		caster.xlzt_baseDamage = 0
	end
	if caster.xlzt_damage == nil then
		caster.xlzt_damage = 0
	end
	if caster.xlzt_radius == nil then
		caster.xlzt_radius = 0
	end
	if caster.xlzt_multiple == nil then
		caster.xlzt_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.xlzt_multiple + multiple
	end	
	radius = radius + caster.xlzt_radius
	local baseDamage2 = baseDamage + caster.xlzt_baseDamage
	local	damage = (mj * i + baseDamage2 ) * x * multiple


	local distance = GetDistance2D(caster:GetAbsOrigin(),target_point)--获得英雄位置与point的距离
	local forwardVec = (target_point - caster:GetAbsOrigin()):Normalized()--2个坐标获得向量

	
	ability:ApplyDataDrivenModifier(caster, caster, "modifier_mjjcjn_xlzt", {duration=duration})
	
			local particleID = ParticleManager:CreateParticle("particles/econ/items/zeus/arcana_chariot/zeus_arcana_kill_explosion.vpcf",PATTACH_WORLDORIGIN,hero)--火女火焰灰烬特效
			ParticleManager:SetParticleControl(particleID,1,caster:GetOrigin())
			ParticleManager:SetParticleControl(particleID,2,target_point)
			TimerUtil.createTimerWithDelay(0.2, function()
				caster:EmitSound("Hero_StormSpirit.Overload")
				Teleport(caster,target_point,true)
				local units = FindAlliesInRadiusExdd(caster,target_point,radius)
				if units ~= nil then
				for key, unit in pairs(units) do	
						ApplyDamageEx(caster,unit,ability,damage)
						ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
						ability:ApplyDataDrivenModifier(caster, unit, "modifier_mjjcjn_xlzt1", {duration=duration})


						local unitpaticular = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_storm_bolt_projectile_explosion_trail.vpcf",PATTACH_ABSORIGIN_FOLLOW,unit)--命中敌方特效
						ParticleManager:SetParticleControl(unitpaticular,3,unit:GetOrigin())

					end
				end
			end)
	
	local particleID = ParticleManager:CreateParticle("particles/econ/items/lina/lina_head_headflame/lina_spell_dragon_slave_headflame_d.vpcf",PATTACH_WORLDORIGIN,caster)--火女火焰灰烬特效
	ParticleManager:SetParticleControl(particleID,3,caster:GetOrigin())
	ParticleManager:SetParticleControlOrientation(particleID,0,forwardVec,Vector( 0, 1, 0), Vector( 1, 0, 0 ) );
	--Projectiles:CreateProjectile(projectile)

	

end
