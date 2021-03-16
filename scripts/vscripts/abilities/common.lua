---获取技能脚本路径
function GetAbilityScriptFile(sName, tAbltKVs)
	if not tAbltKVs then
		tAbltKVs = {
			KeyValues.ItemsKv,
			KeyValues.AbilitiesKv,
		}
	end
	for _, tKV in pairs(tAbltKVs) do
		if tKV[sName] and tKV[sName].ScriptFile then
			return tKV[sName].ScriptFile
		end
	end
	return ''
end
tModifierHook = {}
---技能class勾获重定向
function AbilityClassHook(sName, env, sPath, tAbltKVs)
	if env ~= _G then
		local public = class({}, nil, env[sName])
		local public_buff = env['modifier_' .. sName]
		local metatable = getmetatable(env)
		local globals = _G
		local strfind = string.find
		local ExtendInstance = ExtendInstance
		metatable.__index = function(t, key)
			if key == "ExtendInstance" then return ExtendInstance end
			if strfind(GetAbilityScriptFile(key, tAbltKVs), sName) ~= nil then
				globals.tModifierHook["modifier_" .. key] = true
				LinkLuaModifier("modifier_" .. key, sPath, LUA_MODIFIER_MOTION_NONE)
				return public
			end
			if globals.tModifierHook[key] then
				return public_buff
			end
			return globals[key]
		end
	end
end

-- 用于插件跳转
if nil == CDOTA_Buff then CDOTA_Buff = class() end
-- CDOTA_Buff
function CDOTA_Buff:GetKVSpecialValueFor(sAblt, sName, iLevel)
	local tKV = KeyValues.AbilitiesKv[sAblt]
	if tKV and tKV.AbilitySpecial then
		for _, t in pairs(tKV.AbilitySpecial) do
			for k, v in pairs(t) do
				if k == sName then
					local tLevelVals = string.split(v, ' ')
					iLevel = Clamp(iLevel or 1, 1, #tLevelVals)
					return tonumber(tLevelVals[iLevel])
				end
			end
		end
	end
	return 0
end
function CDOTA_Buff:GetAbilitySpecialValueFor(szName)
	local ability = self:GetAbility()
	if IsValid(ability) and ability.GetSpecialValueFor then
		return ability:GetSpecialValueFor(szName)
	end
	return self[szName] or 0
end
function CDOTA_Buff:GetAbilityLevelSpecialValueFor(szName, iLevel)
	local ability = self:GetAbility()
	if not IsValid(ability) then
		return self[szName] or 0
	end
	return ability:GetLevelSpecialValueFor(szName, iLevel)
end
function CDOTA_Buff:GetAbilityLevel()
	local ability = self:GetAbility()
	if not IsValid(ability) then
		return 0
	end
	return ability:GetLevel()
end
if CDOTA_Buff._IncrementStackCount == nil then
	CDOTA_Buff._IncrementStackCount = CDOTA_Buff.IncrementStackCount
end
function CDOTA_Buff:IncrementStackCount(iStackCount)
	if iStackCount == nil then
		self:_IncrementStackCount()
	else
		self:SetStackCount(self:GetStackCount() + iStackCount)
	end
end
if CDOTA_Buff._DecrementStackCount == nil then
	CDOTA_Buff._DecrementStackCount = CDOTA_Buff.DecrementStackCount
end
function CDOTA_Buff:DecrementStackCount(iStackCount)
	if iStackCount == nil then
		self:_DecrementStackCount()
	else
		self:SetStackCount(self:GetStackCount() - iStackCount)
	end
end

function AddModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			table.insert(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			table.insert(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		table.insert(tModifierEvents[iModifierEvent], hModifier)
	end
end
function RemoveModifierEvents(iModifierEvent, hModifier, hSource, hTarget)
	if IsValid(hTarget) or IsValid(hSource) then
		if IsValid(hSource) then
			if hSource.tSourceModifierEvents == nil then
				hSource.tSourceModifierEvents = {}
			end
			if hSource.tSourceModifierEvents[iModifierEvent] == nil then
				hSource.tSourceModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hSource.tSourceModifierEvents[iModifierEvent], hModifier)
		end
		if IsValid(hTarget) then
			if hTarget.tTargetModifierEvents == nil then
				hTarget.tTargetModifierEvents = {}
			end
			if hTarget.tTargetModifierEvents[iModifierEvent] == nil then
				hTarget.tTargetModifierEvents[iModifierEvent] = {}
			end

			ArrayRemove(hTarget.tTargetModifierEvents[iModifierEvent], hModifier)
		end
	else
		if _G.tModifierEvents == nil then
			_G.tModifierEvents = {}
		end
		if tModifierEvents[iModifierEvent] == nil then
			tModifierEvents[iModifierEvent] = {}
		end

		ArrayRemove(tModifierEvents[iModifierEvent], hModifier)
	end
end
function FireCustomModifiersEvents(iModifierFunction, params)
	if CUSTOM_MODIFIER_EVENT_FUNCTIONS[iModifierFunction] == nil then return end

	if tModifierEvents and tModifierEvents[iModifierFunction] then
		local tModifiers = tModifierEvents[iModifierFunction]
		for i = #tModifiers, 1, -1 do
			local hModifier = tModifiers[i]
			if IsValid(hModifier) and hModifier[CUSTOM_MODIFIER_EVENT_FUNCTIONS[iModifierFunction]] then
				hModifier[CUSTOM_MODIFIER_EVENT_FUNCTIONS[iModifierFunction]](hModifier, params)
			else
				table.remove(tModifiers, i)
			end
		end
	end
end

-- 获取技能的特殊键值
function GetAbilityNameLevelSpecialValueFor(sAbilityName, sKey, iLevel)
	local tAbilityKeyValues = KeyValues.AbilitiesKv[sAbilityName]
	if tAbilityKeyValues ~= nil then
		if tAbilityKeyValues.AbilitySpecial ~= nil then
			for sIndex, tData in pairs(tAbilityKeyValues.AbilitySpecial) do
				if tData[sKey] ~= nil then
					local aValues = vlua.split(tostring(tData[sKey]), " ")
					if aValues and #aValues > 0 and aValues[math.min(iLevel + 1, #aValues)] then
						return tonumber(aValues[math.min(iLevel + 1, #aValues)])
					end
				end
			end
		end
	end
	return 0
end

--能否发动攻击
function IsCanAttack(hAtker, hTarget)
	local iPlayerID_Atk = hAtker.Spawner_spawnerPlayerID or hAtker:GetPlayerOwnerID()
	local iPlayerID_Target = hTarget.Spawner_spawnerPlayerID or hTarget:GetPlayerOwnerID()
	if iPlayerID_Atk ~= iPlayerID_Target then
		return false
	end
	-- if not hAtker:IsFlyUnit() then
	-- 	--地面单位
	-- 	if hTarget:IsFlyUnit() then
	-- 		--不能打飞行单位
	-- 		return false
	-- 	end
	-- end
	return true
end

-- 获取塔的稀有度颜色
function GetCardRarityColor(sCardName)
	for rarity, data in pairs(KeyValues.CardsKv) do
		for cardName, abilityName in pairs(data) do
			if cardName == sCardName then
				return Vector(RARITY_COLOR[rarity].x, RARITY_COLOR[rarity].y, RARITY_COLOR[rarity].z)
			end
		end
	end
	return Vector(255, 255, 255)
end

if IsClient() then
	-- 用于插件跳转
	if C_DOTABaseAbility == nil then C_DOTABaseAbility = class() end
	if C_DOTA_BaseNPC == nil then C_DOTA_BaseNPC = class() end

	--是否飞行单位
	function C_DOTA_BaseNPC:IsFlyUnit()
		return self:IsRangedAttacker()
	end
	function C_DOTA_BaseNPC:IsFriendly(hTarget)
		return self:GetTeamNumber() == hTarget:GetTeamNumber()
	end
	function C_DOTABaseAbility:GetLevelSpecialValueFor(sKey, iLevel)
		ScriptAssert(type(sKey) == "string", "sKey is not a string!")
		ScriptAssert(type(iLevel) == "number", "iLevel is not a number!")
		if iLevel == -1 then
			iLevel = self:GetLevel()
		end
		return GetAbilityNameLevelSpecialValueFor(self:GetName(), sKey, iLevel)
	end

	---遍历建筑单位
	function EachBuilding(iPlayerID, func)
		local tPlayersBuildings = CustomNetTables:GetTableValue("common", "player_buildings") or {}
		if iPlayerID == nil then
			for sPlayerID, tData in pairs(tPlayersBuildings) do
				for _, iUnitEntIndex in pairs(tData.nonhero.list) do
					local hUnit = EntIndexToHScript(iUnitEntIndex)
					if IsValid(hUnit) and func(hUnit, tonumber(sPlayerID)) == true then
						return
					end
				end
				for _, iUnitEntIndex in pairs(tData.hero.list) do
					local hUnit = EntIndexToHScript(iUnitEntIndex)
					if IsValid(hUnit) and func(hUnit, tonumber(sPlayerID)) == true then
						return
					end
				end
			end
		else
			if tPlayersBuildings[tostring(iPlayerID)] == nil then
				return
			end
			for _, iUnitEntIndex in pairs(tPlayersBuildings[tostring(iPlayerID)].nonhero.list) do
				local hUnit = EntIndexToHScript(iUnitEntIndex)
				if IsValid(hUnit) and func(hUnit, iPlayerID) == true then
					return
				end
			end
			for _, iUnitEntIndex in pairs(tPlayersBuildings[tostring(iPlayerID)].hero.list) do
				local hUnit = EntIndexToHScript(iUnitEntIndex)
				if IsValid(hUnit) and func(hUnit, iPlayerID) == true then
					return
				end
			end
		end
	end
	function EachHeroBuilding(iPlayerID, func)
		local tPlayersBuildings = CustomNetTables:GetTableValue("common", "player_buildings") or {}
		if iPlayerID == nil then
			for sPlayerID, tData in pairs(tPlayersBuildings) do
				for _, iUnitEntIndex in pairs(tData.hero.list) do
					local hUnit = EntIndexToHScript(iUnitEntIndex)
					if IsValid(hUnit) and func(hUnit, tonumber(sPlayerID)) == true then
						return
					end
				end
			end
		else
			if tPlayersBuildings[tostring(iPlayerID)] == nil then
				return
			end
			for _, iUnitEntIndex in pairs(tPlayersBuildings[tostring(iPlayerID)].hero.list) do
				local hUnit = EntIndexToHScript(iUnitEntIndex)
				if IsValid(hUnit) and func(hUnit, iPlayerID) == true then
					return
				end
			end
		end
	end
	function EachNonheroBuilding(iPlayerID, func)
		local tPlayersBuildings = CustomNetTables:GetTableValue("common", "player_buildings") or {}
		if iPlayerID == nil then
			for sPlayerID, tData in pairs(tPlayersBuildings) do
				for _, iUnitEntIndex in pairs(tData.nonhero.list) do
					local hUnit = EntIndexToHScript(iUnitEntIndex)
					if IsValid(hUnit) and func(hUnit, tonumber(sPlayerID)) == true then
						return
					end
				end
			end
		else
			if tPlayersBuildings[tostring(iPlayerID)] == nil then
				return
			end
			for _, iUnitEntIndex in pairs(tPlayersBuildings[tostring(iPlayerID)].nonhero.list) do
				local hUnit = EntIndexToHScript(iUnitEntIndex)
				if IsValid(hUnit) and func(hUnit, iPlayerID) == true then
					return
				end
			end
		end
	end

	--- 获取玩家ID
	function GetPlayerID(hUnit)
		local iPlayerID = -1
		if not IsValid(hUnit) then
			return iPlayerID
		end

		if hUnit.GetPlayerOwnerID then
			iPlayerID = hUnit:GetPlayerOwnerID()
		end

		return iPlayerID
	end
end

if IsServer() then
	-- 用于插件跳转
	if CDOTABaseAbility == nil then CDOTABaseAbility = class() end
	if CDOTA_BaseNPC == nil then CDOTA_BaseNPC = class() end

	if CDOTA_Modifier_Lua_Horizontal_Motion._ApplyHorizontalMotionController == nil then
		CDOTA_Modifier_Lua_Horizontal_Motion._ApplyHorizontalMotionController = CDOTA_Modifier_Lua_Horizontal_Motion.ApplyHorizontalMotionController
	end
	function CDOTA_Modifier_Lua_Horizontal_Motion:ApplyHorizontalMotionController()
		if self:GetParent():HasModifier("modifier_boss") and not self:GetParent():IsFriendly(self:GetCaster()) then
			return false
		else
			return self:_ApplyHorizontalMotionController()
		end
	end

	if CDOTA_Modifier_Lua_Horizontal_Motion._ApplyVerticalMotionController == nil then
		CDOTA_Modifier_Lua_Horizontal_Motion._ApplyVerticalMotionController = CDOTA_Modifier_Lua_Horizontal_Motion.ApplyVerticalMotionController
	end
	function CDOTA_Modifier_Lua_Horizontal_Motion:ApplyVerticalMotionController()
		if self:GetParent():HasModifier("modifier_boss") and not self:GetParent():IsFriendly(self:GetCaster()) then
			return false
		else
			return self:_ApplyVerticalMotionController()
		end
	end

	if CDOTA_Modifier_Lua_Motion_Both._ApplyHorizontalMotionController == nil then
		CDOTA_Modifier_Lua_Motion_Both._ApplyHorizontalMotionController = CDOTA_Modifier_Lua_Motion_Both.ApplyHorizontalMotionController
	end
	function CDOTA_Modifier_Lua_Motion_Both:ApplyHorizontalMotionController()
		if self:GetParent():HasModifier("modifier_boss") and not self:GetParent():IsFriendly(self:GetCaster()) then
			return false
		else
			return self:_ApplyHorizontalMotionController()
		end
	end

	if CDOTA_Modifier_Lua_Motion_Both._ApplyVerticalMotionController == nil then
		CDOTA_Modifier_Lua_Motion_Both._ApplyVerticalMotionController = CDOTA_Modifier_Lua_Motion_Both.ApplyVerticalMotionController
	end
	function CDOTA_Modifier_Lua_Motion_Both:ApplyVerticalMotionController()
		if self:GetParent():HasModifier("modifier_boss") and not self:GetParent():IsFriendly(self:GetCaster()) then
			return false
		else
			return self:_ApplyVerticalMotionController()
		end
	end

	function CDOTABaseAbility:GetIntrinsicModifier()
		local tModifiers = self:GetCaster():FindAllModifiersByName(self:GetIntrinsicModifierName())
		for i, hModifier in ipairs(tModifiers) do
			if hModifier:GetAbility() == self then
				return hModifier
			end
		end
		return nil
	end

	-- 创建跟踪投射物
	function CDOTABaseAbility:CreateTrackingProjectile(EffectName, iMoveSpeed, Source, Target, iSourceAttachment, vSourceLoc, bDodgeable, ExtraData)
		local info = {
			EffectName = EffectName,
			Ability = self,
			iMoveSpeed = iMoveSpeed,
			Source = Source,
			Target = Target,
			iSourceAttachment = iSourceAttachment,
			vSourceLoc = vSourceLoc,
			bDodgeable = bDodgeable,
			ExtraData = ExtraData
		}
		ProjectileManager:CreateTrackingProjectile(info)
	end

	function CDOTA_BaseNPC:GetAbilityNameSpecialValueFor(sAbilityName, sKey)
		local hAbility = self:FindAbilityByName(sAbilityName)
		if IsValid(hAbility) and hAbility.GetSpecialValueFor then
			return hAbility:GetSpecialValueFor(sKey)
		end
		return 0
	end
	-- 获取天赋加成
	function CDOTA_BaseNPC:GetTalentValue(sTalentName, sKey)
		if sKey == nil then sKey = "value" end
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 and hAbility.GetSpecialValueFor then
			return hAbility:GetSpecialValueFor(sKey)
		end
		return 0
	end
	-- 获取对应等级的天赋加成
	function CDOTA_BaseNPC:GetLevelTalentValue(sTalentName, iLevel, sKey)
		if sKey == nil then sKey = "value" end
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return hAbility:GetLevelSpecialValueFor(sKey, iLevel)
		end
		return 0
	end
	-- 是否为有效天赋
	function CDOTA_BaseNPC:IsValidTalent(sTalentName)
		local hAbility = self:FindAbilityByName(sTalentName)
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			return true
		end		return false
	end
	-- 添加状态
	function CDOTA_BaseNPC:AddBuff(hCaster, sType, flDuration, bIgnoreStatusResistance, ExtraData)
		if bIgnoreStatusResistance == nil and self == hCaster then
			bIgnoreStatusResistance = true
		end
		if not flDuration then
			return self:AddNewModifier(hCaster, nil, sType, TableOverride({ duration = flDuration }, ExtraData))
		end
		if not bIgnoreStatusResistance then
			flDuration = GetStatusDebuffDuration(flDuration, self, hCaster)
		end
		if flDuration == 0 then return end
		return self:AddNewModifier(hCaster, nil, sType, TableOverride({ duration = flDuration }, ExtraData))
	end

	function CDOTA_BaseNPC:IsFriendly(hTarget)
		if IsValid(self) and IsValid(hTarget) then
			return self:GetTeamNumber() == hTarget:GetTeamNumber()
		end
	end

	-- 治疗单位并默认显示数字，满血不接受治疗
	if CDOTA_BaseNPC._Heal == nil then
		CDOTA_BaseNPC._Heal = CDOTA_BaseNPC.Heal
	end
	function CDOTA_BaseNPC:Heal(flAmount, hInflictor, bShowOverhead)
		if IsValid(self) then
			self:_Heal(flAmount, hInflictor)
			local flHealthDeficit = self:GetHealthDeficit()
			flAmount = math.min(flHealthDeficit, flAmount)
			if flAmount > 0 then
				if bShowOverhead == nil then bShowOverhead = true end
				if bShowOverhead then
					SendOverheadEventMessage(self:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, self, flAmount, self:GetPlayerOwner())
				end
			end
		end
	end
	--- 造成伤害
	---@param funcCallBack funtion funtion(tDamageData)=>void
	function CDOTA_BaseNPC:DealDamage(tTargets, hAbility, flDamage, iDamageType, iDamageFlags, funcCallback)
		if nil == tTargets then return end
		if flDamage == nil then flDamage = 0 end
		if tTargets.IsHero ~= nil then
			tTargets = { tTargets }
		end
		if hAbility ~= nil and iDamageType == nil then
			iDamageType = hAbility:GetAbilityDamageType()
		end
		if iDamageFlags == nil then
			iDamageFlags = DOTA_DAMAGE_FLAG_NONE
		end
		for i, hUnit in ipairs(tTargets) do
			local tDamageInfo = {
				attacker = self,
				victim = hUnit,
				ability = hAbility,
				damage = flDamage,
				damage_type = iDamageType,
				damage_flags = iDamageFlags
			}
			ApplyDamage(tDamageInfo, funcCallback)
		end
	end
	--- 批量造成普通攻击
	function CDOTA_BaseNPC:DealAttack(tTargets, iAttackState, ExtarData)
		for _, hUnit in ipairs(tTargets) do
			self:GameTimer(RandomFloat(0, 0.1), function()
				if IsValid(hUnit) then
					Attack(self, hUnit, iAttackState, ExtarData)
				end
			end)
		end
	end

	_FindUnitsInRadius = _FindUnitsInRadius or FindUnitsInRadius
	function FindUnitsInRadius(typeTeam, vPos, handle_3, fRadius, typeTargetTeam, typeTargetType, typeTargetFlag, typeFind, bool_9)
		local tUnits = {}

		if _G.BANDOTAFIND then
			-- 搜索优化
			local tUnitsKV = {}
			local function checkUnit(hUnit)
				if fRadius > -1 and not hUnit:IsPositionInRange(vPos, fRadius) then
					return
				end
				if UnitFilter(hUnit,
				typeTargetTeam, typeTargetType, typeTargetFlag,
				typeTeam) ~= UF_SUCCESS then
					return
				end
				tUnitsKV[hUnit:GetEntityIndex()] = hUnit
			end

			if typeTeam ~= DOTA_TEAM_BADGUYS then
				-- 玩家发起搜索
				if bit.band(typeTargetTeam, DOTA_UNIT_TARGET_TEAM_ENEMY) == DOTA_UNIT_TARGET_TEAM_ENEMY then
					EachUnits(checkUnit, UnitType.AllEnemies)
				end
				if bit.band(typeTargetTeam, DOTA_UNIT_TARGET_TEAM_FRIENDLY) == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
					EachUnits(checkUnit, UnitType.AllFirends)
				end
			else
				-- 进攻怪发起搜索
				if bit.band(typeTargetTeam, DOTA_UNIT_TARGET_TEAM_ENEMY) == DOTA_UNIT_TARGET_TEAM_ENEMY then
					EachUnits(checkUnit, UnitType.AllFirends)
				end
				if bit.band(typeTargetTeam, DOTA_UNIT_TARGET_TEAM_FRIENDLY) == DOTA_UNIT_TARGET_TEAM_FRIENDLY then
					EachUnits(checkUnit, UnitType.AllEnemies)
				end
			end

			for _, v in pairs(tUnitsKV) do
				table.insert(tUnits, v)
			end
			if typeFind == FIND_CLOSEST then
				table.sort(tUnits, function(a, b)
					local fLen1, fLen2 = (a:GetAbsOrigin() - vPos):Length2D(), (b:GetAbsOrigin() - vPos):Length2D()
					return fLen1 < fLen2
				end)
			elseif typeFind == FIND_FARTHEST then
				table.sort(tUnits, function(a, b)
					local fLen1, fLen2 = (a:GetAbsOrigin() - vPos):Length2D(), (b:GetAbsOrigin() - vPos):Length2D()
					return fLen1 > fLen2
				end)
			end
		else
			-- 官方搜索
			tUnits = _FindUnitsInRadius(typeTeam, vPos, handle_3, fRadius, typeTargetTeam, typeTargetType, typeTargetFlag, typeFind, bool_9)
		end
		if typeTeam ~= DOTA_TEAM_BADGUYS then
			-- 玩家队伍不敌对
			if typeTargetTeam == DOTA_UNIT_TARGET_TEAM_ENEMY then
				-- 排除玩家
				removeAll(tUnits, function(hUnit)
					return hUnit:GetTeamNumber() ~= DOTA_TEAM_BADGUYS
				end)
			end
		end

		return tUnits
	end

	--在范围内搜素拥有Modifier的单位的单位组
	function FindUnitsInRadiusByModifierName(sModifierName, iTeamNumber, vPosition, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder)
		local tUnits = FindUnitsInRadius(iTeamNumber, vPosition, nil, fRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
		for i = #tUnits, 1, -1 do
			local hUnit = tUnits[i]
			if not hUnit:HasModifier(sModifierName) then
				table.remove(tUnits, i)
			end
		end
		return tUnits
	end

	-- 寻找扇形单位
	function FindUnitsInSector(...)
		local iTeamNumber, vPosition, flRadius, vForwardVector, flAngle, iTeamFilter, iTypeFilter, iFlagFilter, iOrder = ...
		local tRadiusGroup = FindUnitsInRadius(iTeamNumber, vPosition, nil, flRadius, iTeamFilter, iTypeFilter, iFlagFilter, iOrder, false)
		local tSectorGroup = {}
		for _, hUnit in pairs(tRadiusGroup) do
			local vTargetPosition = hUnit:GetAbsOrigin()
			local vTargetVector = vTargetPosition - vPosition
			local NAN = math.floor(vTargetVector:Dot(vForwardVector) / math.sqrt((vTargetVector.x ^ 2 + vTargetVector.y ^ 2) * (vForwardVector.x ^ 2 + vForwardVector.y ^ 2)))
			if NAN == 1 then
				table.insert(tSectorGroup, hUnit)
			else
				local vTargetAngle = math.abs(math.deg(math.acos(vTargetVector:Dot(vForwardVector) / math.sqrt((vTargetVector.x ^ 2 + vTargetVector.y ^ 2) * (vForwardVector.x ^ 2 + vForwardVector.y ^ 2)))))
				local flOffsetAngle = flAngle * 0.5
				if vTargetAngle < flOffsetAngle then
					table.insert(tSectorGroup, hUnit)
				end
			end
		end
		return tSectorGroup
	end

	-- 用技能kv寻找直线单位
	function FindUnitsInLineWithAbility(hCaster, vStart, vEnd, flWidth, hAbility)
		if not IsValid(hCaster) or not IsValid(hAbility) then return {} end
		return FindUnitsInLine(hCaster:GetTeamNumber(), vStart, vEnd, nil, flWidth, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags())
	end
	-- 用技能kv寻找单位
	function FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, hAbility, iOrder)
		if not IsValid(hCaster) or not IsValid(hAbility) then return {} end
		if iOrder == nil then
			iOrder = FIND_ANY_ORDER
		end
		if hCaster.IsBuilding and hCaster:IsBuilding() then
			return Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), vPosition, flRadius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), iOrder, hCaster.Spawner_spawnerPlayerID, true)
		else
			return FindUnitsInRadius(hCaster:GetTeamNumber(), vPosition, nil, flRadius, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), iOrder, false)
		end
	end
	-- 范围内是否有单位
	function CDOTABaseAbility:HasUnitInRange(flRange, iOrder)
		iOrder = iOrder or FIND_ANY_ORDER
		local hCaster = self:GetCaster()
		local tTargets = Spawner:FindMissingInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), flRange, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), iOrder, hCaster.Spawner_spawnerPlayerID, true)
		if IsValid(tTargets[1]) then
			return tTargets[1]
		end
		return false
	end
	-- 发布指令
	--[[		DOTA_UNIT_ORDER_NONE
		DOTA_UNIT_ORDER_MOVE_TO_POSITION
		DOTA_UNIT_ORDER_MOVE_TO_TARGET
		DOTA_UNIT_ORDER_ATTACK_MOVE
		DOTA_UNIT_ORDER_ATTACK_TARGET
		DOTA_UNIT_ORDER_CAST_POSITION
		DOTA_UNIT_ORDER_CAST_TARGET
		DOTA_UNIT_ORDER_CAST_TARGET_TREE
		DOTA_UNIT_ORDER_CAST_NO_TARGET
		DOTA_UNIT_ORDER_CAST_TOGGLE
		DOTA_UNIT_ORDER_HOLD_POSITION
		DOTA_UNIT_ORDER_TRAIN_ABILITY
		DOTA_UNIT_ORDER_DROP_ITEM
		DOTA_UNIT_ORDER_GIVE_ITEM
		DOTA_UNIT_ORDER_PICKUP_ITEM
		DOTA_UNIT_ORDER_PICKUP_RUNE
		DOTA_UNIT_ORDER_PURCHASE_ITEM
		DOTA_UNIT_ORDER_SELL_ITEM
		DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
		DOTA_UNIT_ORDER_MOVE_ITEM
		DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
		DOTA_UNIT_ORDER_STOP
		DOTA_UNIT_ORDER_TAUNT
		DOTA_UNIT_ORDER_BUYBACK
		DOTA_UNIT_ORDER_GLYPH
		DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
		DOTA_UNIT_ORDER_CAST_RUNE
	]]
	function ExecuteOrder(hUnit, iOrder, hTarget, hAbility, vPosition)
		ExecuteOrderFromTable({
			UnitIndex = hUnit:entindex(),
			OrderType = iOrder,
			TargetIndex = IsValid(hTarget) and hTarget:entindex() or nil,
			AbilityIndex = IsValid(hAbility) and hAbility:entindex() or nil,
			Position = vPosition,
			Queue = 0
		})
	end

	--[[		中毒效果
		hCaster -- 施法者
		hAbility -- 技能
		fDPS -- 中毒伤害
		fDuration -- 持续时间
	]]
	--
	function CDOTA_BaseNPC:Poisoning(hCaster, hAbility, fDPS, fDuration)
		local tModifiers = self:FindAllModifiersByName("modifier_poisoning")

		local fInterval

		for _, hModifier in pairs(tModifiers) do
			local hA = hModifier:GetAbility()
			if IsValid(hA) and hA:GetAbilityName() == hAbility:GetAbilityName() then
				fDPS = fDPS + (hModifier.fDPS or 0)
				fInterval = math.max(hModifier.fTime - GameRules:GetGameTime(), 0)
				hModifier:Destroy()
			else
				hModifier:SetDuration(fDuration, true)
			end
		end

		self:AddNewModifier(hCaster, hAbility, "modifier_poisoning", {
			fDPS = fDPS,
			fInterval = fInterval,
			duration = fDuration,
		})
	end
	function CDOTA_BaseNPC:Poison(hCaster, hAbility, iCount)
		local poisonInfo, index = CreateHashtable({
			poisoner = hCaster, -- 下毒者
			ability = hAbility, -- 技能
			stack_count = iCount, -- 毒层数
		})
		self:AddNewModifier(hCaster, nil, 'modifier_poison_main', { duration = POISON_DURATION, hashIndex = index })
	end
	function CDOTA_BaseNPC:RemovePoison()
		self:RemoveModifierByName("modifier_poison_main")
	end
	function CDOTA_BaseNPC:GetPoisonStackCount()
		local modifier = self:FindModifierByName("modifier_poison_main")
		if IsValid(modifier) then
			return modifier:GetStackCount()
		else
			return 0
		end
	end
	--[[		流血效果
		hCaster -- 施法者
		hAbility -- 技能
		funcDamgeCallback -- 伤害回调函数，参量(hUnit)，返回number，每移动触发距离后会调用一次该函数获取伤害值
		iDamageType -- 伤害类型
		fDuration -- 持续时间
		fTriggerDistance -- 选填，触发移动距离，不填默认100
	]]
	--
	function CDOTA_BaseNPC:Bleeding(hCaster, hAbility, funcDamgeCallback, iDamageType, fDuration, fTriggerDistance)
		local tModifiers = self:FindAllModifiersByName("modifier_bleeding")

		local vLastPosition
		local fDistance

		for _, hModifier in pairs(tModifiers) do
			if IsValid(hModifier) and IsValid(hModifier:GetAbility()) and IsValid(hAbility) then
				if hModifier:GetAbility():GetAbilityName() == hAbility:GetAbilityName() then
					vLastPosition = hModifier.vLastPosition
					fDistance = hModifier.fDistance
					hModifier:Destroy()
					break
				end
			end
		end

		local hModifier = self:AddNewModifier(hCaster, hAbility, "modifier_bleeding", {
			iDamageType = iDamageType,
			vLastPosition = vLastPosition,
			fDistance = fDistance,
			fTriggerDistance = fTriggerDistance,
			duration = fDuration,
		})

		if IsValid(hModifier) then
			hModifier.funcDamgeCallback = funcDamgeCallback
		end
	end

	if CDOTA_BaseNPC._GetCurrentActiveAbility == nil then
		CDOTA_BaseNPC._GetCurrentActiveAbility = CDOTA_BaseNPC.GetCurrentActiveAbility
	end
	function CDOTA_BaseNPC:GetCurrentActiveAbility()
		local hAbility = self:_GetCurrentActiveAbility()
		if hAbility == nil then
			if self:HasModifier("modifier_passive_cast") then
				local hModifier = self:FindModifierByName("modifier_passive_cast")
				hAbility = hModifier:GetAbility()
			end
			if self:HasModifier("modifier_channel") then
				local hModifier = self:FindModifierByName("modifier_channel")
				hAbility = hModifier:GetAbility()
			end
		end
		return hAbility
	end

	function CDOTA_BaseNPC:IsAbilityReady(ability, func)

		if self:GetCurrentActiveAbility() ~= nil then
			return false
		end

		local behavior = GetAbilityBehavior(ability)

		if ability:GetCaster() ~= self then
			return false
		end

		if ability:IsHidden() then
			return false
		end

		if not ability:IsActivated() then
			return false
		end


		if not ability:IsCooldownReady() then
			return false
		end

		if not ability:IsOwnersManaEnough() then
			return false
		end

		if not ability:IsOwnersGoldEnough(self:GetPlayerOwnerID()) then
			return false
		end

		if self:IsHexed() or self:IsCommandRestricted() then
			return false
		end


		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) ~= DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE and self:IsStunned() then
			-- if behavior:BitwiseAnd(DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE) ~= DOTA_ABILITY_BEHAVIOR_IGNORE_PSEUDO_QUEUE and self:IsStunned() then
			return false
		end

		if not ability:IsItem() and not ability:IsPassive() and self:IsSilenced() then
			return false
		end

		if not ability:IsItem() and ability:IsPassive() and self:PassivesDisabled() then
			return false
		end

		if ability:IsItem() and not ability:IsPassive() and self:IsMuted() then
			return false
		end

		if bit.band(behavior, DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL) ~= DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL and self:IsChanneling() then
			-- if behavior:BitwiseAnd(DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL) ~= DOTA_ABILITY_BEHAVIOR_IGNORE_CHANNEL and self:IsChanneling() then
			return false
		end

		if not ability:IsFullyCastable() then
			return false
		end

		--非战斗阶段不能释放
		if GSManager:getStateType() ~= GS_Battle then
			return false
		end
		if not self:IsAlive() then
			return false
		end
		-- --玩家可控不自动释放
		if self:IsControllableByAnyPlayer() and not ability:IsPassive() then
			return false
		end
		return true
	end

	-- 是否受到诅咒
	function CDOTA_BaseNPC:IsCursed()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_CURSED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_CURSED] > 0 then
			return true
		end
		return false
	end
	-- 是否受到燃烧
	function CDOTA_BaseNPC:IsIgnited()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_IGNITED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_IGNITED] > 0 then
			return true
		end
		return false
	end
	-- 是否受到易伤
	function CDOTA_BaseNPC:IsInjured()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_INJURED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_INJURED] > 0 then
			return true
		end
		return false
	end
	-- 是否受到易伤
	function CDOTA_BaseNPC:IsInjured()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_INJURED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_INJURED] > 0 then
			return true
		end
		return false
	end
	-- 是否中毒
	function CDOTA_BaseNPC:IsPoisoned()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_POISONED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_POISONED] > 0 then
			return true
		end
		return false
	end
	-- 是否霸体
	function CDOTA_BaseNPC:IsTenacited()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_TENACITED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_TENACITED] > 0 then
			return true
		end
		return false
	end
	-- 是否锁定
	function CDOTA_BaseNPC:IsLocked()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_LOCKED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_LOCKED] > 0 then
			return true
		end
		return false
	end
	-- 是否禁止AI
	function CDOTA_BaseNPC:IsAIDisabled()
		if self["_AttributeSystem_State_" .. MODIFIER_STATE_AI_DISABLED] and #self["_AttributeSystem_State_" .. MODIFIER_STATE_AI_DISABLED] > 0 then
			return true
		end
		return false
	end

	function CDOTABaseAbility:IsAbilityReady(...)
		return self:GetCaster():IsAbilityReady(self, ...)
	end

	function PfromC(c)
		if c == 0 then return 1 end
		local pProcOnN = 0
		local pProcByN = 0
		local sumNpProcOnN = 0
		local maxFails = math.ceil(1 / c)
		for N = 1, maxFails, 1 do
			pProcOnN = math.min(1, N * c) * (1 - pProcByN)
			pProcByN = pProcByN + pProcOnN
			sumNpProcOnN = sumNpProcOnN + N * pProcOnN
		end
		return 1 / sumNpProcOnN
	end
	function CfromP(p)
		local Cupper = p
		local Clower = 0
		local Cmid
		local p1
		local p2 = 1
		while true do
			Cmid = (Cupper + Clower) / 2
			p1 = PfromC(Cmid)
			if math.abs(p1 - p2) <= 0 then break end
			if p1 > p then
				Cupper = Cmid
			else
				Clower = Cmid
			end
			p2 = p1
		end
		return Cmid
	end

	PSEUDO_RANDOM_C = {}
	for i = 0, 100 do
		local C = CfromP(i * 0.01)
		PSEUDO_RANDOM_C[i] = C
	end
	function PRD_C(chance)
		chance = math.max(math.min(chance, 100), 0)
		return PSEUDO_RANDOM_C[math.floor(chance)]
	end
	function PRD(table, chance, pseudo_random_recording)
		if table.PSEUDO_RANDOM_RECORDING_LIST == nil then table.PSEUDO_RANDOM_RECORDING_LIST = {} end

		local N = table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] or 1
		local C = PRD_C(chance)
		if RandomFloat(0, 1) <= C * N then
			table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = 1
			return true
		end
		table.PSEUDO_RANDOM_RECORDING_LIST[pseudo_random_recording] = N + 1
		return false
	end

	function CDOTA_BaseNPC:ReplaceItem(old_item, new_item)
		if type(old_item) ~= "table" then return end
		if type(new_item) == "string" then
			new_item = CreateItem(new_item, old_item:GetPurchaser(), old_item:GetPurchaser())
		end
		if type(new_item) ~= "table" then return end
		new_item:SetPurchaseTime(old_item:GetPurchaseTime())
		new_item:SetCurrentCharges(old_item:GetCurrentCharges())
		new_item:SetItemState(old_item:GetItemState())
		local index1 = 0
		for index = 0, 11 do
			local item = self:GetItemInSlot(index)
			if item and item == old_item then
				index1 = index
				break
			end
		end
		self:RemoveItem(old_item)
		self:AddItem(new_item)
		for index2 = 0, 11 do
			local item = self:GetItemInSlot(index2)
			if item and item == new_item then
				self:SwapItems(index2, index1)
				break
			end
		end
		return new_item
	end

	function StringToVector(str)
		local table = string.split(str, " ")
		return Vector(tonumber(table[1]), tonumber(table[2]), tonumber(table[3])) or nil
	end

	--[[		获取某单位范围内单位最多的单位
		搜索点，搜索范围，队伍，范围，队伍过滤，类型过滤，特殊过滤
	]]
	--
	function GetAOEMostTargetsSpellTarget(search_position, search_radius, team_number, radius, team_filter, type_filter, flag_filter, order)
		local targets
		if IsInToolsMode() then
			targets = FindUnitsInRadius(team_number, search_position, nil, search_radius + radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
		else
			targets = Spawner:FindMissingInRadius(team_number, search_position, search_radius + radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER)
		end
		local target
		-- local N = 0
		local iMax = 0
		for i = 1, #targets, 1 do
			local first_target = targets[i]
			local n = 0
			if first_target:IsPositionInRange(search_position, search_radius) then
				if target == nil then target = first_target end
				for j = 1, #targets, 1 do
					-- N = N + 1
					local second_target = targets[j]
					if second_target:IsPositionInRange(first_target:GetAbsOrigin(), radius + second_target:GetHullRadius()) then
						n = n + 1
					end
				end
			end
			if n > iMax then
				target = first_target
				iMax = n
			end
		end
		-- print("O(n):"..N)
		return target
	end
	--[[		获取一定范围内单位最多的点
		搜索点，搜索范围，队伍，范围，队伍过滤，类型过滤，特殊过滤
	]]
	--
	function GetAOEMostTargetsPosition(search_position, search_radius, team_number, radius, team_filter, type_filter, flag_filter, order)
		local targets
		if IsInToolsMode() then
			targets = FindUnitsInRadius(team_number, search_position, nil, search_radius + radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
		else
			targets = Spawner:FindMissingInRadius(team_number, search_position, search_radius + radius, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER)
		end
		local position = vec3_invalid
		-- local N = 0
		if #targets == 1 then
			local vDirection = targets[1]:GetAbsOrigin() - search_position
			vDirection.z = 0
			position = GetGroundPosition(search_position + vDirection:Normalized() * math.min(search_radius - 1, vDirection:Length2D()), nil)
		elseif #targets > 1 then
			local tPoints = {}
			local funcInsertCheckPoint = function(vPoint)
				-- DebugDrawCircle(GetGroundPosition(vPoint, nil), Vector(0, 0, 255), 32, 32, true, 0.5)
				table.insert(tPoints, vPoint)
			end
			-- 取圆中点或交点
			for i = 1, #targets, 1 do
				local first_target = targets[i]
				-- DebugDrawCircle(first_target:GetAbsOrigin(), Vector(0, 255, 0), 32, radius, false, 0.5)
				for j = i + 1, #targets, 1 do
					-- N = N + 1
					local second_target = targets[j]
					local vDirection = second_target:GetAbsOrigin() - first_target:GetAbsOrigin()
					vDirection.z = 0
					local fDistance = vDirection:Length2D()
					if fDistance <= radius * 2 and fDistance > 0 then
						local vMid = (second_target:GetAbsOrigin() + first_target:GetAbsOrigin()) / 2
						if (vMid - search_position):Length2D() <= search_radius then
							table.insert(tPoints, vMid)
						else
							local fHalfLength = math.sqrt(radius ^ 2 - (fDistance / 2) ^ 2)
							local v = Rotation2D(vDirection:Normalized(), math.rad(90))
							local p = {
								vMid - v * fHalfLength,
								vMid + v * fHalfLength,
							}
							for k, vPoint in pairs(p) do
								if (vPoint - search_position):Length2D() <= search_radius then
									table.insert(tPoints, vPoint)
								end
							end
						end
					end
				end
			end
			-- print("O(n):"..N)
			local iMax = 0
			for i = 1, #tPoints, 1 do
				local vPoint = tPoints[i]
				local n = 0
				for j = 1, #targets, 1 do
					-- N = N + 1
					local target = targets[j]
					if target:IsPositionInRange(vPoint, radius + target:GetHullRadius()) then
						n = n + 1
					end
				end
				if n > iMax then
					position = vPoint
					iMax = n
				end
			end
			-- 如果
			if position == vec3_invalid then
				local vDirection = targets[1]:GetAbsOrigin() - search_position
				vDirection.z = 0
				position = GetGroundPosition(search_position + vDirection:Normalized() * math.min(search_radius - 1, vDirection:Length2D()), nil)
			end
		end
		-- print("O(n):"..N)
		-- 获取地面坐标
		if position ~= vec3_invalid then
			position = GetGroundPosition(position, nil)
		end
		-- DebugDrawCircle(position, Vector(0, 255, 255), 32, 64, true, 0.5)
		return position
	end
	--[[		获取一条线上单位最多的施法点
		搜索点，搜索范围，队伍，开始宽度，结束宽度，队伍过滤，类型过滤，特殊过滤
	]]
	--
	function GetLinearMostTargetsPosition(search_position, search_radius, team_number, start_width, end_width, team_filter, type_filter, flag_filter, order)
		local targets
		if IsInToolsMode() then
			targets = FindUnitsInRadius(team_number, search_position, nil, search_radius + end_width, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER, false)
		else
			targets = Spawner:FindMissingInRadius(team_number, search_position, search_radius + end_width, team_filter, type_filter, flag_filter, order or FIND_ANY_ORDER)
		end
		local position = vec3_invalid
		-- local N = 0
		if #targets == 1 then
			local vDirection = targets[1]:GetAbsOrigin() - search_position
			vDirection.z = 0
			position = GetGroundPosition(search_position + vDirection:Normalized() * math.min(search_radius - 1, vDirection:Length2D()), nil)
		elseif #targets > 1 then
			local tPolygons = {}
			local funcInsertCheckPolygon = function(tPolygon)
				-- for i = 1, #tPolygon, 1 do
				-- 	local vP1 = tPolygon[i]
				-- 	local vP2 = tPolygon[i+1]
				-- 	if vP2 == nil then
				-- 		vP2 = tPolygon[1]
				-- 	end
				-- 	DebugDrawLine(vP1, vP2, 255, 0, 0, false, 0.5)
				-- end
				-- DebugDrawCircle(tPolygon[3], Vector(255, 0, 0), 32, end_width, false, 0.5)
				table.insert(tPolygons, tPolygon)
			end
			for i = 1, #targets, 1 do
				local first_target = targets[i]
				for j = i + 1, #targets, 1 do
					-- N = N + 1
					local second_target = targets[j]

					local vDirection1 = first_target:GetAbsOrigin() - search_position
					vDirection1.z = 0
					local vDirection2 = second_target:GetAbsOrigin() - search_position
					vDirection2.z = 0
					local vDirection = (vDirection1 + vDirection2) / 2
					vDirection.z = 0
					local v = Rotation2D(vDirection:Normalized(), math.rad(90))
					local vEndPosition = search_position + vDirection:Normalized() * (search_radius - 1)
					local tPolygon = {
						search_position + v * start_width,
						vEndPosition + v * end_width,
						vEndPosition,
						vEndPosition - v * end_width,
						search_position - v * start_width,
					}
					if (IsPointInPolygon(first_target:GetAbsOrigin(), tPolygon) or first_target:IsPositionInRange(tPolygon[3], end_width + first_target:GetHullRadius()))
					and (IsPointInPolygon(second_target:GetAbsOrigin(), tPolygon) or second_target:IsPositionInRange(tPolygon[3], end_width + second_target:GetHullRadius())) then
						funcInsertCheckPolygon(tPolygon)
					end
				end
				local vDirection = first_target:GetAbsOrigin() - search_position
				vDirection.z = 0
				local v = Rotation2D(vDirection:Normalized(), math.rad(90))
				local vEndPosition = search_position + vDirection:Normalized() * (search_radius - 1)
				local tPolygon = {
					search_position + v * start_width,
					vEndPosition + v * end_width,
					vEndPosition,
					vEndPosition - v * end_width,
					search_position - v * start_width,
				}
				funcInsertCheckPolygon(tPolygon)
			end
			-- print("O(n):"..N)
			local iMax = 0
			for i = 1, #tPolygons, 1 do
				local tPolygon = tPolygons[i]
				local n = 0
				for j = 1, #targets, 1 do
					-- N = N + 1
					local target = targets[j]
					if IsPointInPolygon(target:GetAbsOrigin(), tPolygon) or target:IsPositionInRange(tPolygon[3], end_width + target:GetHullRadius()) then
						n = n + 1
					end
				end
				if n > iMax then
					position = tPolygon[3]
					iMax = n
				end
			end
		end
		-- print("O(n):"..N)
		if position ~= vec3_invalid then
			position = GetGroundPosition(position, nil)
		end
		-- DebugDrawCircle(position, Vector(0, 255, 255), 32, 64, true, 0.5)
		return position
	end

	--[[		获取弹射目标
		现在目标，队伍，选择位置，范围，队伍过滤，类型过滤，特殊过滤，选择方式，单位记录表，是否可以弹射回来（缺省false）
	]]
	--
	function GetBounceTarget(last_target, team_number, position, radius, team_filter, type_filter, flag_filter, order, unit_table, can_bounce_bounced_unit)
		local first_targets = FindUnitsInRadius(team_number, position, nil, radius, team_filter, type_filter, flag_filter, order, false)

		if IsValid(last_target) then
			for i = #first_targets, 1, -1 do
				local unit = first_targets[i]
				if unit == last_target then
					table.remove(first_targets, i)
				end
			end
		end

		local second_targets = {}
		for k, v in pairs(first_targets) do
			second_targets[k] = v
		end

		if unit_table and type(unit_table) == "table" then
			for i = #first_targets, 1, -1 do
				if TableFindKey(unit_table, first_targets[i]) then
					table.remove(first_targets, i)
				end
			end
		end

		local first_target = first_targets[1]
		local second_target = second_targets[1]

		if can_bounce_bounced_unit ~= nil and type(can_bounce_bounced_unit) == "boolean" and can_bounce_bounced_unit == true then
			return first_target or second_target
		else
			return first_target
		end
	end

	--[[		进行分裂操作
		攻击者，攻击目标，开始宽度，结束宽度，距离，操作函数
	]]
	--
	function DoCleaveAction(hAttacker, hTarget, fStartWidth, fEndWidth, fDistance, func, iTeamFilter, iTypeFilter, iFlagFilter)
		local fRadius = math.sqrt(fDistance ^ 2 + (fEndWidth / 2) ^ 2)
		local vStart = hAttacker:GetAbsOrigin()
		local vDirection = hTarget:GetAbsOrigin() - vStart
		vDirection.z = 0
		vDirection = vDirection:Normalized()

		local vEnd = vStart + vDirection * fDistance
		local v = Rotation2D(vDirection, math.rad(90))
		local tPolygon = {
			vStart + v * fStartWidth,
			vEnd + v * fEndWidth,
			vEnd - v * fEndWidth,
			vStart - v * fStartWidth,
		}
		DebugDrawLine(tPolygon[1], tPolygon[2], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[2], tPolygon[3], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[3], tPolygon[4], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		DebugDrawLine(tPolygon[4], tPolygon[1], 255, 255, 255, true, hAttacker:GetSecondsPerAttack())
		local iTeamNumber = hAttacker:GetTeamNumber()
		iTeamFilter = iTeamFilter or (DOTA_UNIT_TARGET_TEAM_ENEMY)
		iTypeFilter = iTypeFilter or (DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC)
		iFlagFilter = iFlagFilter or (DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES + DOTA_UNIT_TARGET_FLAG_NOT_ATTACK_IMMUNE)
		local tTargets
		if IsInToolsMode() then
			tTargets = FindUnitsInRadius(iTeamNumber, vStart, nil, fRadius + 100, iTeamFilter, iTypeFilter, iFlagFilter, FIND_CLOSEST, false)
		else
			tTargets = Spawner:FindMissingInRadius(iTeamNumber, vStart, fRadius + 100, iTeamFilter, iTypeFilter, iFlagFilter, FIND_CLOSEST)
		end
		for _, hUnit in pairs(tTargets) do
			if hUnit ~= hTarget then
				if IsPointInPolygon(hUnit:GetAbsOrigin(), tPolygon) then
					if func(hUnit) == true then
						break
					end
				end
			end
		end
	end

	ONLY_REFLECT_ABILITIES = {}
	function IsAbilityOnlyReflect(ability)
		if ability == nil then return false end
		return TableFindKey(ONLY_REFLECT_ABILITIES, ability:GetName()) ~= nil
	end

	function IsReflectSpellAbility(ability)
		if ability == nil then return false end
		return ability:IsStolen() and ability:IsHidden()
	end

	function ReflectSpell(caster, target, ability)
		if IsReflectSpellAbility(ability) then
			return
		end

		local sAbilityName = ability:GetAbilityName()
		local hAbility
		caster.reflectSpellAbilities = caster.reflectSpellAbilities or { max_count = 5 }
		for i, ab in ipairs(caster.reflectSpellAbilities) do
			if ab:GetAbilityName() == sAbilityName then
				hAbility = ab
			end
		end
		if hAbility == nil then
			hAbility = caster:AddAbility(sAbilityName)
			table.insert(caster.reflectSpellAbilities, 1, hAbility)
			if IsValid(caster.reflectSpellAbilities[caster.reflectSpellAbilities.max_count + 1]) then
				caster.reflectSpellAbilities[caster.reflectSpellAbilities.max_count + 1]:RemoveSelf()
				caster.reflectSpellAbilities[caster.reflectSpellAbilities.max_count + 1] = nil
			end
		end

		hAbility:SetStolen(true)
		hAbility:SetHidden(true)
		hAbility:SetLevel(ability:GetLevel())
		caster:RemoveModifierByName(hAbility:GetIntrinsicModifierName() or "")
		hAbility.GetIntrinsicModifierName = function(self) return "" end

		local hRecordTarget = caster:GetCursorCastTarget()
		caster:SetCursorCastTarget(target)
		hAbility:OnSpellStart()
		caster:SetCursorCastTarget(hRecordTarget)
	end

	function CreateIllusion(hUnit, vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber, fDuration, fOutgoingDamage, fIncomingDamage)
		-- local illusions = CreateIllusions(hOwner, self, tModifierKeys, nNumIllusions, nPadding, bScramblePosition, bFindClearSpace)
		local illusion = CreateUnitByName(hUnit:GetUnitName(), vLocation, bFindClearSpace, hNPCOwner, hUnitOwner, iTeamNumber)
		illusion:FireIllusionSummonned(hUnit)
		Attributes:Register(illusion)

		illusion:MakeIllusion()
		illusion:SetForwardVector(hUnit:GetForwardVector())

		if hUnit:IsBuilding() then
			illusion.GetBuilding = hUnit.GetBuilding
			illusion.IsBuilding = hUnit.IsBuilding
		end

		if IsValid(hUnitOwner) then
			if hUnitOwner:IsControllableByAnyPlayer() then
				illusion:SetControllableByPlayer(hUnitOwner:GetPlayerOwnerID(), not bFindClearSpace)
			end
			if not hUnitOwner.tIllusions then hUnitOwner.tIllusions = {} end
			table.insert(hUnitOwner.tIllusions, illusion)
		end
		local iLevel = hUnit:GetLevel()

		for i = illusion:GetLevel(), iLevel - 1 do
			illusion:LevelUp(false)
		end

		for i = 0, hUnit:GetAbilityCount() - 1 do
			local ability = hUnit:GetAbilityByIndex(i)
			if ability ~= nil then
				local illusion_ability = illusion:FindAbilityByName(ability:GetAbilityName())
				if illusion_ability == nil then
					illusion_ability = illusion:AddAbility(ability:GetAbilityName())
				end
				if illusion_ability ~= nil then
					if illusion_ability:GetLevel() < ability:GetLevel() then
						while illusion_ability:GetLevel() < ability:GetLevel() do
							illusion_ability:UpgradeAbility(true)
						end
					elseif illusion_ability:GetLevel() >= ability:GetLevel() then
						illusion_ability:SetLevel(ability:GetLevel())
						if illusion_ability:GetLevel() == 0 then
							if illusion_ability:GetAutoCastState() then illusion_ability:ToggleAutoCast() end
							if illusion_ability:GetToggleState() then illusion_ability:ToggleAbility() end

							illusion:RemoveModifierByName(illusion_ability:GetIntrinsicModifierName() or "")
						end
					end
				end
			end
		end

		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local item = illusion:GetItemInSlot(i)
			if item ~= nil then
				item:RemoveSelf()
			end
		end
		for i = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
			local item = hUnit:GetItemInSlot(i)
			if item ~= nil then
				local illusion_item = CreateItem(item:GetName(), illusion, illusion)
				if IsValid(illusion_item) then
					illusion:AddItem(illusion_item)
					for j = DOTA_ITEM_SLOT_1, DOTA_ITEM_SLOT_9 do
						local _item = illusion:GetItemInSlot(j)
						if _item == illusion_item then
							if i ~= j then illusion:SwapItems(i, j) end
							break
						end
					end
					illusion_item:EndCooldown()
					illusion_item:SetPurchaser(nil)
					illusion_item:SetShareability(ITEM_FULLY_SHAREABLE)
					illusion_item:SetPurchaseTime(item:GetPurchaseTime())
					illusion_item:SetCurrentCharges(item:GetCurrentCharges())
					illusion_item:SetItemState(item:GetItemState())
					if illusion_item:GetToggleState() ~= item:GetToggleState() then
						illusion_item:ToggleAbility()
					end
					if illusion_item:GetAutoCastState() ~= item:GetAutoCastState() then
						illusion_item:ToggleAutoCast()
					end
				end
			end
		end

		-- local modifiers = hUnit:FindAllModifiers()
		-- for i, modifier in pairs(modifiers) do
		-- 	if modifier.AllowIllusionDuplicate and modifier:AllowIllusionDuplicate() then
		-- 		local illusion_modifier = illusion:AddNewModifier(modifier:GetCaster(), modifier:GetAbility(), modifier:GetName(), nil)
		-- 	end
		-- end
		if IsValid(hUnitOwner) then
			illusion:AddNewModifier(hUnitOwner, nil, "modifier_illusion", { duration = fDuration, outgoing_damage = fOutgoingDamage - 100, incoming_damage = fIncomingDamage - 100 })
		end

		illusion:AddNewModifier(illusion, nil, "modifier_star_indicator", nil)
		if 100 ~= fOutgoingDamage then
			illusion:SetVal(ATTRIBUTE_KIND.OutgoingPercentage, fOutgoingDamage - 100, ATTRIBUTE_KEY.BASE)
		end

		illusion:SetHealth(hUnit:GetHealth())
		illusion:SetMana(hUnit:GetMana())

		local particleID = ParticleManager:CreateParticle("particles/generic_gameplay/illusion_created.vpcf", PATTACH_ABSORIGIN_FOLLOW, illusion)
		ParticleManager:ReleaseParticleIndex(particleID)

		return illusion
	end
	function CDOTA_BaseNPC:EachIllusions(func)
		if self.tIllusions then
			local tIllusions = shallowcopy(self.tIllusions)
			for i, hUnit in ipairs(tIllusions) do
				if IsValid(hUnit) then
					if func(hUnit) then
						return
					end
				else
					remove(self.tIllusions, hUnit)
				end
			end
		end
	end

	function FireModifiersEvents(iModifierFunction, params)
		if params.attacker ~= nil and params.attacker.tModifierEvents and params.attacker.tModifierEvents[iModifierFunction] then
			local tModifiers = params.attacker.tModifierEvents[iModifierFunction]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(params.attacker) and IsValid(hModifier) and hModifier[MODIFIER_FUNCTION_NAME[iModifierFunction]] then
					hModifier[MODIFIER_FUNCTION_NAME[iModifierFunction]](hModifier, params)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		if params.unit ~= nil and params.unit.tModifierEvents and params.unit.tModifierEvents[iModifierFunction] then
			local tModifiers = params.unit.tModifierEvents[iModifierFunction]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(params.unit) and IsValid(hModifier) and hModifier[MODIFIER_FUNCTION_NAME[iModifierFunction]] then
					hModifier[MODIFIER_FUNCTION_NAME[iModifierFunction]](hModifier, params)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		if tModifierEvents and tModifierEvents[iModifierFunction] then
			local tModifiers = tModifierEvents[iModifierFunction]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier[MODIFIER_FUNCTION_NAME[iModifierFunction]] then
					hModifier[MODIFIER_FUNCTION_NAME[iModifierFunction]](hModifier, params)
				else
					table.remove(tModifiers, i)
				end
			end
		end
	end

	-- 召唤一个单位
	function CDOTA_BaseNPC:Summon(sUnitName, vPosition)
		vPosition = self:GetAbsOrigin()
		local hUnit = CreateUnitByName(sUnitName, vPosition, true, self, self, self:GetTeamNumber())
		hUnit:FireSummonned(self)
		Attributes:Register(hUnit)
		return hUnit
	end

	function CDOTA_BaseNPC:GetSummoner()
		return self.hSummoner
	end

	function CDOTA_BaseNPC:FireClone(unit)
		self.hSummoner = unit
		self.IsClone = function(self)
			return true
		end
		local hOnwer = unit
		if IsValid(hOnwer) then
			if not hOnwer.tClones then hOnwer.tClones = {} end
			table.insert(hOnwer.tClones, self)
		end

		---@class EventData_ON_CLONED
		local tEvent = {
			unit = unit,
			target = self,
		}
		EventManager:fireEvent(ET_GAME.ON_CLONED, tEvent)
	end
	function CDOTA_BaseNPC:EachClones(func)
		if self.tClones then
			local tClones = shallowcopy(self.tClones)
			for i, hUnit in ipairs(tClones) do
				if IsValid(hUnit) then
					if func(hUnit) then
						return
					end
				else
					remove(self.tClones, hUnit)
				end
			end
		end
	end

	function CDOTA_BaseNPC:FireSummonned(unit)
		self.hSummoner = unit
		self.IsSummoned = function(self)
			return true
		end
		local hOnwer = unit
		if IsValid(hOnwer) then
			if not hOnwer.tSummoners then hOnwer.tSummoners = {} end
			table.insert(hOnwer.tSummoners, self)
		end

		---@class EventData_ON_SUMMONED
		local tEvent = {
			unit = unit,
			target = self,
		}
		EventManager:fireEvent(ET_GAME.ON_SUMMONED, tEvent)
	end
	function CDOTA_BaseNPC:EachSummoners(func)
		if self.tSummoners then
			local tSummoners = shallowcopy(self.tSummoners)
			for i, hUnit in ipairs(tSummoners) do
				if IsValid(hUnit) then
					if func(hUnit) then
						return
					end
				else
					remove(self.tSummoners, hUnit)
				end
			end
		end
	end

	function CDOTA_BaseNPC:FireIllusionSummonned(unit)
		self.hSummoner = unit

		---@class EventData_ON_ILLUSION
		local tEvent = {
			unit = unit,
			target = self,
		}
		EventManager:fireEvent(ET_GAME.ON_ILLUSION, tEvent)
	end

	function CDOTA_BaseNPC:FireTeleported(position)
		---@class EventData_ON_TELEPORTED
		local tEvent = {
			unit = self,
			position = position,
		}
		EventManager:fireEvent(ET_GAME.ON_TELEPORTED, tEvent)

		if IsValid(tEvent.unit) and tEvent.unit.tSourceModifierEvents and tEvent.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTED] then
			local tModifiers = tEvent.unit.tSourceModifierEvents[MODIFIER_EVENT_ON_TELEPORTED]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(tEvent.unit) and IsValid(hModifier) and hModifier.OnTeleported then
					hModifier:OnTeleported(tEvent)
				else
					table.remove(tModifiers, i)
				end
			end
		end
		if tModifierEvents and tModifierEvents[MODIFIER_EVENT_ON_TELEPORTED] then
			local tModifiers = tModifierEvents[MODIFIER_EVENT_ON_TELEPORTED]
			for i = #tModifiers, 1, -1 do
				local hModifier = tModifiers[i]
				if IsValid(hModifier) and hModifier.OnTeleported then
					hModifier:OnTeleported(tEvent)
				else
					table.remove(tModifiers, i)
				end
			end
		end
	end

	---获取召唤，克隆，幻象的原始单位
	function CDOTA_BaseNPC:GetSource()
		if self:IsSummoned() or self:IsClone() or self:IsIllusion() then
			return IsValid(self:GetSummoner()) and self:GetSummoner() or self
		end
		return self
	end
	---是否是目标单位(召唤，克隆，幻象等)单位的原始单位
	function IsSourceUnit(hSource, hSon)
		if hSon == hSource then
			return true
		end
		local hSource2 = hSon
		for i = 1, 100 do
			hSource2 = hSource2:GetSource()
			if hSource2 == hSon then
				break
			end
			if hSource2 == hSource then
				return true
			end
		end
		return false
	end
	---是否是目标单位(召唤，克隆，幻象等)单位的原始单位
	function CDOTA_BaseNPC:IsSourceUnit(hSon)
		return IsSourceUnit(self, hSon)
	end

	--是否飞行单位
	function CDOTA_BaseNPC:IsFlyUnit()
		return self:IsRangedAttacker()
	end

	-- 获取单位普攻伤害类型
	function CDOTA_BaseNPC:GetAttackDamageType()
		return KeyValues.UnitsKv[self:GetUnitName()].AttackDamageTypeCustom
	end

	--- 获取玩家ID
	function GetPlayerID(hUnit)
		local iPlayerID = -1
		if not IsValid(hUnit) then
			return iPlayerID
		end
		if hUnit.Spawner_spawnerPlayerID then
			iPlayerID = hUnit.Spawner_spawnerPlayerID
		elseif hUnit.GetPlayerOwnerID then
			iPlayerID = hUnit:GetPlayerOwnerID()
		elseif hUnit.GetPlayerID then
			iPlayerID = hUnit:GetPlayerID()
		end

		if iPlayerID == -1 and hUnit.GetOwner and IsValid(hUnit:GetOwner()) then
			return GetPlayerID(hUnit:GetOwner())
		end

		return iPlayerID
	end
	--- 设置玩家ID
	function SetPlayerID(tTabel, iPlayerID)
		if nil ~= tTabel then
			tTabel.Spawner_spawnerPlayerID = iPlayerID
		end
	end

	--- 开始技能CD
	function StartCooldown(hAbility)
		if IsValid(hAbility) then
			local cd = hAbility:GetCooldown(hAbility:GetLevel() - 1)
			hAbility:StartCooldown(cd)
		end
	end

	if not CDOTABaseAbility._SetLevel then
		CDOTABaseAbility._SetLevel = CDOTABaseAbility.SetLevel
		function CDOTABaseAbility:SetLevel(iLevel, ...)
			CDOTABaseAbility._SetLevel(self, iLevel, ...)
			if iLevel <= 0 then
				if self:GetIntrinsicModifierName() and IsValid(self:GetCaster()) then
					self:GetCaster():RemoveModifierByName(self:GetIntrinsicModifierName())
				end
			end
		end
	end
	-- 保存技能数据
	function CDOTABaseAbility:Save(key, value)
		local tAbilityData = PlayerData:GetAbilityData(self:GetCaster(), self:IsItem() and Items:GetItemDataByItemEntIndex(self:entindex(), GetPlayerID(self:GetCaster())) or self:GetAbilityName())
		if tAbilityData then
			tAbilityData[key] = value
		end
	end
	function CDOTA_BaseNPC:Save(key, value)
		local tAbilityData = PlayerData:GetAbilityData(self, self:GetUnitName())
		if tAbilityData then
			tAbilityData[key] = value
		end
	end
	-- 加载技能数据
	function CDOTABaseAbility:Load(key)
		local tAbilityData = PlayerData:GetAbilityData(self:GetCaster(), self:IsItem() and Items:GetItemDataByItemEntIndex(self:entindex(), GetPlayerID(self:GetCaster())) or self:GetAbilityName())
		return tAbilityData and tAbilityData[key] or 0
	end
	function CDOTA_BaseNPC:Load(key)
		local tAbilityData = PlayerData:GetAbilityData(self, self:GetUnitName())
		return tAbilityData and tAbilityData[key] or 0
	end

	function CDOTA_BaseNPC:KnockBack(vCenter, hTarget, flDistance, flHeight, flDuration, bStun, flKnockbackDuration, bIgnoreStatusResistance)
		if bIgnoreStatusResistance == nil then
			bIgnoreStatusResistance = false
		end
		if GetStatusDebuffDuration(flDuration, hTarget, CDOTA_BaseNPC) == 0 and bIgnoreStatusResistance == false then
			return
		end
		local kv =		{
			center_x = vCenter.x,
			center_y = vCenter.y,
			center_z = vCenter.z,
			should_stun = bStun,
			duration = flDuration,
			knockback_duration = flKnockbackDuration or flDuration,
			knockback_distance = flDistance,
			knockback_height = flHeight,
		}
		hTarget:AddNewModifier(self, nil, "modifier_knockback", kv)
	end

	-- 被动施法模拟动作
	---@param hAbility CDOTABaseAbility 技能，自动调用kv里的施法前摇与动作
	---@param iOrderType DOTA_UNIT_ORDERS DOTA_UNIT_ORDER_CAST_POSITION | DOTA_UNIT_ORDER_CAST_TARGET | DOTA_UNIT_ORDER_CAST_NO_TARGET
	---@param tExtraData table 可选参数: vPosition, hTarget, iAnimationRate, bFadeAnimation, sActivityModifier, tCallBackParams, flCastPoint, iCastAnimation, bIgnoreBackswing, bUseCooldown, OnAbilityPhaseStart, OnAbilityPhaseInterrupted
	---@param func function 回调，默认调用技能的OnSpellStart
	function CDOTA_BaseNPC:PassiveCast(hAbility, iOrderType, tExtraData, func)
		if not IsValid(hAbility) then return end

		-- 默认值
		if tExtraData == nil then tExtraData = {} end
		local flCastPoint = tExtraData.flCastPoint or hAbility:GetCastPoint()
		local iCastAnimation = tExtraData.iCastAnimation or hAbility:GetCastAnimation()
		-- 处理sActivityModifier
		local sActivityModifier = tExtraData.sActivityModifier
		if tExtraData.sActivityModifier and type(tExtraData.sActivityModifier) == "table" then
			sActivityModifier = string.join(tExtraData.sActivityModifier, ",")
		end
		-- 使用modifier模拟前摇
		local tData = {
			duration = flCastPoint,
			flCastPoint = flCastPoint,
			iCastAnimation = iCastAnimation,
			iOrderType = iOrderType,
			iAnimationRate = tExtraData.iAnimationRate,
			vPosition = tExtraData.vPosition,
			iTargetIndex = IsValid(tExtraData.hTarget) and tExtraData.hTarget:entindex() or nil,
			bFadeAnimation = tExtraData.bFadeAnimation,
			sActivityModifier = sActivityModifier,
			bIgnoreBackswing = tExtraData.bIgnoreBackswing or true,
			bUseCooldown = (tExtraData.bUseCooldown == nil or tExtraData.bUseCooldown == true) and 1 or 0,
		}
		-- 自定义施法抬手与打断
		hAbility.CustomAbilityPhaseStart = tExtraData.OnAbilityPhaseStart
		hAbility.CustomAbilityPhaseInterrupted = tExtraData.OnAbilityPhaseInterrupted

		local hModifier = self:AddNewModifier(self, hAbility, "modifier_passive_cast", tData)
		if IsValid(hModifier) then
			hModifier.callback = func
		end
	end

	if CDOTA_BaseNPC._AddActivityModifier == nil then
		CDOTA_BaseNPC._AddActivityModifier = CDOTA_BaseNPC.AddActivityModifier
	end

	function CDOTA_BaseNPC:_updateActivityModifier()
		if not IsValid(self) then return end
		if self.tActivityModifiers == nil then self.tActivityModifiers = {} end

		self:ClearActivityModifiers()

		for i = #self.tActivityModifiers, 1, -1 do
			self:_AddActivityModifier(self.tActivityModifiers[i])
		end
	end

	function CDOTA_BaseNPC:HasActivityModifier(sName)
		if self.tActivityModifiers == nil then self.tActivityModifiers = {} end
		return TableFindKey(self.tActivityModifiers, sName) ~= nil
	end

	function CDOTA_BaseNPC:AddActivityModifier(sName)
		if not IsValid(self) then return end
		if self.tActivityModifiers == nil then self.tActivityModifiers = {} end

		table.insert(self.tActivityModifiers, sName)

		self:_updateActivityModifier(self)
	end

	function CDOTA_BaseNPC:RemoveActivityModifier(sName)
		if not IsValid(self) then return end
		if self.tActivityModifiers == nil then self.tActivityModifiers = {} end

		ArrayRemove(self.tActivityModifiers, sName)

		self:_updateActivityModifier(self)
	end

	---单位类型
	UnitType = {
		---建筑单位
		Building = 1,
		---指挥官
		Commander = 2,
		---幻象
		Illusion = 4,
		---克隆体
		Clone = 8,
		---召唤怪
		Summoner = 16,
		---进攻怪
		Enemy = 32,
		---全部友军（建筑，指挥官，和他们的幻象，克隆体，召唤物）
		AllFirends = nil,
		---全部敌军（进攻怪，和他们的幻象，克隆体，召唤物）
		AllEnemies = nil,
		---全部衍生物（幻象，克隆体，召唤物）
		AllDerivatives = nil,
		---全部
		All = nil,
	}
	UnitType.AllFirends = UnitType.Building + UnitType.Commander + UnitType.Illusion + UnitType.Clone + UnitType.Summoner
	UnitType.AllEnemies = UnitType.Enemy + UnitType.Illusion + UnitType.Clone + UnitType.Summoner
	UnitType.AllDerivatives = UnitType.Illusion + UnitType.Clone + UnitType.Summoner
	UnitType.All = bit.bor(UnitType.AllFirends, UnitType.AllEnemies)

	--- 遍历单位
	---@param func function function(hUnit)` 返回 `true` 停止遍历
	---@param iPlayerID number 玩家ID,不填则遍历全部玩家
	---@param typeUnit UnitType 遍历的单位类型，默认 UnitType.All
	function EachUnits(iPlayerID, func, typeUnit)
		if 'function' == type(iPlayerID) then
			typeUnit = func
			func = iPlayerID
			iPlayerID = nil
		end
		if nil == typeUnit then
			typeUnit = UnitType.All
		end

		if not iPlayerID or -1 == iPlayerID then
			DotaTD:EachPlayer(function(_, iPlayerID)
				return EachUnits(iPlayerID, func, typeUnit)
			end)
			return
		end

		local bReturn = false

		local tHasType = {}
		for type, v in pairs(UnitType) do
			tHasType[UnitType[type]] = 0 < bit.band(typeUnit, UnitType[type])
		end

		local function doonce(hUnit)
			if func(hUnit) then return true end

			--幻象
			if tHasType[UnitType.Illusion] then
				hUnit:EachIllusions(function(hUnit2)
					if doonce(hUnit2) then
						bReturn = true
						return true
					end
				end)
				if bReturn then return true end
			end

			--克隆
			if tHasType[UnitType.Clone] then
				hUnit:EachClones(function(hUnit2)
					if doonce(hUnit2) then
						bReturn = true
						return true
					end
				end)
				if bReturn then return true end
			end

			--召唤单位
			if tHasType[UnitType.Summoner] then
				hUnit:EachSummoners(function(hUnit2)
					if doonce(hUnit2) then
						bReturn = true
						return true
					end
				end)
			end
			return bReturn
		end

		--指挥官
		if tHasType[UnitType.Commander] then
			local hUnit = Commander:GetCommander(iPlayerID)
			if IsValid(hUnit) and doonce(hUnit) then return true end
		end

		--建筑棋子
		if tHasType[UnitType.Building] then
			BuildSystem:EachBuilding(iPlayerID, function(_, _, iEndID)
				local hUnit = EntIndexToHScript(iEndID)
				if IsValid(hUnit) and doonce(hUnit) then
					bReturn = true
					return true
				end
			end)
			if bReturn then return true end
		end

		--进攻怪
		if tHasType[UnitType.Enemy] then
			Spawner:EachEnemies(iPlayerID, function(hUnit)
				if IsValid(hUnit) and doonce(hUnit) then
					bReturn = true
					return true
				end
			end)
			if bReturn then return true end
		end
		return bReturn
	end
	--- 判断单位类型
	function CheckUnitType(iPlayerID, hUnit, typeUnit)
		if PlayerResource:IsValidPlayer(iPlayerID) and GetPlayerID(hUnit) ~= iPlayerID then
			return false
		end

		local tHasType = {}
		for type, v in pairs(UnitType) do
			tHasType[UnitType[type]] = 0 < bit.band(typeUnit, UnitType[type])
		end

		--指挥官
		if tHasType[UnitType.Commander] then
			if IsCommanderTower(hUnit) then
				return true
			end
		end
		--建筑棋子
		if tHasType[UnitType.Building] then
			if hUnit.IsBuilding and hUnit:IsBuilding() then
				return true
			end
		end
		--进攻怪
		if tHasType[UnitType.Enemy] then
			if hUnit:IsWave() then
				return true
			end
		end
		--幻象
		if tHasType[UnitType.Illusion] then
			if hUnit:IsIllusion() then
				return true
			end
		end
		--克隆
		if tHasType[UnitType.Clone] then
			if hUnit:IsClone() then
				return true
			end
		end
		--召唤单位
		if tHasType[UnitType.Summoner] then
			if hUnit:IsSummoned() then
				return true
			end
		end
		return false
	end


	--单位删除移除buff
	function CDOTA_BaseNPC:RemoveAllModifier()
		if IsValid(self) then
			local tBuffs = self:FindAllModifiers()
			for _, hBuff in pairs(tBuffs) do
				if IsValid(hBuff) then
					hBuff:Destroy()
				end
			end
		end
	end
	function CEntityInstance:RemoveSelf()
		UTIL_Remove(self)
	end
	function CEntityInstance:Destroy()
		UTIL_Remove(self)
	end
	if not _G._UTIL_Remove then _G._UTIL_Remove = _G.UTIL_Remove end
	function _G.UTIL_Remove(hEnt)
		if hEnt.RemoveAllModifier then hEnt:RemoveAllModifier() end
		return _G._UTIL_Remove(hEnt)
	end
	if not _G._UTIL_RemoveImmediate then _G._UTIL_RemoveImmediate = _G.UTIL_RemoveImmediate end
	function _G.UTIL_RemoveImmediate(hEnt)
		if hEnt.RemoveAllModifier then hEnt:RemoveAllModifier() end
		return _G._UTIL_RemoveImmediate(hEnt)
	end
end

local BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC
---是否精英怪物
function BaseNPC:IsElite()
	return self:GetUnitLabel() == 'elite'
end
---是否小怪
function BaseNPC:IsCreep()
	return self:GetUnitLabel() == 'creep'
end
function BaseNPC:IsBoss()
	return not not KeyValues.BossKv[self:GetUnitName()]
end
function BaseNPC:IsGoldWave()
	return self:GetUnitLabel() == 'gold'
end
function BaseNPC:SetWaveTag(tag)
	self.b_wave_tage = tag and true or false
end
function BaseNPC:IsWave()
	return self.b_wave_tage
end

function GetAbilityBehavior(hAblt)
	return hAblt:GetBehaviorInt()
end

--- 用唯一ID获取通用天赋技能
function GetTalentGeneralAbltKVByID(sID)
	local tAbltKV
	for k, v in pairs(KeyValues.AbilitiesKv) do
		if type(v) == 'table' and v.UniqueID then
			if tostring(v.UniqueID) == tostring(sID) then
				return k, v
			end
		end
	end
end
--- 获取玩家某天赋技能的等级
function GetPlayerTalentLevel(iPlayerID, sAbltName)
	local sID = GetAbilityUniqueID(sAbltName)
	if sID then
		local tTalent = NetEventData:GetTableValue('service', 'player_talent_' .. iPlayerID)
		if tTalent then
			return tTalent[sID] or 0
		end
	end
	return 0
end
---@return string
function GetAbilityUniqueID(sAbltName)
	local tKV = KeyValues.AbilitiesKv[sAbltName]
	if tKV then
		return tostring(tKV.UniqueID)
	end
end
--- 获取技能图标
function GetAbilityTexture(sAbltName)
	local tKV = KeyValues.AbilitiesKv[sAbltName]
	if tKV then
		return tKV.AbilityTextureName
	end
end