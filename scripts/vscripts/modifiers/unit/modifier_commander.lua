if modifier_commander == nil then
	modifier_commander = class({}, nil, eom_modifier)
end

local public = modifier_commander

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
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:OnCreated(params)
	local hParent = self:GetParent()
	self.tUpgrade = KeyValues.UnitsKv[hParent:GetUnitName()]
	if IsServer() then
		self.flIdleTime = 0
		hParent:MoveToPositionAggressive(hParent:GetAbsOrigin())
		self:SetStackCount(hParent:GetLevel())
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
	self:LevelUpAttribute(self:GetStackCount())
	self:ResetHPMax()
end
function public:OnRefresh(params)
	local hParent = self:GetParent()
	if IsServer() then
		self:SetStackCount(hParent:GetLevel())
	end
	self:LevelUpAttribute(self:GetStackCount())
end
function public:OnIntervalThink()
	self.flIdleTime = self.flIdleTime + AI_TIMER_TICK_TIME
	if self.flIdleTime > 10 then

	end
	local hParent = self:GetParent()
	if not hParent:IsAlive() then
		return
	end

	if not hParent:IsAttacking() and hParent:GetCurrentActiveAbility() == nil then
		local iTeamID = PlayerData:GetPlayerTeamID(GetPlayerID(hParent))

		if not Spawner:IsBossRound() then
			local vForward = Spawner.tTeamEnemyDoorPos[iTeamID]
			if vForward then
				hParent:FaceTowards(vForward)
			end
		end

		local tTargets = self:FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetAcquisitionRange(),
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
		DOTA_UNIT_TARGET_FLAG_NO_INVIS + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE,
		FIND_CLOSEST,
		true)

		local hTarget = tTargets[1]
		if IsValid(hTarget) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_ATTACK_TARGET, hTarget)
		end
	else

	end
end
function public:FindUnitsInRadius(int_1, Vector_2, handle_3, float_4, int_5, int_6, int_7, int_8, bool_9)
	local iPlayerID = GetPlayerID(self:GetParent())
	local tTargets = FindUnitsInRadius(int_1, Vector_2, handle_3, float_4, int_5, int_6, int_7, int_8, bool_9)
	for i = #tTargets, 1, -1 do
		local hUnit = tTargets[i]
		--????????????????????????
		if GetPlayerID(hUnit) ~= iPlayerID then
			table.remove(tTargets, i)
		else
		end
	end
	return tTargets
end
function public:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		-- [MODIFIER_STATE_NO_HEALTH_BAR] = false,
		-- [MODIFIER_STATE_MAGIC_IMMUNE] = true,
		-- [MODIFIER_STATE_ATTACK_IMMUNE] = true,
		-- [MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_CANNOT_MISS] = true,
	-- [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	-- [MODIFIER_STATE_OUT_OF_GAME] = true,
	--
	-- [MODIFIER_STATE_INVULNERABLE] = true,
	}
end
function public:OnStackCountChanged(iOldStackCount)
	local hParent = self:GetParent()
	local iNewStackCount = self:GetStackCount()
	if iOldStackCount ~= iNewStackCount then
	end
end
function public:LevelUpAttribute(iNewStackCount)
	local hParent = self:GetParent()

	--??????
	self:SetSatrLevelAttribute('PhysicalAttack', iNewStackCount, ATTRIBUTE_KIND.PhysicalAttack)
	self:SetSatrLevelAttribute('MagicalAttack', iNewStackCount, ATTRIBUTE_KIND.MagicalAttack)

	--??????
	self:SetSatrLevelAttribute('PhysicalArmor', iNewStackCount, ATTRIBUTE_KIND.PhysicalArmor)
	self:SetSatrLevelAttribute('MagicalArmor', iNewStackCount, ATTRIBUTE_KIND.MagicalArmor)

	-- --??????
	self:SetSatrLevelAttribute('StatusHealth', iNewStackCount, ATTRIBUTE_KIND.StatusHealth)
end
function public:SetSatrLevelAttribute(sKey, sKey2, typeAttribute)
	local val = self.tUpgrade[sKey] and tonumber(self.tUpgrade[sKey]) or 0
	local val2 = val

	-- 1?????????????????????
	if sKey2 ~= 1 then
		for i = tonumber(sKey2), 2, -1 do
			if self.tUpgrade[sKey .. i] then
				val2 = tonumber(self.tUpgrade[sKey .. i])
				break
			end
		end
	end

	val = val2 - val

	local val_old = self:GetParent():GetDataVal(typeAttribute, ATTRIBUTE_KEY.STAR_LEVEL)
	if val ~= val_old then
		self:GetParent():SetVal(typeAttribute, val, ATTRIBUTE_KEY.STAR_LEVEL)
	end
end
---??????????????????
function public:ResetHPMax()
	local hParent = self:GetParent()
	hParent:SetVal(ATTRIBUTE_KIND.StatusHealth, self.tUpgrade.StatusHealth, ATTRIBUTE_KEY.BASE)

	--???????????????
	--?????????????????????
	-- hParent:SetValPercent(ATTRIBUTE_KIND.StatusHealth, PLAYER_HP_PERCENTAGE, ATTRIBUTE_KEY.BASE)
end
function public:EDeclareFunctions()
	return {
		[EMDF_STATUS_RESISTANCE_PERCENTAGE] = 100,
		[EMDF_EVENT_CUSTOM] = { ET_GAME.DIFFICULTY_CHANGE, 'OnDifficultyChange' },
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
	}
end
---??????????????????
---@param tEvent EventData_DIFFICULTY_CHANGE
function public:OnDifficultyChange(tEvent)
	self:ResetHPMax()
end
function public:GetStatusResistancePercentage()
	return 100
end

---??????
function public:OnDeath(params)
	if params.unit ~= self:GetParent() then return end

	-- ??????????????????????????????
	if 0 < PLAYER_DAMAGE_FROM_COMMANDER_DEATH and not Spawner:IsBossRound() then
		local tInfo = {
			PlayerID = GetPlayerID(params.unit),
			attacker = params.unit,
			damage = PLAYER_DAMAGE_FROM_COMMANDER_DEATH,
		}
		EventManager:fireEvent(ET_PLAYER.ON_DAMAGE, tInfo)
	end
end