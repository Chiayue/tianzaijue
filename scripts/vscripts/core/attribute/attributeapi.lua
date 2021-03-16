---注册属性
function AttributeRegister(hUnit)
	local sHeroName = hUnit:GetUnitName()
	local tData = KeyValues.UnitsKv[sHeroName]

	hUnit:AddNewModifier(hUnit, nil, 'modifier_attribute_register', { duration = 0.5 })
	hUnit:AddNewModifier(hUnit, nil, 'modifier_attribute_getter', nil)

	--攻击类型
	local ATTRIBUTE_ATTACK_TYPE = {
		Physical = 1,
		Magical = 2,
		Both = 3,
		Pure = 4,
	}
	local typeAttack = tData and tData.AttackDamageTypeCustom or ''
	if typeAttack == 'Physical' then
		typeAttack = ATTRIBUTE_ATTACK_TYPE.Physical
	elseif typeAttack == 'Magical' then
		typeAttack = ATTRIBUTE_ATTACK_TYPE.Magical
	elseif typeAttack == 'Mix' then
		typeAttack = ATTRIBUTE_ATTACK_TYPE.Both
	end

	--基础攻击技能
	local hAtkAblt
	for i = 0, hUnit:GetAbilityCount() - 1, 1 do
		local hAbility = hUnit:GetAbilityByIndex(i)
		if hAbility then
			if hAbility._base_attack then
				hAtkAblt = hAbility
				break
			end
		end
	end
	--没有配置攻击技能，这里添加默认
	if not hAtkAblt then
		local sName = 'base_attack_' .. sHeroName
		if not KeyValues.AbilitiesKv[sName] then
			if typeAttack == '' then
				sName = 'base_attack'
			else
				sName = 'base_attack_' .. typeAttack
			end
		end
		if not hUnit:HasAbility(sName) then
			hAtkAblt = hUnit:AddAbility(sName)
			if hAtkAblt then
				hAtkAblt:SetLevel(1)
			end
		end
	end
end


---@type AttributeSystem
local public = AttributeSystem
local Percentage_Multiply = AttributeInterface.Percentage_Multiply
local Percentage_InverseMultiply = AttributeInterface.Percentage_InverseMultiply
local Percentage_InverseMultiply_Base0 = AttributeInterface.Percentage_InverseMultiply_Base0
local Random_Max = AttributeInterface.Random_Max
local StringValue = AttributeInterface.StringValue
local Level_Max = AttributeInterface.Level_Max
local Level_First = AttributeInterface.Level_First
local FunctionValue = AttributeInterface.FunctionValue
local LevelFunction = AttributeInterface.LevelFunction
local LevelFunction_Max = AttributeInterface.LevelFunction_Max


--攻击伤害************************************************************************************************************************
	do
	---组合攻击record和order
	function EncodeAttackRecord(iAttackRecord, iAttackOrder)
		if 1000 <= iAttackRecord then return iAttackRecord end
		return iAttackRecord + (iAttackOrder or AttributeSystem.iAttackRecordOrder) * 1000
	end
	---解析攻击record组合
	---@return number,number record,order
	function DecodeAttackRecord(iAttackRecord)
		if 1000 <= iAttackRecord then
			local iOrder = math.floor(iAttackRecord / 1000)
			return iAttackRecord - iOrder * 1000, iOrder
		else
			return iAttackRecord, (AttributeSystem.iAttackRecordOrder or 1)
		end
	end
	---添加攻击信息
	---@param tAttackInfo AttackInfo
	function AddAttackInfo(tAttackInfo)
		if AttributeSystem.iAttackRecordLast > tAttackInfo.record then
			AttributeSystem.iAttackRecordOrder = 1 + AttributeSystem.iAttackRecordOrder
		end
		AttributeSystem.iAttackRecordLast = tAttackInfo.record

		tAttackInfo.record_order = AttributeSystem.iAttackRecordOrder
		tAttackInfo.record_base = tAttackInfo.record
		tAttackInfo.record = EncodeAttackRecord(tAttackInfo.record_base, tAttackInfo.record_order)
		AttributeSystem.tAttackInfos[tAttackInfo.record] = tAttackInfo
	end
	---获取攻击信息
	function GetAttackInfo(iAttackRecord, hAtker)
		if not iAttackRecord then return end
		if 1000 > iAttackRecord then
			-- 未知的order
			for i = AttributeSystem.iAttackRecordOrder, math.max(AttributeSystem.iAttackRecordOrder - 10, 1), -1 do
				local tInfo = AttributeSystem.tAttackInfos[EncodeAttackRecord(iAttackRecord, i)]
				if tInfo then
					if not hAtker or hAtker == tInfo.attacker then
						return tInfo
					end
				end
			end
		else
			return AttributeSystem.tAttackInfos[iAttackRecord]
		end
	end
	---注销攻击信息
	function DelAttackInfo(iAttackRecord)
		if not iAttackRecord then return end
		local tAttackInfo = GetAttackInfo(iAttackRecord)
		if nil == tAttackInfo then return end
		--
		EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_RECORD_DESTROY, tAttackInfo)

		--删除伤害record
		for iDamageRecord, t in pairs(tAttackInfo.tDamageRecords) do
			tAttackInfo.attacker._tBaseAttackDamageRecords[iDamageRecord] = nil
		end

		--删除攻击record
		AttributeSystem.tAttackInfos[tAttackInfo.record] = nil
	end
	---用伤害record获取攻击信息
	function GetAttackInfoByDamageRecord(iDamageRecord, hAtker)
		if hAtker._tBaseAttackDamageRecords then
			local tDamageRecord = hAtker._tBaseAttackDamageRecords[iDamageRecord]
			if tDamageRecord then
				return GetAttackInfo(tDamageRecord.attack_record)
			end
		end
	end
	---获取攻击造成的所有伤害record
	---@param hTarget handel 选参，伤害目标
	function GetAttackDamageRecords(iAttackRecord, hTarget)
		local tAttackInfo = GetAttackInfo(iAttackRecord)
		if not hTarget then
			return tAttackInfo.tDamageRecords
		end
		local t = {}
		for iDamageRecord, tParams in pairs(tAttackInfo.tDamageRecords) do
			if tParams.target == hTarget then
				t[iDamageRecord] = tParams
			end
		end
		return t
	end

	---攻击是否被MISS
	function IsAttackMiss(iRecord_or_tAttackInfo)
		local tAttackInfo = iRecord_or_tAttackInfo
		if 'number' == type(iRecord_or_tAttackInfo) then
			tAttackInfo = GetAttackInfo(iRecord_or_tAttackInfo)
		end
		if tAttackInfo then
			for _, tDamageData in pairs(tAttackInfo.tDamageInfo) do
				if 0 < tDamageData.damage_base and bit.band(tDamageData.damage_flags, DOTA_DAMAGE_FLAG_MISS) == DOTA_DAMAGE_FLAG_MISS then
					return true
				end
			end
		end
		return false
	end
	---攻击是否暴击
	function IsAttackCrit(iRecord_or_tAttackInfo)
		local tAttackInfo = iRecord_or_tAttackInfo
		if 'number' == type(iRecord_or_tAttackInfo) then
			tAttackInfo = GetAttackInfo(iRecord_or_tAttackInfo)
		end
		if tAttackInfo then
			return IsDamageCrit(tAttackInfo.tDamageInfo)
		end
		return false
	end
	function IsDamageCrit(tDamageInfo)
		for _, tDamageData in pairs(tDamageInfo) do
			if 0 < tDamageData.damage_base and bit.band(tDamageData.damage_flags, DOTA_DAMAGE_FLAG_CRIT) == DOTA_DAMAGE_FLAG_CRIT then
				return true
			end
		end
		return false
	end

	local DOTABaseAbility = IsServer() and CDOTABaseAbility or C_DOTABaseAbility

	--- 计算技能的AD,AP加成伤害
	function DOTABaseAbility:GetDamageAdd(hAtker)
		hAtker = hAtker or self:GetCaster()
		local fDamageP = hAtker:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
		local fDamageM = hAtker:GetVal(ATTRIBUTE_KIND.MagicalAttack)
		local tInfo = {}
		tInfo[DAMAGE_TYPE_PHYSICAL] = self:GetSpecialValueFor('physical2physical') * 0.01 * fDamageP + self:GetSpecialValueFor('magical2physical') * 0.01 * fDamageM
		tInfo[DAMAGE_TYPE_MAGICAL] = self:GetSpecialValueFor('physical2magical') * 0.01 * fDamageP + self:GetSpecialValueFor('magical2magical') * 0.01 * fDamageM
		tInfo[DAMAGE_TYPE_PURE] = self:GetSpecialValueFor('physical2pure') * 0.01 * fDamageP + self:GetSpecialValueFor('magical2pure') * 0.01 * fDamageM
		return tInfo
	end

	if IsServer() then

		--override ApplyDamage
		if not _ApplyDamage then
			_ApplyDamage = ApplyDamage
			---@param funcCallBack funtion funtion(tDamageData)=>void
			---@param bAttack bool 是否普攻伤害
			function ApplyDamage(tDamageData, funcCallBack, bAttack, ...)
				if IsValid(tDamageData.ability) and tDamageData.ability.ApplyDamage then
					if not tDamageData.damage_flags or bit.band(tDamageData.damage_flags, DOTA_DAMAGE_FLAG_NO_CUSTOM) ~= DOTA_DAMAGE_FLAG_NO_CUSTOM then
						return tDamageData.ability:ApplyDamage(tDamageData, funcCallBack, bAttack, ...)
					end
				end
				return _ApplyDamage(tDamageData, ...)
			end
		end

		--- 计算技能对目标最后伤害（这里检查暴击闪避等）
		---@param funcCallBack funtion funtion(tDamageData)=>void
		---@param bAttack bool 是否普攻伤害
		function DOTABaseAbility:GetDamageInfo(tDamageData, funcCallBack, bAttack)
			local hTarget = tDamageData.victim
			local hAtker = tDamageData.attacker or self:GetCaster()
			if not IsValid(hTarget) or not IsValid(hAtker) then
				return {}
			end

			local iDamageFlags = tDamageData.damage_flags and bit.bor(tDamageData.damage_flags, DOTA_DAMAGE_FLAG_NO_CUSTOM) or DOTA_DAMAGE_FLAG_NO_CUSTOM

			--攻击力加成伤害
			local tInfo = self:GetDamageAdd(hAtker)
			--额外伤害
			if tDamageData.damage and tDamageData.damage_type and tInfo[tDamageData.damage_type] then
				tInfo[tDamageData.damage_type] = tInfo[tDamageData.damage_type] + tDamageData.damage
			end

			-- 全伤害暴击倍率
			local fCritAll = math.max(hAtker:GetVal(ATTRIBUTE_KIND.DamageCrit), bAttack and hAtker:GetVal(ATTRIBUTE_KIND.AttackCrit, bAttack) or 0)

			--计算
			for typeDamage, fDamage in pairs(tInfo) do
				local tTempDamageData = {
					victim = hTarget,
					attacker = hAtker,
					damage = fDamage,
					damage_base = fDamage,
					damage_type = typeDamage,
					damage_flags = iDamageFlags,
					ability = self
				}

				--计算暴击
				if bit.band(tTempDamageData.damage_flags, DOTA_DAMAGE_FLAG_NO_SPELL_CRIT) ~= DOTA_DAMAGE_FLAG_NO_SPELL_CRIT then
					local fCrit
					if DAMAGE_TYPE_PHYSICAL == typeDamage then
						fCrit = hAtker:GetVal(ATTRIBUTE_KIND.PhysicalCrit)
					elseif DAMAGE_TYPE_MAGICAL == typeDamage then
						fCrit = hAtker:GetVal(ATTRIBUTE_KIND.MagicalCrit)
					else
						fCrit = hAtker:GetVal(ATTRIBUTE_KIND.PureCrit)
					end
					fCrit = math.max(fCritAll, fCrit)

					if 0 < fCrit then
						tTempDamageData.damage = tTempDamageData.damage * fCrit * 0.01
						tTempDamageData.damage_flags = tTempDamageData.damage_flags + DOTA_DAMAGE_FLAG_CRIT
					end
				end

				--计算闪避
				if hTarget and bit.band(tTempDamageData.damage_flags, DOTA_DAMAGE_FLAG_NO_MISS) ~= DOTA_DAMAGE_FLAG_NO_MISS then
					local fMiss = CheckAttackMiss(hTarget)
					if 0 < fMiss then
						tTempDamageData.damage = tTempDamageData.damage * (100 - fMiss) * 0.01
						tTempDamageData.damage_flags = tTempDamageData.damage_flags + DOTA_DAMAGE_FLAG_MISS
					end
				end

				--伤害结算处理回调
				if type(funcCallBack) == "function" then
					funcCallBack(tTempDamageData)
				end

				tInfo[typeDamage] = tTempDamageData
			end

			return tInfo
		end

		--- 技能伤害目标
		---@param funcCallBack funtion funtion(tDamageData)=>void
		---@param bAttack bool 是否普攻伤害
		function DOTABaseAbility:ApplyDamage(tDamageData, funcCallBack, bAttack)
			local tInfo = self:GetDamageInfo(tDamageData, funcCallBack, bAttack)
			local fTotal = 0
			for typeDamage, tData in pairs(tInfo) do
				fTotal = fTotal + _ApplyDamage(tData)
			end
			return fTotal
		end

		--- 应用多个伤害, 不计算加成
		function DOTABaseAbility:ApplyDamageTable(tDamageDatas)
			local fTotal = 0
			for k, tDamage in pairs(tDamageDatas) do
				fTotal = fTotal + _ApplyDamage(tDamage)
			end
			return fTotal
		end
	end
end
--防御************************************************************************************************************************
	do
	--- 获取伤害抵挡比例
	function GetDamageBlockPercent(hUnit, damage_type, fArmorIgnorePercent)
		local iArmor = 0
		if DAMAGE_TYPE_PHYSICAL == damage_type then
			iArmor = hUnit:GetVal(ATTRIBUTE_KIND.PhysicalArmor)
		elseif DAMAGE_TYPE_MAGICAL == damage_type then
			iArmor = hUnit:GetVal(ATTRIBUTE_KIND.MagicalArmor)
		end
		if fArmorIgnorePercent == 0 then
			return (iArmor * 0.16) / (math.abs(iArmor) * 0.16 + 100)
		else
			iArmor = iArmor - fArmorIgnorePercent * iArmor * 0.01
			return (iArmor * 0.16) / (math.abs(iArmor) * 0.16 + 100)
		end
	end
end
--暴击************************************************************************************************************************
	do
	---处理暴击，返回暴击百分比
	---@param tAttackInfo AttackInfo
	function GetDamageCriticalStrike(hUnit, damage_type, tAttackInfo)
		local fPer
		if tAttackInfo then
			fPer = math.max(hUnit:GetVal(ATTRIBUTE_KIND.AttackCrit, tAttackInfo), hUnit:GetVal(ATTRIBUTE_KIND.DamageCrit))
		else
			fPer = hUnit:GetVal(ATTRIBUTE_KIND.DamageCrit)
		end
		if DAMAGE_TYPE_PHYSICAL == damage_type then
			return math.max(fPer, hUnit:GetVal(ATTRIBUTE_KIND.PhysicalCrit))
		elseif DAMAGE_TYPE_MAGICAL == damage_type then
			return math.max(fPer, hUnit:GetVal(ATTRIBUTE_KIND.MagicalCrit))
		else
			return math.max(fPer, hUnit:GetVal(ATTRIBUTE_KIND.PureCrit))
		end
	end
	setmetatable(public[ATTRIBUTE_KIND.AttackCrit], { __index = Random_Max })
	setmetatable(public[ATTRIBUTE_KIND.DamageCrit], { __index = Random_Max })
	setmetatable(public[ATTRIBUTE_KIND.MagicalCrit], { __index = Random_Max })
	setmetatable(public[ATTRIBUTE_KIND.PhysicalCrit], { __index = Random_Max })
	setmetatable(public[ATTRIBUTE_KIND.PureCrit], { __index = Random_Max })
end
--闪避************************************************************************************************************************
	do
	---处理闪避，返回闪避百分比
	function CheckAttackMiss(hUnit)
		return hUnit:GetVal(ATTRIBUTE_KIND.AttackMiss)
	end

	setmetatable(public[ATTRIBUTE_KIND.AttackMiss], { __index = Random_Max })
end
--攻击弹道************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_AttackProjectile = public[ATTRIBUTE_KIND.AttackProjectile]
	setmetatable(AttributeSystem_AttackProjectile, { __index = interface(Level_Max, StringValue) })
	function AttributeSystem_AttackProjectile:_base() end
end
--攻击命中声音************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_AttackHitSound = public[ATTRIBUTE_KIND.AttackHitSound]
	setmetatable(AttributeSystem_AttackHitSound, { __index = interface(Level_Max, StringValue) })
	function AttributeSystem_AttackHitSound:_base() end
end
--攻击动作************************************************************************************************************************
	do
	local AttributeSystem_AttackAnimation = setmetatable({}, { __index = Level_Max })
	setmetatable(public[ATTRIBUTE_KIND.AttackAnimation], { __index = AttributeSystem_AttackAnimation })
	setmetatable(public[ATTRIBUTE_KIND.AttackAnimationRate], { __index = AttributeSystem_AttackAnimation })
	function AttributeSystem_AttackAnimation:_base() end
	function AttributeSystem_AttackAnimation:_count(val1, val2) return val2 end
end
--攻击falgs标识************************************************************************************************************************
	do
	local AttributeSystem_AttackFlags = setmetatable({}, { __index = LevelFunction })
	setmetatable(public[ATTRIBUTE_KIND.AttackFlags], { __index = AttributeSystem_AttackFlags })
	function AttributeSystem_AttackFlags:Fire(hUnit, params, tVal, ...)
		for i, v in ipairs(self:GetVal(hUnit, ...)) do
			tVal[1] = self:_fire(v[1], v[2], params, tVal[1], ...)
		end
	end
end
--攻击命中处理************************************************************************************************************************
	do
	--监听弹道命中
	if IsServer() then
		local function Hook_ProjectileHid(self, hTarget, vLocation, ExtraData, tProjectileInfo, ...)
			if IsValid(self) and IsValid(self:GetCaster()) then

				local tTargetChange = { { hTarget = hTarget } }
				EModifier:NotifyEvt(EMDF_CHANGE_PROJECTILE_HIT_TARGET, tTargetChange, tProjectileInfo, ExtraData, vLocation, ...)
				hTarget = tTargetChange[#tTargetChange].hTarget

				local bBreak = false
				if EModifier:NotifyEvt(EMDF_EVENT_ON_PROJECTILE_HIT, hTarget, tProjectileInfo, ExtraData, vLocation, ...) then
					bBreak = true
				end
				if ExtraData.record then
					local tAttackInfo = GetAttackInfo(ExtraData.record)
					if tAttackInfo then
						if EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hTarget, tAttackInfo, ExtraData, vLocation, ...) then
							bBreak = true
						end
					end
				end
				if bBreak then
					RemoveHashtable(ExtraData.iProjectileInfoID)
					return true
				end
			end
			if nil == hTarget or ExtraData.typeProjectile == PROJECTILE_TYPE.Tracking then
				RemoveHashtable(ExtraData.iProjectileInfoID)
			end
			if 'function' == type(self._OnProjectileHit_ExtraData) then
				return self._OnProjectileHit_ExtraData(self, hTarget, vLocation, ExtraData, ...)
			end
		end
		local function Hook_CreateProjectile(typeProjectile, self, tInfo, ...)
			if tInfo and tInfo.ExtraData then
				tInfo.ExtraData.typeProjectile = typeProjectile
				local _, iTableID = CreateHashtable(tInfo)
				tInfo.ExtraData.iProjectileInfoID = iTableID

				if tInfo.ExtraData.record then
					local tAttackInfo = GetAttackInfo(tInfo.ExtraData.record)
					if tAttackInfo then
						tAttackInfo.typeProjectile = typeProjectile
						tAttackInfo.tProjectileInfo = tInfo
					end
				end

				if tInfo.Ability and not tInfo.Ability._OnProjectileHit_ExtraData then
					tInfo.Ability._OnProjectileHit_ExtraData = tInfo.Ability.OnProjectileHit_ExtraData or true
					tInfo.Ability.OnProjectileHit_ExtraData = function(self, hTarget, vLocation, ExtraData, ...)
						local tProjectileInfo = GetHashtableByIndex(ExtraData.iProjectileInfoID)
						return Hook_ProjectileHid(self, hTarget, vLocation, ExtraData, tProjectileInfo, ...)
					end
				end
			end
		end
		ProjectileManager._CreateTrackingProjectile = ProjectileManager._CreateTrackingProjectile or ProjectileManager.CreateTrackingProjectile
		ProjectileManager.CreateTrackingProjectile = function(...)
			Hook_CreateProjectile(PROJECTILE_TYPE.Tracking, ...)
			return ProjectileManager._CreateTrackingProjectile(...)
		end
		ProjectileManager._CreateLinearProjectile = ProjectileManager._CreateLinearProjectile or ProjectileManager.CreateLinearProjectile
		ProjectileManager.CreateLinearProjectile = function(self, tInfo, ...)
			if tInfo then
				if VectorIsZero(tInfo.vVelocity) then
					tInfo.vVelocity = RandomVector(1000)
				end
				if not tInfo.fExpireTime and tInfo.fDistance and tInfo.vVelocity then
					tInfo.fExpireTime = GameRules:GetGameTime() + 5 + tInfo.fDistance / tInfo.vVelocity:Length2D()
				end
			end
			Hook_CreateProjectile(PROJECTILE_TYPE.Linear, self, tInfo, ...)
			return ProjectileManager._CreateLinearProjectile(self, tInfo, ...)
		end
	end
end
--攻击行为************************************************************************************************************************
	do
	---@param iLevel 优先级 ATTACK_PROJECTILE_LEVEL
	---@param funcDoAtk 攻击开始 DoAttackBehavior(params, hAttackAbility) => void | (hTarget, tAttackInfo, ExtraData, vLocation)=>bool
	-- function ATTRIBUTE_KIND.AttackBehavior:SetVal(hUnit, iLevel, funcDoAtk, key)
	setmetatable(public[ATTRIBUTE_KIND.AttackBehavior], { __index = LevelFunction_Max })
end
--伤害打出和承受百分比************************************************************************************************************************
	do
	setmetatable(public[ATTRIBUTE_KIND.OutgoingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.MagicalOutgoingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.PhysicalOutgoingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.PureOutgoingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.IncomingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.MagicalIncomingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.PhysicalIncomingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.PureIncomingPercentage], { __index = Percentage_Multiply })
	setmetatable(public[ATTRIBUTE_KIND.IgnoreArmor], { __index = Percentage_InverseMultiply_Base0 })
end
--状态抗性************************************************************************************************************************
	do
	---设置单位的状态抗性[0~1]
	function SetStatusResistance(hUnit, fValue, key)
		return hUnit:SetVal(ATTRIBUTE_KIND.StatusResistancePercentage, fValue * 100, key)
	end
	---获取单位的状态抗性[0~1]
	function GetStatusResistance(hUnit)
		return hUnit:GetVal(ATTRIBUTE_KIND.StatusResistancePercentage) * 0.01
	end

	---计算状态抗性后的Debuff持续时间
	function GetStatusDebuffDuration(fDuration, hTarget, hCaster)
		return fDuration * hTarget:GetStatusResistanceFactor(hCaster)
	end

	local DOTA_BaseNPC = IsServer() and CDOTA_BaseNPC or C_DOTA_BaseNPC
	---获取用于计算状态时间的抗性因子[0~1]
	function DOTA_BaseNPC:GetStatusResistanceFactor(hCaster)
		local fValue = 1 - GetStatusResistance(self)
		if IsValid(hCaster) then
			fValue = fValue * hCaster:GetStatusResistanceCaster()
		end
		return fValue
	end
	---获取施加的负面状态加深因子[0~1]
	function DOTA_BaseNPC:GetStatusResistanceCaster()
		return 0.01 * self:GetVal(ATTRIBUTE_KIND.StatusResistancePercentageCaster)
	end
	setmetatable(public[ATTRIBUTE_KIND.StatusResistancePercentage], { __index = Percentage_InverseMultiply_Base0 })
	setmetatable(public[ATTRIBUTE_KIND.StatusResistancePercentageCaster], { __index = Percentage_Multiply })
end
--攻击范围************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_AttackRange = public[ATTRIBUTE_KIND.AttackRange]
	--设置默认基础值
	if IsServer() then
		function AttributeSystem_AttackRange:_base(hUnit)
			return hUnit:GetBaseAttackRange()
		end
	else
		function AttributeSystem_AttackRange:_base(hUnit)
			local tKV = KeyValues.UnitsKv[hUnit:GetUnitName()]
			return tKV and tonumber(tKV.AttackRange) or 0
		end
	end
end
--攻击速度************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_AttackSpeed = public[ATTRIBUTE_KIND.AttackSpeed]
	--默认100基础值
	function AttributeSystem_AttackSpeed:_base() return 100 end
end
--移动速度************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_MoveSpeed = public[ATTRIBUTE_KIND.MoveSpeed]
	--设置默认基础值
	function AttributeSystem_MoveSpeed:_base(hUnit)
		return hUnit:GetBaseMoveSpeed()
	end
end
--生命值************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_StatusHealth = public[ATTRIBUTE_KIND.StatusHealth]

	if IsServer() then
		function AttributeSystem_StatusHealth:UpdatVal(hUnit)
			local fNewValue = self:GetVal(hUnit)
			if 'number' ~= type(fNewValue) then return end
			local fHealthPercent = hUnit:GetHealth() / hUnit:GetMaxHealth()
			local fCorrectHealth = Clamp(fNewValue, 1, MAX_HEALTH)
			hUnit:SetBaseMaxHealth(fCorrectHealth)
			hUnit:SetMaxHealth(fCorrectHealth)
			hUnit:ModifyHealth(fHealthPercent * fCorrectHealth, nil, false, 0)
		end
	end
end
--魔法值************************************************************************************************************************
	do
	---@type AttributeSystem
	local AttributeSystem_StatusMana = public[ATTRIBUTE_KIND.StatusMana]
	--设置默认基础值
	function AttributeSystem_StatusMana:_base(hUnit)
		return 100
	end
	if IsServer() then
		function AttributeSystem_StatusMana:UpdatVal(hUnit)
			local fNewValue = self:GetVal(hUnit)
			if hUnit[ATTRIBUTE_KIND.StatusMana] ~= fNewValue then
				hUnit[ATTRIBUTE_KIND.StatusMana] = fNewValue
				hUnit:AddNewModifier(hUnit, nil, 'modifier_attribute_getter', nil)
			end
		end
	end
end
--模型大小************************************************************************************************************************
	do
	local AttributeSystem_ModelScale = setmetatable(public[ATTRIBUTE_KIND.ModelScale], { __index = public })
	function AttributeSystem_ModelScale:_base(hUnit)
		local tKV = KeyValues.UnitsKv[hUnit:GetUnitName()]
		return tKV and tonumber(tKV.ModelScale) or 1
	end
	if IsServer() then
		function AttributeSystem_ModelScale:UpdatVal(hUnit)
			local fVal = self:GetVal(hUnit)
			hUnit:SetModelScale(fVal)
		end
	end
end
--仇恨等级************************************************************************************************************************
	do
	local AttributeSystem_ThreatLevel = setmetatable(public[ATTRIBUTE_KIND.ThreatLevel], { __index = public })
	--设置默认基础值
	function AttributeSystem_ThreatLevel:_base(hUnit)
		return 0
	end
	if IsServer() then
		function AttributeSystem_ThreatLevel:UpdatVal(hUnit)
			local fNewValue = self:GetVal(hUnit)
			if hUnit[ATTRIBUTE_KIND.ThreatLevel] ~= fNewValue then
				hUnit[ATTRIBUTE_KIND.ThreatLevel] = fNewValue
			end
		end
	end
end
--攻击弹道************************************************************************************************************************
do
	---@type AttributeSystem
	local AttributeSystem_Reincarnation = public[ATTRIBUTE_KIND.Reincarnation]
	setmetatable(AttributeSystem_Reincarnation, { __index = Level_First })
	function AttributeSystem_Reincarnation:_base() end
end