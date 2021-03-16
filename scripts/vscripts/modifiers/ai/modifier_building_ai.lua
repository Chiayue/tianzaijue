if modifier_building_ai == nil then
	modifier_building_ai = class({}, nil, eom_modifier)
end

local public = modifier_building_ai

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
function public:RemoveOnDeath()
	return false
end
function public:OnCreated(params)
	local hParent = self:GetParent()

	self.iCheckDistance = 800	-- 检查点距离，单位到达检查点或遇到敌人后才会

	if IsServer() then
		self.vCheckPoint = hParent:GetAbsOrigin() + Vector(0, 1, 0) * self.iCheckDistance
		self.bCheck = Spawner:IsBossRound() and true or false
		self:StartIntervalThink(RandomFloat(0, 0.2))

		-- 设置攻击目标
		hParent.hAttackTarget = nil
		hParent.SetAttackTarget = function(hParent, hTarget)
			hParent.hAttackTarget = hTarget
			hParent:GameTimer(FrameTime(), function()
				if not hParent:IsDisarmed() then
					ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_TARGET, hTarget)
				end
			end)
		end
		FindClearSpaceForUnit(hParent, hParent:GetAbsOrigin(), false)
	else
		if hParent:GetPlayerOwnerID() == GetLocalPlayerID() then
			local iPtcl = ParticleManager:CreateParticle('particles/self_unit_aura.vpcf', PATTACH_POINT_FOLLOW, hParent)
			self:AddParticle(iPtcl, false, false, -1, false, false)
			ParticleManager:SetParticleControl(iPtcl, 10, Vector(60, 255, 60))
		end
	end
	AddModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, hParent)
end
function public:OnDestroy()
	local hParent = self:GetParent()
	if IsServer() then
		hParent.SetAttackTarget = nil
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_DEATH, self, nil, hParent)
end
function public:OnIntervalThink()
	self:StartIntervalThink(AI_TIMER_TICK_TIME)
	local hParent = self:GetParent()
	if IsServer() then
		if GSManager:getStateType() ~= GS_Battle then
			return
		end
		if hParent:IsAIDisabled() then
			return
		end

		-- 尚未遇到敌人或未到达检查点
		if self.bCheck == false and hParent:GetCurrentActiveAbility() == nil then
			local fSearchRadius = math.max(hParent:Script_GetAttackRange(), hParent:GetAcquisitionRange())
			if hParent:IsPositionInRange(self.vCheckPoint, fSearchRadius) then	-- 是否到达检查点
				self.bCheck = true
				hParent:Stop()
				self:StartIntervalThink(0)
				-- hParent:SetCustomHealthLabel('InPosition', 0, 255, 0)
			elseif hParent:IsIdle() then	-- 闲置状态
				-- hParent:SetCustomHealthLabel('IsIdle', 255, 0, 0)
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self.vCheckPoint)
			else	-- 是否有敌人
				-- hParent:SetCustomHealthLabel('NoCheck->Find', 255, 0, 0)
				local tTargets = Spawner:FindMissingInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), fSearchRadius * 2,
				DOTA_UNIT_TARGET_TEAM_ENEMY,
				DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
				DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
				FIND_CLOSEST,
				hParent.Spawner_spawnerPlayerID, true)

				local tEvent = {
					tTargets = tTargets,
					hTarget = tTargets[1],
					hParent = hParent
				}

				EventManager:fireEvent(ET_PLAYER.ON_TOWER_FINDING_ENEMY, tEvent)


				if IsValid(tEvent.hTarget) then
					-- hParent:SetCustomHealthLabel('NoCheck->Finded', 0, 255, 0)
					self.bCheck = true
					hParent:SetAttackTarget(tEvent.hTarget)
				end
			end
		else
			-- hParent:SetCustomHealthLabel('Check->FindBefore', 255, 0, 0)
			-- if hParent:GetCurrentActiveAbility() == nil and not hParent:IsDisarmed() then
			if not hParent:IsDisarmed() then
				-- hParent:SetCustomHealthLabel('Check->Find', 0, 255, 0)
				if (hParent.hAttackTarget == nil or
				not IsValid(hParent.hAttackTarget) or
				not hParent.hAttackTarget:IsAlive() or
				hParent.hAttackTarget:IsAttackImmune() or
				hParent.hAttackTarget:IsInvulnerable()) or
				UnitFilter(hParent.hAttackTarget, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NO_INVIS, hParent:GetTeamNumber()) ~= UF_SUCCESS then
					hParent.hAttackTarget = nil
					local tTargets = Spawner:FindMissingInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), -1,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					hParent:GetPlayerOwnerID(), true)

					local tEvent = {
						tTargets = tTargets,
						hTarget = tTargets[1],
						hParent = hParent
					}

					EventManager:fireEvent(ET_PLAYER.ON_TOWER_FINDING_ENEMY, tEvent)

					-- hParent:SetCustomHealthLabel('Check->NoTaget', 0, 255, 0)
					if IsValid(tEvent.hTarget) and hParent:HasAttackCapability() then
						-- hParent:SetCustomHealthLabel('Check->Attack', 0, 255, 255)
						hParent:SetAttackTarget(tEvent.hTarget)
					else
						-- hParent:SetCustomHealthLabel('Check->NotFind', 0, 255, 0)
						if not hParent:IsIdle() then
							-- 没有单位就原地发呆
							hParent:Stop()
							-- hParent:SetCustomHealthLabel('Check->Stop', 0, 255, 0)
						end
					end
				else	-- 更换最近目标
					-- hParent:SetCustomHealthLabel('Check->HasTagetFindClose', 0, 255, 0)
					local tTargets = Spawner:FindMissingInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), -1,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE + DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
					FIND_CLOSEST,
					hParent:GetPlayerOwnerID(), true)

					local tEvent = {
						tTargets = tTargets,
						hTarget = tTargets[1],
						hParent = hParent
					}

					EventManager:fireEvent(ET_PLAYER.ON_TOWER_FINDING_ENEMY, tEvent)

					if IsValid(tEvent.hTarget) and (tEvent.hTarget ~= hParent.hAttackTarget or hParent:IsIdle()) then
						-- hParent:SetCustomHealthLabel('Check->ChangeTaget', 0, 255, 255)
						hParent:SetAttackTarget(tEvent.hTarget)
					end
				end
			end
		end

		-- --@hanzhen
		-- if	hParent:GetHealth() < hParent:GetMaxHealth() then
		-- 	hParent:RemoveModifierByName("modifier_no_health_bar" or "")
		-- end
	end
end
function public:CheckState()
	return {
		-- [MODIFIER_STATE_FROZEN] = (self:GetStackCount() == self.STATE_ATTACK)
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function public:DeclareFunctions()
	return {
		-- MODIFIER_EVENT_ON_ORDER,
		-- MODIFIER_EVENT_ON_DEATH,
		-- MODIFIER_EVENT_ON_RESPAWN,
		MODIFIER_PROPERTY_VISUAL_Z_DELTA,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
end
function public:OnDeath(params)
	if params.unit ~= self:GetParent() then return end

	if params.unit:IsBuilding() and not params.unit:IsIllusion() then
		local fReincarnation = params.unit:GetVal(ATTRIBUTE_KIND.Reincarnation, params)
		print(fReincarnation)

		local hUnit = params.unit
		if fReincarnation ~= nil and fReincarnation > 0 then
			GameTimer(fReincarnation, function()
				if IsValid(hUnit) and not hUnit:IsAlive() then
					hUnit:GetBuilding():RespawnBuildingUnit()
				end
			end)
		end

		---@class EventData_PlayerTowerDeath
		local tEvent = {
			PlayerID = GetPlayerID(hUnit),
			hBuilding = hUnit:GetBuilding(),
			hUnit = hUnit,
			bIsReincarnating = fReincarnation ~= nil and fReincarnation > 0
		}
		EventManager:fireEvent(ET_PLAYER.ON_TOWER_DEATH, tEvent)
	end
end
function public:GetVisualZDelta(params)
	return 0
end
function public:GetModifierConstantManaRegen(params)
	local hParent = self:GetParent()
	return GET_BUILDING_MANA_REGEN_EXTRA(100 - hParent:GetHealthPercent())
end

----
--寻找目标 (未使用)
function public:FindTargets()
	local hParent = self:GetParent()

	local fSearchRadius = math.max(hParent:Script_GetAttackRange(), hParent:GetAcquisitionRange())
	--寻找最近单位
	local iRange = Spawner:IsBossRound() and -1 or fSearchRadius
	iRange = self.FIRST_TARGET == false and iRange or -1
	local tTargets = Spawner:FindMissingInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), iRange,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	0,
	FIND_CLOSEST,
	hParent.Spawner_spawnerPlayerID, true)

	--过滤不能攻击的单位
	local hTarget_Invalid
	removeAll(tTargets, function(v)
		if not IsCanAttack(hParent, v) then
			if not hTarget_Invalid then
				hTarget_Invalid = v
			end
			return true
		end
	end)

	--攻击范围血量最低
	local hTarget = tTargets[1]
	local iRange = hParent:Script_GetAttackRange()
	for _, v in pairs(tTargets) do
		local fDis = (v:GetAbsOrigin() - hParent:GetAbsOrigin()):Length2D()
		if fDis <= iRange then
			if not hTarget or hTarget:GetHealth() > v:GetHealth() then
				hTarget = v
			end
		end
	end

	if hTarget then
		return hTarget, true
	end
	return hTarget_Invalid, false
end
--设置目标 (未使用)
function public:SetTarget(hTarget, bValid)
	local hParent = self:GetParent()
	self.hTarget = hTarget

	if hTarget then
		if bValid then
			--攻击有效单位
			hParent:SetAttackCapability(self.iAttackCapability)
			hParent:MoveToTargetToAttack(hTarget)
			-- ExecuteOrderFromTable({
			-- 	UnitIndex = hParent:entindex(),
			-- 	OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
			-- 	Position = hTarget:GetAbsOrigin()
			-- })
			--判断是否攻击范围内
			if hTarget:IsPositionInRange(hParent:GetAbsOrigin(), hParent:Script_GetAttackRange()) then
				self.typeState = self.STATE_ATTACK
				if self.FIRST_TARGET == false then
					self.FIRST_TARGET = true
				end
			else
				self.typeState = self.STATE_MOVE_ATTACK
			end
		else
			--无可攻击单位，但也会向其他单位移动
			self.typeState = self.STATE_FOLLOW
			ExecuteOrderFromTable({
				UnitIndex = hParent:entindex(),
				OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
				Position = hTarget:GetAbsOrigin()
			})
		end
	else
		ExecuteOrderFromTable({
			UnitIndex = hParent:entindex(),
			OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
			Position = hParent:GetAbsOrigin() + Vector(900, 0, 0)
		})
	end
end