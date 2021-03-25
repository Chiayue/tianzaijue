---分裂攻击。
--攻击顺序正常情况下：start(s)---attack(a)---landed(l)---finished(f)。
--如果攻击动作没有完成就被取消了，则会提前进入finished
--比如，投射物发出去了，但是动作没完被s住了，顺序就是s-a-f-l
--或者投射物还没有出去就被s住了，就会是s-f
--当攻击击中但是被闪避的时候触发faild事件
function SplitAttackStart(keys)
	local caster = keys.caster
	
	if caster._SplitAttackStart then
		return;
	end
	local ability = keys.ability
	local target = keys.target
	--记录一下技能，在其他逻辑中使用
	if not caster._SplitAttackAbility then
		caster._SplitAttackAbility = keys.ability
	end
	
	local count = GetAbilitySpecialValueByLevel(ability,"count")
	print(count)
	if count and count > 1 then
		--默认count代表的是攻击总数量，普通攻击已经有一个了，这里额外攻击数量少一个即可
		count = count - 1
	
		local radius = caster:Script_GetAttackRange()
		local projectile = caster:GetRangedProjectileName()
		local speed = caster:GetProjectileSpeed()
		
		local enemies = FindEnemiesInRadiusEx(caster,caster:GetAbsOrigin(),radius,DOTA_UNIT_TARGET_FLAG_NO_INVIS,FIND_CLOSEST)
		if enemies then
			for key, unit in pairs(enemies) do
				if unit ~= target then
					---调用PerformAttack会触发modifier的OnAttack事件，从而导致重复进入这个函数，
					--出现死循环。所以这里加一个标记
					caster._SplitAttackStart = true
					pcall(function()
						--倒数第二个参数：bFakeAttack如果为true，则不会造成伤害
						--第三个参数如果为false，则会触发OnAttack事件，但是不会触发其余的几个事件（start、land、finish），这样有些攻击命中才生效的逻辑就不会触发了
						--PerformAttack(handle hTarget, bool bUseCastAttackOrb, bool bProcessProcs, bool bSkipCooldown, bool bIgnoreInvis, bool bUseProjectile, bool bFakeAttack, bool bNeverMiss)
						caster:PerformAttack(unit,true,true,true,true,true,false,false)
					end)
					caster._SplitAttackStart = false
					
					count = count - 1
					if count == 0 then
						break;
					end
				end
			end
		end
	end
end

---弹射攻击开始，不造成伤害
function BounceAttackStart(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	--有投射物的单位才能出发弹射攻击
	local projectile = keys.projectile or caster:GetRangedProjectileName()
	if projectile then
		local speed = keys.speed or caster:GetProjectileSpeed()
		if speed <= 0 then
			return;
		end
		
		--每次都单独创建一个单位，以保证每次的攻击信息都单独保存
		local bounceUnit = CreateUnitByName( "npc_dummy_unit", target:GetAbsOrigin(), false, caster, caster, caster:GetTeamNumber() )
		local bonuceAbility = bounceUnit:AddAbility("basic_BounceAttack")
		
		bounceUnit.ability = ability
		bounceUnit.projectile = projectile
		bounceUnit.speed = speed
		bounceUnit.radius = GetAbilitySpecialValueByLevel(ability,"radius")
		bounceUnit.reduce = (GetAbilitySpecialValueByLevel(ability,"reduce") or 0) / 100
		bounceUnit.count = GetAbilitySpecialValueByLevel(ability,"count")
		
		bounceUnit.source = target
		bounceUnit.target = nil
		
		local damage = GetAbilitySpecialValueByLevel(ability,"damage")
		if not damage or damage == 0 then
			damage = caster:GetAttackDamage()
		end
		bounceUnit.damage = damage
		bounceUnit.bounced = 0
		
		local enemies = FindEnemiesInRadiusEx(bounceUnit,bounceUnit:GetAbsOrigin(),bounceUnit.radius,DOTA_UNIT_TARGET_FLAG_NO_INVIS)
		if not enemies or #enemies == 0 then
			EntityHelper.remove(bounceUnit)
		else
			bounceUnit.target = enemies[1]
			bounceUnit.bounced = bounceUnit.bounced + 1
			
			local data = {
		        Target = bounceUnit.target,
		        Source = bounceUnit.source,
		        EffectName = bounceUnit.projectile,
		        Ability = bonuceAbility,
		        bDodgeable = false,
		        bProvidesVision = false,
		        iMoveSpeed = bounceUnit.speed,
		        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
	    	}
	    	ProjectileManager:CreateTrackingProjectile( data )
		end
	
	end
end
---弹射攻击命中单位。属于投射物命中，不触发攻击命中事件
function BounceAttackLanded(keys)
	local dummyUnit = keys.caster
	local ability = keys.ability
	local target = keys.target
	local targetPos = target:GetAbsOrigin()
	
	--伤害衰减
	dummyUnit.damage = dummyUnit.damage * (1 + dummyUnit.reduce)
	ApplyDamageEx(dummyUnit:GetOwner(),target,dummyUnit.ability,dummyUnit.damage)

	-- If we exceeded the bounce limit then remove the dummy and stop the function
	if dummyUnit.bounced >= dummyUnit.count then
		EntityHelper.remove(dummyUnit)
		return
	end
	
	local enemies = FindEnemiesInRadiusEx(dummyUnit,targetPos,dummyUnit.radius,DOTA_UNIT_TARGET_FLAG_NO_INVIS)
	if not enemies or #enemies == 0 then
		EntityHelper.remove(dummyUnit)
	else
		dummyUnit.source = dummyUnit.target
		--重新随机目标单位
		for key, unit in pairs(enemies) do
			if dummyUnit.target ~= unit then
				dummyUnit.target = unit
				break;
			end
		end
		
		dummyUnit.bounced = dummyUnit.bounced + 1
		
		local data = {
	        Target = dummyUnit.target,
	        Source = dummyUnit.source,
	        EffectName = dummyUnit.projectile,
	        Ability = ability,
	        bDodgeable = false,
	        bProvidesVision = false,
	        iMoveSpeed = dummyUnit.speed,
	        iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1
    	}
    	ProjectileManager:CreateTrackingProjectile( data )
	end
end


---移除同一个技能所产生的所有的同名buff，主要用来移除可重复类的buff，因为会创建多个实例，用普通的移除，只能移除掉一个
function RemoveModifiersByName(keys)
	local ability = keys.ability
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end
	
	local modifierName = keys.modifier
	if type(modifierName) == "string" then
		local all = target:FindAllModifiersByName(modifierName)
		if all and #all > 0 then
			for key, modifier in pairs(all) do
				if modifier:GetAbility() == ability then
					modifier:Destroy()
				end
			end
		end
	end
end

---增加modifier的叠加层数。
--区分可重复和可叠加：
--1、重复是同一个名字的buff，添加不同的实例，各个实例的持续时间相互独立
--2、叠加是只有一个buff实例，设置其叠加层数，只有一个buff，
--所以不存在各层持续时间独立的说法，时间到了无论有几层，buff都消失。
--除非再给该buff设置持续时间。同时，有一些属性效果，设置叠加层数的时候，会叠加效果，而有一些则不会进行叠加
--
--这个可以理解为，所有层数共享一个持续时间。要分开计算持续时间，用下面的Multiple类型的。
--
--keys需要有：
--modifier，要叠加的buff名字，如果没有该buff，将添加buff，并设置叠加层数为count
--count，要叠加的层数，可正可负数。如果为空，则默认叠加1层
--duration，可为空，不为空时会刷新modifier的持续时间。如果modifier的持续时间结束，则无论叠加多少层，都会被移除掉
--max，可为空，不为空的时候代表最大叠加层数
--kill,如果是击杀逻辑，并且击杀的单位就是施法者本身，则不处理。
--主要用在某些杀死单位后给施法者叠加buff的场景中。因为收回单位的时候也会进入杀死的逻辑，这种要排除掉，就标记kill为1即可，如果不需要排除，不加kill参数就行了
function IncreaseModifierStack(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = caster
		--如果是击杀逻辑，并且击杀的单位就是施法者本身，则不处理
		if keys.kill and keys.unit == caster then
			return;
		end
	end

	local modifierName = keys.modifier
	if modifierName then
		local count = keys.count or 1
		--这里没有判断modifier的来源技能，即认为同一个单位的不同实体之间，也可以叠加效果。
		--比如秦羽的金刑功能减甲，两个秦羽的话，虽然只有一个debuff，但是两个人的攻击都会使这个效果叠加
		local modifier = target:FindModifierByName(modifierName)
		if not modifier and count > 0 then
			modifier = AddDataDrivenModifier(ability,caster,target,modifierName,{})
		end
		if modifier then
			local value = modifier:GetStackCount() + count
			if keys.max then
				value = math.min(value,keys.max)
			end
			modifier:SetStackCount(value)
			
			local duration = keys.duration
			if duration then
				modifier:SetDuration(duration,true)
			end
		end
	end
end

---对于可重复的modifier，各个buff的持续时间是独立计算，并且会在单位上添加不同的buff图标。
--为了统一图标，优化显示效果，用一个隐藏的的modifier A来做时间控制，并承载buff实际效果，隐藏掉
--(用interval逻辑来降低叠加层数，不能用可重复的buff，会崩溃；用interval会导致减少的速度跟不上叠加的速度，还是要用可重复buff。。。崩溃问题再说)，
--然后添加一个modifier B里面，并用于显示效果。
--每次添加的时候，添加可重复的A，在A创建的时候，刷新B的叠加层数和持续时间，当A结束的时候，减少B的层数和持续时间。
--当B的层数>=2时，无论增加或者减少层数，都将B设置为没有duration的（客户端不会转圈），当层数剩下1层的时候，才显示剩余的持续时间。
--当叠加层数=0时，直接移除buff
--
--这个和DecreaseMultipleModifierStack对应，是增加的逻辑
--
--keys:
--modifier:B的名字
--duration:buff持续时间
function IncreaseMultipleModifierStack(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = caster
	end

	local modifierName = keys.modifier
	if modifierName then
		local modifier = target:FindModifierByName(modifierName)
		if not modifier then
			modifier = AddDataDrivenModifier(ability,caster,target,modifierName,{})
		elseif EntityIsNull(modifier:GetAbility()) then
			--这个主要解决同一个人物存在两个单位的情况，当其中一个先添加了buff，但是该单位被移除掉后，modifier应该以新的单位的技能为准。
			--否则会出现虽然叠加了层数，但是没有效果的问题。
			local count = modifier:GetStackCount()
			local refreshTime = modifier.refreshTime
			modifier:Destroy()
			modifier = nil
			--以新单位技能为准重新添加buff，并且设置叠加层数为之前的
			if EntityNotNull(ability) then
				modifier = AddDataDrivenModifier(ability,caster,target,modifierName,{})
				if modifier then
					modifier.refreshTime = refreshTime
					modifier:SetStackCount(count)
				end
			end
		end
		if modifier then
			local count = modifier:GetStackCount() + 1
			modifier:SetStackCount(count)
			local duration = keys.duration
			if duration then
				if count >= 2 then
					---超过2层的时候，不显示计时效果，因为不准确，就算设置了持续时间，也很可能出错，
					--因为有持续时间的话，持续时间结束后将会销毁这个buff，从而导致叠加的层数丢失。
					--但是记录刷新时间，方便在最后一层的时候，显示一个相对准确的剩余时间
					if modifier:GetDuration() >= 0 then
						modifier:SetDuration(-1,true)
					end
					modifier.refreshTime = GameRules:GetGameTime()
				elseif count == 1 then
					--计算剩余时间
					if modifier.refreshTime then
						duration = duration - (GameRules:GetGameTime() - modifier.refreshTime)
					end
					modifier:SetDuration(duration,true)
				end
			end
		end
	end
end

---对于可重复的modifier，各个buff的持续时间是独立计算，并且会在单位上添加不同的buff图标。
--为了统一图标，优化显示效果，用一个隐藏的可重复的modifier A来做时间控制，然后将buff效果做在一个单独的可叠加的modifier B里面，并用于显示效果。
--每次添加的时候，添加可重复的A，在A创建的时候，刷新B的叠加层数和持续时间，当A结束的时候，减少B的层数和持续时间。
--当B的层数>=2时，无论增加或者减少层数，都将B设置为没有duration的（客户端不会转圈），当层数剩下1层的时候，才显示剩余的持续时间。
--当叠加层数=0时，直接移除buff
--
--这个和IncreaseMultipleModifierStack对应，是减少的时候调用的逻辑，单独调用没有意义
--keys:
--modifier:B的名字
--duration:buff持续时间
function DecreaseMultipleModifierStack(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = caster
	end

	local modifierName = keys.modifier
	if modifierName then
		local modifier = target:FindModifierByName(modifierName)
		if modifier then
--			if EntityIsNull(ability) then
--				print("ability nil")
--			end
		
			local count = modifier:GetStackCount() - 1
			modifier:SetStackCount(count)
			
			local duration = keys.duration
			if duration then
				if count == 1 then
					--计算剩余时间
					if modifier.refreshTime then
						duration = duration - (GameRules:GetGameTime() - modifier.refreshTime)
					end
					modifier:SetDuration(duration,true)
				elseif count == 0 then
					modifier:Destroy();
				end
			end
		end
	end
end

---添加一个lua modifier。删除可以用RemoveModifiersByName
--keys：
--modifier：要添加到buff名字，必须先注册。输入伤害：modifier_multiple_damage_in
--duration：持续时间，可有可无。如果没有的话，要考虑如何进行移除
--count:如果目标是一群单位，可以指定数量。如果不指定，将给所有单位添加buff，否则只添加指定数量的
function add_lua_modifier(keys)
	if type(keys.modifier) == "string" then
		local ability = keys.ability
		local caster = keys.caster
		
		--批量的
		if keys.target_entities then
			local count = keys.count
			for key, target in pairs(keys.target_entities) do
				if not count then
					AddLuaModifier(caster,target,keys.modifier,{duration=keys.duration},ability)
				elseif count > 0 then
					AddLuaModifier(caster,target,keys.modifier,{duration=keys.duration},ability)
					count = count - 1
				else
					break;
				end
			end
		else
			local target = keys.target
			if keys.Target and keys.Target == "CASTER" then
				target = caster
			end
			AddLuaModifier(caster,target,keys.modifier,{duration=keys.duration},ability)
		end
	end
end

---陷阱类技能施法（类似一个kv的thinker类buff，是永久存在的）
--在指定点创建一个虚拟单位，给单位赋予光环效果，永久存在，直到释放可释放数量达到最大数量以后又释放新的
function traps_ability_spell(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	--标记是一个陷阱类技能，在默认的ai中只会释放一次，不会重复释放
	ability.td_is_trap = true
	
	local aura = keys.aura
	if keys.target_points and aura then
		local point = keys.target_points[1]
	
		local dummyUnits = ability.dummyUnits
		if not dummyUnits then
			dummyUnits = {}
			ability.dummyUnits = dummyUnits
		end
		
		local maxCount = GetAbilitySpecialValueByLevel(ability,"count")
		if #dummyUnits == maxCount then
			EntityHelper.kill(dummyUnits[1],true)
			table.remove(dummyUnits,1)
		end
		local dummy = CreateDummyUnit(point,caster)
		AddDataDrivenModifier(ability,caster,dummy,aura,{})
		table.insert(dummyUnits,dummy)
		
		local tooltip = keys.tooltip
		if tooltip then
			local modifier = caster:FindModifierByName(tooltip)
			modifier:SetStackCount(maxCount - #dummyUnits)
		end
	else
		DebugPrint("check if ability TARGET and key AURA exist")
	end
end

---陷阱类技能升级，增加能量点数
function traps_ability_upgrade(keys)
	local ability = keys.ability
	local caster = keys.caster
	local tooltip = keys.tooltip
	
	if tooltip then
		local dummyUnits = ability.dummyUnits
		if not dummyUnits then
			dummyUnits = {}
			ability.dummyUnits = dummyUnits
		end
		
		local maxCount = GetAbilitySpecialValueByLevel(ability,"count")
		local modifier = caster:FindModifierByName(tooltip)
		if modifier then
			modifier:SetStackCount(maxCount - #dummyUnits)
		end
	end
end

---陷阱类技能，当塔被收回的时候，销毁掉所有陷阱虚拟单位
function traps_ability_destroy(keys)
	local ability = keys.ability
	local dummyUnits = ability.dummyUnits
	if dummyUnits then
		ClearUnitArray(dummyUnits)
	end
end

---在给定位置（Target决定，包括：caster。target（默认）。point）创建一个有持续时间的虚拟单位（区别陷阱）。
--KV的createThinker不能用，经常会导致游戏闪退。所以用这个逻辑来实现
--keys需要：
--modifier:要添加给dummy的modifier
--duration：该modifier的持续时间
function CreateThinkerEx(keys)
	local ability = keys.ability
	local caster = keys.caster
	local point = nil
	
	if keys.target then
		point = keys.target:GetAbsOrigin()
	end
	if keys.Target then
		if keys.Target == "CASTER" then
			point = caster:GetAbsOrigin()
		elseif keys.Target == "POINT" then
			point = keys.target_points[1]
		end
	end
	
	local modifier = keys.modifier
	local duration = keys.duration
	if point and type(modifier) == "string" and type(duration) == "number" then
		local dummy = CreateDummyUnit(point,caster)
		ability._dummy = dummy
		AddDataDrivenModifier(ability,caster,dummy,modifier,{duration=duration})
		TimerUtil.createTimerWithDelay(duration,function()
			EntityHelper.kill(dummy,true)
			ability._dummy = nil
		end)
	end
end

---将CreateThinkerEx创建的虚拟单位销毁掉。
--主要用在塔被收回的时候，立刻销毁对应的效果
function CreateThinkerEx_Destroy(keys)
	local ability = keys.ability
	if ability._dummy then
		EntityHelper.kill(ability._dummy,true)
		ability._dummy = nil
	end
end

---基于攻击力和单位等级对目标造成伤害
function damage_based_level_and_attack(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	--额外的伤害系数
	local ratio = GetAbilitySpecialValueByLevel(ability,"ratio")
	if not ratio or ratio == 0 then
		ratio = 1
	end
	
	local damage = caster:GetAverageTrueAttackDamage(target) * ratio
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	--ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
end

---基于攻击力的暴击范围性伤害
function damage_based_damage_and_attack(keys)
	local caster = keys.caster
	local ability = keys.ability
	local target = keys.target
	
	--额外的暴击系数
	local ratio = GetAbilitySpecialValueByLevel(ability,"ratio")


	local damage = caster:GetAverageTrueAttackDamage(target) * ratio
	ApplyDamageEx(caster,target,ability,damage)
	--显示一个特殊效果
	--ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
end


---基于最大生命值百分比的伤害
function damage_based_max_health(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	local ratio = keys.ratio
	
	if type(ratio) == "number" then
		local damage = target:GetMaxHealth() * ratio / 100
		
		--无尽怪，排除减伤影响，只计算护甲
		if target._infinite_real_damage_ratio then
			damage = damage / target._infinite_real_damage_ratio
		end
		
		ApplyDamageEx(caster,target,ability,damage)		
	end
end

---基于当前生命值百分比的伤害
function damage_based_current_health(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	local ratio = keys.ratio
	
	if type(ratio) == "number" then
		local damage = target:GetHealth() * ratio / 100
		ApplyDamageEx(caster,target,ability,damage)		
	end
end

---当单位没有某个buff的时候才添加一个特定buff。
--比如用添加A（一个特殊效果，比如眩晕）需要单位没有B（用来记录该效果的内置冷却时间）
--就可以使用这个。如果Target被指定为CASTER，则buff拥有者为caster，否则默认为target
--keys:
--a:要添加的buff（有持续时间的话，需要在kv中填写，这里不处理）
--b:需要检查是否存在的buff
function apply_modifier_without_other(keys)
	if type(keys.a) == "string" and type(keys.b) == "string" then
		local ability = keys.ability
		local caster = keys.caster
		local target = keys.target
		
		if keys.Target and keys.Target == "CASTER" then
			target = caster
		end
		
		local a = keys.a
		local b = keys.b
		
		if not target:HasModifier(b) then
			AddDataDrivenModifier(ability,caster,target,a,{})
		end
	end
end

---添加一个伤害加深的buff。隐藏的，效果根据技能的ratio决定。
--keys有duration的话，就创建指定的duration。
--没有持续时间又需要移除，则调用remove_damage_out_buff
--keys:
--stack=1,如果有，则对于已经存在的buff，会叠加stack层
--duration=123，如果有，当已经存在buff的时候会刷新持续时间
--key，唯一标识，不能为空，同标识的效果不同时存在，删除的时候也会用到（如果默认用ability去获取技能名字，在删除的时候会找不到ability而出错），一般写技能名字即可。
function apply_damage_out_buff(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local duration = keys.duration
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	if keys.Target and keys.Target == "CASTER" then
		target = caster
	end
	
	--将添加成功的信息缓存在单位身上，方便移除。缓存在单位身上也最稳定，只要单位不死，就肯定会获取到。如果单位死了，那获取不到也无所谓了
	local key = "do_"..uniqueKey
	if EntityIsNull(target[key]) then
		target[key] = AddLuaModifier(caster,target,"modifier_multiple_damage_out",{duration=duration},ability)
		if target[key] and keys.stack then
			target[key]:SetStackCount(keys.stack)
		end
	else
		local modifier = target[key]
		if duration then--已经存在的，刷新持续时间
			modifier:SetDuration(duration,true)
		end
		if keys.stack then
			modifier:SetStackCount(keys.stack + modifier:GetStackCount())
		end
	end
end

---删掉当前技能所添加的伤害加深buff
--keys:
--key，唯一标识，不能为空，同标识的效果不同时存在，删除的时候也会用到（如果默认用ability去获取技能名字，在删除的时候会找不到ability而出错），一般写技能名字即可。
function remove_damage_out_buff(keys)
	local ability = keys.ability
	local target = keys.target
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end

	local key = "do_"..uniqueKey
	if target[key] then
		if EntityNotNull(target[key]) then
			target[key]:Destroy()
		end
		target[key] = nil
	end
end

---添加一个受到伤害加深的buff。隐藏的，效果根据技能的ratio决定。
--keys：
--duration，有的话，就创建指定的duration。没有持续时间又需要移除，则调用remove_damage_in_buff
--key，唯一标识，不能为空，同标识的效果不同时存在，删除的时候也会用到（如果默认用ability去获取技能名字，在删除的时候会找不到ability而出错），一般写技能名字即可。
function apply_damage_in_buff(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local duration = keys.duration
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	if keys.Target and keys.Target == "CASTER" then
		target = caster
	end
	
	--将添加成功的信息缓存在单位身上，方便移除。缓存在单位身上也最稳定，只要单位不死，就肯定会获取到。如果单位死了，那获取不到也无所谓了
	local key = "di_"..uniqueKey
	if EntityIsNull(target[key]) then
		target[key] = AddLuaModifier(caster,target,"modifier_multiple_damage_in",{duration=duration},ability)
	elseif duration then--已经存在的，刷新持续时间
		target[key]:SetDuration(duration,true)
	end
end

---删掉当前技能所添加的所有伤害加深buff
function remove_damage_in_buff(keys)
	local ability = keys.ability
	local target = keys.target
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end

	local key = "di_"..uniqueKey
	if target[key] then
		if EntityNotNull(target[key]) then
			target[key]:Destroy()
		end
		target[key] = nil
	end
end

---批量添加修饰器。单位类型必须是GroupUnits
--keys:
--modifier:要添加的修饰器，必有。持续时间在buff的KV中设置，这里不处理
--count:要添加的数量，有就限制数量，没有就给所有都添加
function ApplyModifierToTargets(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	local targets = keys.target_entities
	local modifier = keys.modifier
	local count = keys.count
	if targets and modifier then
		if not count then
			count = #targets
		end
		
		for key, target in pairs(targets) do
			if count > 0 then
				AddDataDrivenModifier(ability,caster,target,modifier,{})
				count = count -1;
			else
				break;
			end
		end
	end
end

---多重攻击（连着攻击多次，类似蚂蚁的连击），和分裂箭攻击有些冲突。
function MultipleAttack(keys)
	local caster = keys.caster
	if caster._MultipleAttack then
		return
	end
	local ability = keys.ability
	local target = keys.target
	
	local count = GetAbilitySpecialValueByLevel(ability,"count")
	TimerUtil.createTimerWithDelay(0.03,function()
		if count > 0 then
			---调用PerformAttack会触发modifier的OnAttack事件，从而导致重复进入这个函数，
			--出现死循环。所以这里加一个标记
			caster._MultipleAttack = true
			caster:PerformAttack(target,true, true,true,true,true,false,false)	
			caster._MultipleAttack = false
			
			count = count - 1
			return 0.03
		end
	end)
end



---设置当前技能的冷去时间
function set_ability_cooldown_duration(keys)
	local ability = keys.ability
	local duration = keys.duration
	
	if type(duration) == "number" then
		if duration > 0 then
			ability:StartCooldown(duration)
		elseif duration == 0 then
			ability:EndCooldown()
		end
	end
end

---固定攻击次数后触发某种效果
--keys：
--stack：用来叠加以记录次数的buff，不可为空
--modifier：达到最大次数时，添加给目标的buff，不可为空
--max：触发效果的攻击次数，比如5，就表示第五次攻击触发效果。
function act_after_several_attack(keys)
	local ability = keys.ability
	local caster = keys.caster
	
	local stackModifier = keys.stack
	local modifierName = keys.modifier
	local maxCount = keys.max
	
	if stackModifier and modifierName and type(maxCount) == "number" then
		local modifier = caster:FindModifierByName(stackModifier)
		if modifier:GetStackCount() < maxCount - 1 then
			modifier:IncrementStackCount()
		else
			modifier:SetStackCount(0)
			
			local target = keys.target
			if keys.Target and keys.Target == "CASTER" then
				target = caster
			end
			
			AddDataDrivenModifier(ability,caster,target,modifierName,{})
		end
	end
end


---清除掉所有的debuff。这个debuff必须是可净化的才行
function PurgeAllDebuff(keys)
	if keys.target_entities then
		for _, unit in pairs(keys.target_entities) do
			PurgeUnit(unit,false,true,false,true,true)
		end
	else
		local target = keys.target
		if keys.Target and keys.Target == "CASTER" then
			target = keys.caster
		end
		PurgeUnit(target,false,true,false,true,true)
	end
end

function StopSound(keys)
	local target = keys.target
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end
	
	if target and keys.sound then
		StopSoundOnEntity(target,keys.sound)
	end
end

---杀死目标单位，默认情况下不对boss和精英怪生效。如果需要强制杀死这些单位，则在keys中添加force = true这个参数
--keys:
--force:强制杀死单位，无论是不是boss或者精英怪
--hideHint:当目标只有一个的话，如果是精英怪或者boss默认会给出提示，如果不需要，则添加这个参数即可
function KillTarget(keys)
	local ability = keys.ability
	local caster = keys.caster

	if keys.target_entities then
		for key, unit in pairs(keys.target_entities) do
			if keys.force then
				unit:Kill(ability,caster)
			elseif not unit.TD_IsBoss and not unit.TD_IsSpecial then
				--既不是boss也不是精英怪才生效
				unit:Kill(ability,caster)
			end
		end
	elseif keys.target then
		local target = keys.target
		if keys.force then
			target:Kill(ability,caster)
		elseif not target.TD_IsBoss and not target.TD_IsSpecial then
			target:Kill(ability,caster)
		else
			if not keys.hideHint then
				NotifyUtil.ShowError(PlayerUtil.GetOwnerID(caster),"#error_can_not_use_on_unit")
			end
			if ability:GetManaCost(ability:GetLevel() - 1) > 0 then
				ability:RefundManaCost()
			end
			if ability:GetCooldownTimeRemaining() > 0 then
				ability:EndCooldown()
			end
		end
	end
end

---在单位头顶显示一个额外伤害的特效，主要用在额外伤害、毒伤之类的效果里，特殊显示一下，就不要别的特效了
function PopUpExtraDamage(keys)
	local target = keys.target
	local damage = keys.damage
	
	if target and damage then
		ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
	end
end


---增加基于最大恢复数值百分比的回血，比如原来是1000点回血速度（包含基础的和通过其他buff增加的），要增加10%，就变成1100.减少10%就变成900.
--变化系数要通过技能去获取（键值key：ratio），并且同一个技能只会有一个效果（即同名技能不叠加系数）。
--变化系数：可正可负。百分比值(比如增加10%,ratio就是10)。不同技能的效果线性叠加
function AddPercentHealRegenBasedTotalRegen(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end

	local modifier = target:FindModifierByName("td_total_percent_health_regen")
	if not modifier then
		modifier = AddLuaModifier(target,target,"td_total_percent_health_regen",{})--不传caster和ability，这个是所有技能公用的。只有一个
	end
	--同名技能只有一个会生效
	if modifier then
		local allAbility = modifier._abilities
		if not allAbility then
			allAbility = {}
			modifier._abilities = allAbility
		end
		if not allAbility[uniqueKey] then
			allAbility[uniqueKey] = ability
		end
	end
end

---移除某个技能增加的百分比回血。对应AddPercentHealRegenBasedTotalRegen
function RemovePercentHealRegenBasedTotalRegen(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end

	local modifier = target:FindModifierByName("td_total_percent_health_regen")
	if modifier and modifier._abilities and modifier._abilities[uniqueKey] then
		modifier._abilities[uniqueKey] = nil
	end
end

---百分比增加击杀怪物获得金币。同名技能效果不叠加
--技能中需要有键值 ratio代表百分比
function AddGoldGainRatio(keys)
	local ability = keys.ability
	local caster = keys.caster
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	--buff添加到英雄身上。这样在过滤器中才能获取到
	local hero = PlayerUtil.GetHero(caster)
	if hero then
		--将添加成功的信息缓存在单位身上，方便移除。缓存在单位身上也最稳定，只要单位不死，就肯定会获取到。如果单位死了，那获取不到也无所谓了
		local key = "gold_gain_ratio_"..uniqueKey
		if EntityIsNull(hero[key]) then
			hero[key] = AddLuaModifier(caster,hero,"td_multiple_gold_gain_percentage",{},ability)
		end
	end
end


---移除金币加成
function RemoveGoldGainRatio(keys)
	local ability = keys.ability
	local caster = keys.caster
	local uniqueKey = keys.key
	
	if not uniqueKey then
		return;
	elseif type(uniqueKey) ~= "string" then
		uniqueKey = tostring(uniqueKey)
	end
	
	--buff添加到英雄身上。这样在过滤器中才能获取到
	local hero = PlayerUtil.GetHero(caster)
	if hero then
		--将添加成功的信息缓存在单位身上，方便移除。缓存在单位身上也最稳定，只要单位不死，就肯定会获取到。如果单位死了，那获取不到也无所谓了
		local key = "gold_gain_ratio_"..uniqueKey
		if hero[key] then
			if EntityNotNull(hero[key]) then
				hero[key]:Destroy()
			end
			hero[key] = nil
		end
	end
end

---增加攻击距离buff
function AddAttackRangeModifier(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end
	AddLuaModifier(caster,target,"td_multiple_modifier_attack_range",{},ability)
end

---当前技能添加魔耗降低效果
function AddManaCostReduce(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end
	--有蓝的才享受降低魔耗效果
	if target:GetMaxMana() > 0 then
		local modifier = target:FindModifierByName("modifier_mana_cost_reduce")
		if not modifier then
			modifier = AddLuaModifier(caster,target,"modifier_mana_cost_reduce",{})
			if not modifier then
				DebugPrint("AddManaCostReduce:create modifier faild")
				return;
			end
		end
		
		local abilities = modifier._mana_cost_ability
		if not abilities then
			abilities = {}
			modifier._mana_cost_ability = abilities
		end
		table.insert(abilities,ability)
	end
end

---移除当前技能添加的魔耗降低效果
function RemoveManaCostReduce(keys)
	local ability = keys.ability
	local caster = keys.caster
	local target = keys.target
	
	if keys.Target and keys.Target == "CASTER" then
		target = keys.caster
	end
	
	local modifier = target:FindModifierByName("modifier_mana_cost_reduce")
	if modifier and modifier._mana_cost_ability then
		for index, addAbility in pairs(modifier._mana_cost_ability) do
			if addAbility == ability then
				table.remove(modifier._mana_cost_ability,index)
				break;
			end
		end
		--没有任何减蓝耗技能了，则移除掉这个modifier
		if #modifier._mana_cost_ability == 0 then
			modifier:Destroy()
		end
	end
end