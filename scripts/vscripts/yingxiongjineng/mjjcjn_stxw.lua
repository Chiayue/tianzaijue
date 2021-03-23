function stxw( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local duanshu = keys.ability:GetLevelSpecialValueFor("duanshu", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()

	if caster.stxw_baseDamage == nil then
		caster.stxw_baseDamage = 0
	end
	if caster.stxw_damage == nil then
		caster.stxw_damage = 0
	end
	if caster.stxw_count == nil then
		caster.stxw_count = 0
	end
	if caster.stxw_multiple == nil then
		caster.stxw_multiple = 0
	end

	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.stxw_baseDamage
	i = i + caster.stxw_damage
	local damage = (mj * i + baseDamage2 ) * x * 1.4

	duanshu= duanshu+ caster.stxw_count

	local time = 0
	-- 脚下特效
	local p1 = ParticleManager:CreateParticle( "particles/test/lxq_stxw_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	TimerUtil.createTimerWithDelay(1,function()
		if time <= duanshu then
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.stxw_multiple + multiple
			end	
			local damage2 = damage * multiple	
			caster:EmitSound("hero_Crystal.projectileImpact")
			-- 控制点0控制落冰点，控制点1控制落冰起始点。
			local p3 = ParticleManager:CreateParticle( "particles/test/lxq_stxw_ice.vpcf", PATTACH_ABSORIGIN, caster )
			local x = RandomInt(-1*radius, radius)
			local y = RandomInt(-1*radius, radius)
			ParticleManager:SetParticleControl( p3, 0, Vector(point.x + x, point.y + y, point.z) )
			ParticleManager:SetParticleControl( p3, 1, Vector(point.x + x, point.y + y, point.z + 1500) )
			local point_now=Vector(point.x + x, point.y + y, point.z)
			TimerUtil.createTimerWithDelay(1,function()
				local p2 = ParticleManager:CreateParticle( "particles/test/lxq_stxw_gound.vpcf", PATTACH_ABSORIGIN, caster )
				-- 控制点0为起始点，控制点1为半径
				ParticleManager:SetParticleControl( p2, 0, point_now )
				ParticleManager:SetParticleControl( p2, 1, Vector(radius/4,0,0) )
			end)
			time = time + 1
			--如果为了更真实，应该在延迟0.3S，之后再选取单位造成伤害，不然伤害在特效还没落下的时候就出现了
				TimerUtil.createTimerWithDelay(0.3, function()
				local units = FindAlliesInRadiusExdd(caster,point_now,300)
				if units ~= nil then
					for key, unit in pairs(units) do	
						ApplyDamageEx(caster,unit,ability,damage2)			
						if RollPercentage(15) then
							ability:ApplyDataDrivenModifier(caster, unit, "modifier_mjjcjn_stxw", {duration=debuff_duration})
						end
					end
				end
				end)
			return 0.1
		end
	end)









end




