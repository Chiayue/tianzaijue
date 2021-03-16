function Spawn(entityKeyValues)
	if not IsServer() then
		return
	end

	if thisEntity == nil then
		return
	end

	Ability2 = thisEntity:FindAbilityByName("nian_2")
	Ability3 = thisEntity:FindAbilityByName("nian_3")
	Ability4 = thisEntity:FindAbilityByName("nian_4")
	Ability5 = thisEntity:FindAbilityByName("nian_5")
	Ability6 = thisEntity:FindAbilityByName("nian_6")
	Ability8 = thisEntity:FindAbilityByName("nian_8")

	bInitAbility = false	-- 是否施放第一次技能
	bEscape = true		-- 满足条件时是否会逃跑
	iRestTime = 5	-- 正常施放技能后的休息时间
	iRageRestTime = 4	-- 狂暴状态下施放后的休息时间
	iRageHealthPct = 80	-- 狂暴血量
	iLowHealthPct = 50	-- 低血量百分比，用来放最后一个技能

	flRandomDistance = 2000	-- 逃跑随机距离
	flNearDistance = 1800	-- 逃跑近距离判断
	bCombo = true	-- 是否接技能

	thisEntity:GameTimer(AI_TIMER_TICK_TIME, Think)
end

function Think()
	if not thisEntity:IsAlive() then return -1 end
	if not thisEntity:HasModifier("modifier_enemy_boss_ai") then return -1 end
	local vCaster = thisEntity:GetAbsOrigin()
	-- 初始放冲撞技能
	if bInitAbility == false then
		bInitAbility = true
		local width = Ability2:GetSpecialValueFor("radius")
		local distance = Ability2:GetSpecialValueFor("distance")
		local vPosition = GetLinearMostTargetsPosition(vCaster, distance, thisEntity:GetTeamNumber(), width, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER)
		ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability2, vPosition)
		return iRestTime
	end
	if thisEntity:GetCurrentActiveAbility() == nil then
		-- 优先级高的技能
		if thisEntity:GetHealthPercent() <= iLowHealthPct then
			if Ability8:IsCooldownReady() then
				if RollPercentage(100) then
					local vBoss = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin()
					local vPosition = vBoss + RandomVector(flRandomDistance)
					for i = 1, 10 do
						if (vPosition - vCaster):Length2D() > flNearDistance then
							break
						else
							vPosition = vBoss + RandomVector(flRandomDistance)
						end
					end
					Ability4.hComboAbility = Ability8
					ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability4, vPosition)
				else
					local tTargets = FindUnitsInRadius(thisEntity:GetTeamNumber(), vCaster, nil, 6000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
					if IsValid(tTargets[1]) then
						ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability8, tTargets[1]:GetAbsOrigin())
						bEscape = true
						return iRageRestTime
					end
				end
			end
		end
		-- 有逃跑先逃跑
		if bEscape == true then
			local tNear = FindUnitsInRadius(thisEntity:GetTeamNumber(), vCaster, nil, 1000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			local tFar = FindUnitsInRadius(thisEntity:GetTeamNumber(), vCaster, nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
			-- 有远程往远程身上跳
			if (#tFar - #tNear) > 0 then
				local hTarget = tFar[1]
				if IsValid(hTarget) then
					-- 抓人优先
					if Ability5:IsCooldownReady() then
						local vPosition = hTarget:GetAbsOrigin() - (hTarget:GetAbsOrigin() - vCaster):Normalized() * (hTarget:GetHullRadius() + thisEntity:GetHullRadius())
						ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability5, vPosition)
					else
						ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability4, hTarget:GetAbsOrigin())
					end
					bEscape = false
					return thisEntity:GetHealthPercent() <= iRageHealthPct and iRageRestTime or iRestTime
				end
			else
				if RollPercentage(50) then
					local vBoss = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin()
					local vPosition = vBoss + RandomVector(flRandomDistance)
					for i = 1, 10 do
						if (vPosition - vCaster):Length2D() > flNearDistance then
							break
						else
							vPosition = vBoss + RandomVector(flRandomDistance)
						end
					end
					ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability4, vPosition)
				end
			end
		end
		-- 没逃跑随机放几个技能
		local tAbility = {}
		-- 冲撞好了就有几率放
		if Ability2:IsCooldownReady() then
			table.insert(tAbility, Ability2)
		end
		-- 颠勺要前方有单位才会放
		if Ability3:IsCooldownReady() then
			local tTargets = FindUnitsInRadius(thisEntity:GetTeamNumber(), thisEntity:GetAttachmentOrigin(thisEntity:ScriptLookupAttachment("attach_mouthbase")), nil, Ability3:GetSpecialValueFor("radius"), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			if #tTargets > 0 then
				table.insert(tAbility, Ability3)
			end
		end
		-- 狂暴才会施放的技能
		if thisEntity:GetHealthPercent() <= iRageHealthPct then
			if Ability6:IsCooldownReady() then
				table.insert(tAbility, Ability6)
			end
		end
		-- 随机出一个技能
		local hAbility = RandomValue(tAbility)
		if IsValid(hAbility) then
			-- 施放冲刺
			if hAbility == Ability2 then
				if RollPercentage(60) then
					local vBoss = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin()
					local vPosition = vBoss + RandomVector(flRandomDistance)
					for i = 1, 10 do
						if (vPosition - vCaster):Length2D() > flNearDistance then
							break
						else
							vPosition = vBoss + RandomVector(flRandomDistance)
						end
					end
					Ability4.hComboAbility = Ability2
					ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability4, vPosition)
				else
					local width = Ability2:GetSpecialValueFor("radius")
					local distance = Ability2:GetSpecialValueFor("distance")
					local vPosition = GetLinearMostTargetsPosition(vCaster, distance, thisEntity:GetTeamNumber(), width, width, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER)
					ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability2, vPosition)
					-- 狂暴状态下必定接颠勺（效果在技能里实现）
					bEscape = true
					return thisEntity:GetHealthPercent() <= iRageHealthPct and iRageRestTime or iRestTime
				end
			end
			-- 施放颠勺
			if hAbility == Ability3 then
				ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, Ability3)
				bEscape = true
				return thisEntity:GetHealthPercent() <= iRageHealthPct and iRageRestTime or iRestTime
			end
			-- 施放喷火
			if hAbility == Ability6 then
				-- 有几率先跳再喷
				if RollPercentage(100) then
					local vBoss = Entities:FindByNameLike(nil, BOSS_MAP_POINT_NAME):GetAbsOrigin()
					local vPosition = vBoss + RandomVector(flRandomDistance)
					for i = 1, 10 do
						if (vPosition - vCaster):Length2D() > flNearDistance then
							break
						else
							vPosition = vBoss + RandomVector(flRandomDistance)
						end
					end
					Ability4.hComboAbility = Ability6
					ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability4, vPosition)
					bEscape = true
				else
					local tTargets = FindUnitsInRadius(thisEntity:GetTeamNumber(), vCaster, nil, Ability6:GetSpecialValueFor("radius") * 2, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
					if IsValid(tTargets[1]) then
						ExecuteOrder(thisEntity, DOTA_UNIT_ORDER_CAST_POSITION, nil, Ability6, tTargets[1]:GetAbsOrigin())
						bEscape = true
					end
				end
			end
		end
	end

	return 1
end

function EnemyCount(hAbility, iCount)
	local flCastRange = hAbility:GetCastRange(thisEntity:GetAbsOrigin(), nil)
	local tTargets = FindUnitsInRadiusWithAbility(thisEntity, thisEntity:GetAbsOrigin(), flCastRange, hAbility)
	if #tTargets > iCount then
		return true
	end
	return false
end

function EnemyCountInRange(hAbility, iCount)
	local tTargets = FindUnitsInRadiusWithAbility(thisEntity, thisEntity:GetAbsOrigin(), hAbility:GetSpecialValueFor("radius"), hAbility)
	if #tTargets > iCount then
		return true
	end
	return false
end