if modifier_enemy_ai == nil then
	modifier_enemy_ai = class({})
end

local public = modifier_enemy_ai

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return true
end
function public:OnCreated(params)
	local hParent = self:GetParent()

	self.iCheckDistance = 1000	-- 检查点距离，单位到达检查点或遇到敌人后才会

	if IsServer() then
		self.vCheckPoint = hParent:GetAbsOrigin() + Vector(0, -1, 0) * self.iCheckDistance
		self.bCheck = 1 == params.checked
		-- 设置寻路
		-- hParent:SetInitialGoalEntity(Spawner:GetEnemyMovePath(hParent))
		self:StartIntervalThink(RandomFloat(0, 0.2))
		-- 设置攻击目标
		hParent.hAttackTarget = nil
		hParent.SetAttackTarget = function(hParent, hTarget)
			hParent.hAttackTarget = hTarget
			if hTarget then
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_TARGET, hTarget)
			end
			-- hParent:SetAttackTarget(hTarget)
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function public:OnRefresh(params)
	if IsServer() then
		-- self.bCheck = 1 == params.checked
	end
end
function public:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent.SetAttackTarget = nil
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, hParent)
end
function public:OnIntervalThink()
	self:StartIntervalThink(AI_TIMER_TICK_TIME)
	if IsServer() then
		local hParent = self:GetParent()
		if GSManager:getStateType() ~= GS_Battle then
			return
		end
		if hParent:IsAIDisabled() then
			return
		end
		-- if hParent:HasAttackCapability() then
		-- 	local tTargets = self:FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetAcquisitionRange(),
		-- 	DOTA_UNIT_TARGET_TEAM_ENEMY,
		-- 	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		-- 	DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		-- 	FIND_CLOSEST,
		-- 	true)
		-- 	if IsValid(tTargets[1]) then
		-- 		-- self.bCheck = true
		-- 		hParent:SetAttackTarget(tTargets[1])
		-- 	end
		-- end
		-- 尚未遇到敌人或未到达检查点
		if self.bCheck == false then
			if hParent:IsPositionInRange(self.vCheckPoint, hParent:GetAcquisitionRange()) then	-- 是否到达检查点
				self.bCheck = true
				self:StartIntervalThink(0)
				-- hParent:Stop()
			elseif hParent:IsIdle() then	-- 闲置状态
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self.vCheckPoint)
			else	-- 是否有敌人
				local tTargets = self:FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetAcquisitionRange(),
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
				FIND_CLOSEST,
				true)
				local tEvent = {
					tTargets = tTargets,
					hTarget = tTargets[1],
					hParent = hParent
				}
				EventManager:fireEvent(ET_PLAYER.ON_TOWER_FINDING_ENEMY, tEvent)

				if IsValid(tEvent.hTarget) then
					self.bCheck = true
					hParent:SetAttackTarget(tEvent.hTarget)
				end
			end
		else
			if hParent:GetCurrentActiveAbility() == nil then
				if
				hParent.hAttackTarget == nil or
				not IsValid(hParent.hAttackTarget) or
				not hParent.hAttackTarget:IsAlive() or
				hParent.hAttackTarget:IsInvulnerable() or
				UnitFilter(hParent.hAttackTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, hParent:GetTeamNumber()) ~= UF_SUCCESS then
					hParent.hAttackTarget = nil

					-- 寻找一个敌人
					if not hParent:IsDisarmed() and hParent:HasAttackCapability() then
						local tTargets = self:FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetAcquisitionRange(),
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
						FIND_CLOSEST, true)

						local tEvent = {
							tTargets = tTargets,
							hTarget = tTargets[1],
							hParent = hParent
						}

						EventManager:fireEvent(ET_PLAYER.ON_TOWER_FINDING_ENEMY, tEvent)

						if IsValid(tEvent.hTarget) then
							hParent.hAttackTarget = tEvent.hTarget
							hParent:SetAttackTarget(tEvent.hTarget)
						end
					end
					-- hParent:IsDisarmed() 暂时去掉了缴械的ai判断
					if nil == hParent.hAttackTarget then
						local iTeam = PlayerData:GetPlayerTeamID(hParent.Spawner_spawnerPlayerID)
						local hDoor = Entities:FindByName(nil, iTeam .. '_Enemy_Path_A_2')
						ExecuteOrderFromTable({
							UnitIndex = hParent:entindex(),
							OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
							Position = hDoor:GetAbsOrigin()
						})
					end
				else		 	-- 更换最近目标
					if not hParent:HasAttackCapability() then
						hParent.hAttackTarget = nil
					else
						local tTargets = self:FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetAcquisitionRange(),
						DOTA_UNIT_TARGET_TEAM_ENEMY,
						DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
						DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
						FIND_CLOSEST,
						true)

						-- 选取仇恨等级最高的单位
						table.sort(tTargets, function(a, b)
							return a:GetVal(ATTRIBUTE_KIND.ThreatLevel) > a:GetVal(ATTRIBUTE_KIND.ThreatLevel)
						end)

						local tEvent = {
							tTargets = tTargets,
							hTarget = tTargets[1],
							hParent = hParent
						}

						EventManager:fireEvent(ET_PLAYER.ON_TOWER_FINDING_ENEMY, tEvent)

						if IsValid(tEvent.hTarget) then
							hParent:SetAttackTarget(tEvent.hTarget)
						end

					end
				end
			end
		end

		--检测进入传送门
		Spawner:CheckEnterDoor(self:GetParent())
	end
end
function public:CheckState()
	return {
	}
end
function public:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ORDER,
		MODIFIER_PROPERTY_FIXED_NIGHT_VISION,
		MODIFIER_PROPERTY_FIXED_DAY_VISION,
	}
end
function public:GetFixedNightVision()
	if IsServer() then
		return self:GetParent():GetAcquisitionRange()
	end
end
function public:GetFixedDayVision()
	if IsServer() then
		return self:GetParent():GetAcquisitionRange()
	end
end
function public:OnTakeDamage(params)
	if params.unit ~= self:GetParent() then return end

	if IsValid(params.attacker) and
	params.attacker:IsAlive() and
	not params.attacker:HasModifier("modifier_commander") then
		-- params.unit:SetAcquisitionRange(CalculateDistance(params.unit, params.attacker, false) + 250)
		local tTargets = FindUnitsInRadius(params.unit:GetTeamNumber(), params.unit:GetAbsOrigin(), nil, params.unit:GetAcquisitionRange(),
		DOTA_UNIT_TARGET_TEAM_FRIENDLY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NONE + DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE,
		FIND_CLOSEST,
		true)
		for _, hUnit in pairs(tTargets) do
			if hUnit.hAttackTarget == nil or not IsValid(hUnit.hAttackTarget) or not hUnit.hAttackTarget:IsAlive() then
				if hUnit.SetAttackTarget then
					hUnit:SetAttackTarget(params.attacker)
				end
			end
		end
	end
end
function public:FindUnitsInRadius(int_1, Vector_2, handle_3, float_4, int_5, int_6, int_7, int_8, bool_9)
	local iPlayerID = GetPlayerID(self:GetParent())
	local tTargets = FindUnitsInRadius(int_1, Vector_2, handle_3, float_4, int_5, int_6, int_7, int_8, bool_9)
	for i = #tTargets, 1, -1 do
		local hUnit = tTargets[i]
		--排除其他玩家单位
		if GetPlayerID(hUnit) ~= iPlayerID then
			table.remove(tTargets, i)
		else
			--排除指挥官
			-- if IsCommanderTower(hUnit) then
			-- 	table.remove(tTargets, i)
			-- end
		end
	end
	return tTargets
end