function sjylzj( keys )
	
	local caster = keys.caster
	local ability = keys.ability
	local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
	local i = keys.ability:GetLevelSpecialValueFor("i", keys.ability:GetLevel() - 1)	
	local attackTimes = keys.ability:GetLevelSpecialValueFor("dajicishu", keys.ability:GetLevel() - 1)	
	local level = ability:GetLevel() - 1
	local baseDamage = keys.ability:GetLevelSpecialValueFor("baseDamage", level)	
	local x = 1 + (level+caster.cas_table.grjndj) / 10
	local point=caster:GetAbsOrigin()

	if caster.sjylzj_baseDamage == nil then
		caster.sjylzj_baseDamage = 0
	end
	if caster.sjylzj_damage == nil then
		caster.sjylzj_damage = 0
	end
	if caster.sjylzj_count == nil then
		caster.sjylzj_count = 0
	end
	if caster.sjylzj_multiple == nil then
		caster.sjylzj_multiple = 0
	end	

	local mj = caster:GetAgility()
	local baseDamage2 = baseDamage + caster.sjylzj_baseDamage
	i = i + caster.sjylzj_damage
	local damage = (mj * i + baseDamage2 ) * x * 1.6
	attackTimes = attackTimes + caster.sjylzj_count
	local attackInterval = 0.1 --雷电打击间隔
	local modifier = "modifier_mjjcjn_sjylzj" --施法期间的buff，主要用来限制角色的运动，提供回血等。
	local modifier_duration = attackInterval * attackTimes /5 --buff持续时间，同步打击时间
	--添加buff
	ability:ApplyDataDrivenModifier(caster, caster, modifier, {duration=modifier_duration})


	Thunder_Damage(ability,caster,point,damage,attackTimes,attackInterval,radius)

	local fxIndex = ParticleManager:CreateParticle( "particles/test/lxq_txb_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, caster )
	TimerUtil.createTimerWithDelay(modifier_duration,function()
		ParticleManager:DestroyParticle(fxIndex,false)
	end)
end



---神剑御雷真诀的雷电效果和伤害效果
function Thunder_Damage(ability,hero,castPoint,thunderDamage,attackTimes,attackInterval,radius)
	StartSoundEventFromPosition("CNY_Beast.GodsWrath.Target",castPoint) --技能开始的打雷声音
	local radius = radius 
	-- 雷云特效：控制点3控制云的浓度，控制点4控制云的半径，128的浓度大概对应400范围。
	local cloud = ParticleManager:CreateParticle( "particles/test/lxq_storm.vpcf", PATTACH_CUSTOMORIGIN, hero )
	ParticleManager:SetParticleControl( cloud, 0, castPoint )
	ParticleManager:SetParticleControl( cloud, 3, Vector(radius/3,0,0) )
	ParticleManager:SetParticleControl( cloud, 4, Vector(radius,0,0) )
	--随机打击玩家附近的单位
	local totalTimes = attackTimes; --使用临时变量存储，否则在随机到下一次的时候会有问题
	TimerUtil.createTimer(function ()
		if totalTimes > 0 then
			--每次打击伤害300范围的单位
			--创建闪电特效，控制点0控制落雷起始点，控制点1控制落雷结束点。
			for i=1,5 do
				local point = castPoint + Vector(RandomInt(-1*radius, radius), RandomInt(-1*radius, radius), 512)
				local point2 = Vector(point.x,point.y,point.z-512)
				local multiple = 1
				if RollPercentage(20) then
					multiple = hero.sjylzj_multiple + multiple
				end	
				local damage2 = thunderDamage* multiple
				DamageEnemiesWithinRadius(point2,200,hero,damage2)
				local particle = ParticleManager:CreateParticle( "particles/test/lxq_thunder.vpcf", PATTACH_CUSTOMORIGIN, hero )
				--ParticleManager:SetParticleControl( particle, 0, Vector(hero:GetAbsOrigin().x,hero:GetAbsOrigin().y,hero:GetAbsOrigin().z +512)) --两种表现方式
				totalTimes = totalTimes - 1
				ParticleManager:SetParticleControl( particle, 0, point)
				ParticleManager:SetParticleControl( particle, 1, point2)
				if RollPercentage(50) then
					StartSoundEventFromPosition("Hero_Zuus.ProjectileImpact",point2)--这个是宙斯攻击命中时候的声音，模拟雷击地面声音
				end
			end
			
			

			return attackInterval
		else --打击结束以后，销毁雷云特效(这个特效并不会自动消失)。如果可以触发多重效果，就触发
			ParticleManager:DestroyParticle(cloud,true)
		--	if multiple and RandomLessFloat(30) then
		--		print("cfdc")
			--	Thunder_Damage(ability,hero,castPoint,thunderDamage,attackTimes,attackInterval,multiple)
		--	end
			
		end
	end)
end



