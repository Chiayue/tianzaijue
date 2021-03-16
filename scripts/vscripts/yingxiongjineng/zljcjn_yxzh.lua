function yxzh( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", keys.ability:GetLevel() - 1)	
	
	local level = ability:GetLevel() - 1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()

	if caster.yxzh_baseDamage == nil then
		caster.yxzh_baseDamage = 0
	end
	if caster.yxzh_damage == nil then
		caster.yxzh_damage = 0
	end
	if caster.yxzh_distance == nil then
		caster.yxzh_distance = 0
	end
	if caster.yxzh_multiple == nil then
		caster.yxzh_multiple = 0
	end
	local multiple = 1
	if RollPercentage(20) then
		multiple = caster.yxzh_multiple + multiple
	end	
	local jd = caster_point + GetForwardVector(caster_point,point) * (radius+ caster.yxzh_distance)
	local jl = jd - caster_point
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.yxzh_baseDamage
	i = i + caster.yxzh_damage
	local damage = (zl * i + baseDamage2 ) * x * multiple
	

	local p1 = ParticleManager:CreateParticle( "particles/test/xb_huoqiu.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	-- 控制点6
	ParticleManager:SetParticleControl( p1, 6, jl * 4 )
	local p2 = ParticleManager:CreateParticle( "particles/econ/items/gyrocopter/hero_gyrocopter_gyrotechnics/gyro_calldown_explosion_fireworks.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	-- 控制点6
	ParticleManager:SetParticleControl( p2, 3,caster:GetAbsOrigin() )
	ParticleManager:SetParticleControlOrientation(p2,3,caster:GetForwardVector(),Vector( 0, 1, 0), Vector( 1, 0, 0 ) );

	caster:EmitSound("Hero_Lina.DragonSlave.FireHair")

	local units = FindUnitsInLine( caster:GetTeamNumber(),caster_point,jd, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
	if units ~= nil then
	for key, unit in pairs(units) do
		
		
		ApplyDamageMf(caster,unit,ability,damage)
		ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	--	local particleID = ParticleManager:CreateParticle( "particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf", PATTACH_ABSORIGIN, caster )
	--	ParticleManager:SetParticleControl( particleID, 0, unit:GetAbsOrigin() )

		end
	end	
	
	TimerUtil.createTimerWithDelay(5,
		function()
			ParticleManager:DestroyParticle(p1,false)
		end
	)

end






--天玄焚火
function txfh( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius", level)
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local stun_time = keys.ability:GetLevelSpecialValueFor("stun_time", level)	
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()
	
	if caster.txfh_baseDamage == nil then
		caster.txfh_baseDamage = 0
	end
	if caster.txfh_damage == nil then
		caster.txfh_damage = 0
	end
	if caster.txfh_radius == nil then
		caster.txfh_radius = 0
	end
	radius = radius + caster.txfh_radius
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.txfh_baseDamage
	i = i + caster.txfh_damage
	local damage = (zl * i + baseDamage2 ) * x
	
	
	if caster.txfh_time == nil then
		caster.txfh_time = 0
	end
	if caster.txfh_multiple == nil then
		caster.txfh_multiple = 0
	end

	time =  1 + caster.txfh_time	--s设置触发概率

		TimerUtil.createTimerWithDelay(0.3,function ()
		if time > 0 then
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.txfh_multiple + multiple
			end	
			local damage2 = damage * multiple
			tianxuanfenghuo_dmg (ability,caster,point,radius,damage2,stun_time)
			time = time - 1
			return 0.5 	--每0.5S触发一次
		end
		end)


end



 --天玄焚火伤害
function tianxuanfenghuo_dmg (ability,hero,point,radius,damage,stun_time)
	local playerid=hero:GetPlayerOwnerID()
	local p1 = ParticleManager:CreateParticle("particles/abilities/xb_tianxuanfenghuo/uicide_base.vpcf",PATTACH_ABSORIGIN,hero)
	ParticleManager:SetParticleControl( p1, 0, point )

	hero:EmitSound("Hero_Invoker.SunStrike.Ignite")

	local units = FindAlliesInRadiusExdd(hero,point,radius)
	if units ~= nil then
	for key, unit in pairs(units) do
		
		--添加眩晕效果
		ability:ApplyDataDrivenModifier(hero, unit, "modifier_zljcjn_txfh", {duration=stun_time})
		ApplyDamageEx(hero,unit,ability,damage)
		
		end
	end	

end





--月锁千秋
function ysqq( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius", level)
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local duration =  keys.ability:GetLevelSpecialValueFor("duration", level)
	local interval =  keys.ability:GetLevelSpecialValueFor("interval", level)
	local baseHeal = keys.ability:GetLevelSpecialValueFor("baseHeal", level)
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point=caster:GetAbsOrigin()
	local zl = caster:GetIntellect()
	local damage = zl * i * x
	
	local p1 = ParticleManager:CreateParticle( "particles/abilities/xb_ldlh/xb_ldlh_1.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, point )
	ParticleManager:SetParticleControl( p1, 1, Vector(radius,0,0) )

	if caster.ysqq_baseHeal == nil then
		caster.ysqq_baseHeal = 0
	end
	if caster.ysqq_heal == nil then
		caster.ysqq_heal = 0
	end
	local baseHeal2 = baseHeal + caster.ysqq_baseHeal
	heal = (zl * (i+caster.ysqq_heal) + baseHeal2 ) * x


		
	

	TimerUtil.createTimer(function ()
		if duration > 0 then
			local units = FindAlliesInRadiusEx(caster,point,radius)
			for key, unit in pairs(units) do	
				unit:Heal(heal,caster)
			end
			duration = duration - interval
			return interval
		else --打击结束以后，销毁雷云特效(这个特效并不会自动消失)。如果可以触发多重效果，就触发
			ParticleManager:DestroyParticle(p1,false)
		end
	end)


	


end









--天玄破神荒
function txpsh( keys )
	local caster = keys.caster
	local ability = keys.ability
	local level = ability:GetLevel() - 1
	local radius = keys.ability:GetLevelSpecialValueFor("radius", level)
	local radius2 = keys.ability:GetLevelSpecialValueFor("radius2", level)
	local i = keys.ability:GetLevelSpecialValueFor("i", level)	
	local count = keys.ability:GetLevelSpecialValueFor( "count", level )
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local interval = 0.1
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point = keys.target_points[1]
	local caster_point=caster:GetAbsOrigin()
	if caster.txpsh_baseDamage == nil then
		caster.txpsh_baseDamage = 0
	end
	if caster.txpsh_damage == nil then
		caster.txpsh_damage = 0
	end
	if caster.txpsh_count == nil then
		caster.txpsh_count = 0
	end
	if caster.txpsh_multiple == nil then
		caster.txpsh_multiple = 0
	end
	count = count + caster.txpsh_count --获取打击次数
	local time = count * interval /4  --总时间
	local zl = caster:GetIntellect()
	local baseDamage2 = baseDamage + caster.txpsh_baseDamage
	i = i + caster.txpsh_damage
	local damage = (zl * i + baseDamage2 ) * x * 1.4

	--============================================================================特效部分
	local p1 = ParticleManager:CreateParticle( "particles/abilities/xb_yunshi/yunshi_ground.vpcf", PATTACH_ABSORIGIN, caster )
	ParticleManager:SetParticleControl( p1, 0, point )
	ParticleManager:SetParticleControl( p1, 1, Vector(radius,radius,radius-30) )--三个数字分别对应地面三个圈的半径(最外面的，最里面的，中间的）




	--坠落火焰特效
	local start_time = GameRules:GetGameTime() --开始的时间
	TimerUtil.createTimerWithDelay(0.05, function()
		local now_time = GameRules:GetGameTime()--现在的时间
		if now_time - start_time >= time then
			ParticleManager:DestroyParticle(p1,false)
			return nil
		end
		for i=1,4 do --控制火焰数量，不建议太多
			local p2 = ParticleManager:CreateParticle( "particles/abilities/xb_yunshi/yunshi_attack.vpcf", PATTACH_ABSORIGIN, caster )
			local randompoint = FindRandomPoint(point,radius)
			ParticleManager:SetParticleControl( p2, 0, randompoint )
			TimerUtil.createTimerWithDelay(0.3, function()
			local units = FindAlliesInRadiusExdd(caster,randompoint,radius2)
			local multiple = 1
			if RollPercentage(20) then
				multiple = caster.txpsh_multiple + multiple
			end	
			local damage2 = damage * multiple	
			if units ~= nil then
				for key, unit in pairs(units) do
				ApplyDamageEx(caster,unit,ability,damage2)
				--添加眩晕效果
				if RollPercentage(30) then
					ability:ApplyDataDrivenModifier(caster, unit, "modifier_zljcjn_txpsh", {})
				end
				end
			end	
			end)
		end
		return interval
	end)
	--=============================================================================================

	


	caster:EmitSound("Hero_Invoker.ChaosMeteor.Impact")






end







