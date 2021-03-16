--[[	Example:
	-- 无目标技能：
	abyssal_underlord_2 = class({}, nil, ability_base_ai)

	-- 单位目标：
	local tInitData = {
		iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET,
		funcSortFunction = function (a, b)
			return a:GetMana() < b:GetMana()
		end
	}
	anti_mage_3 = class(tInitData, nil, ability_base_ai)

	-- 点技能：
	local tInitData = {
		iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET,
	}
	abyssal_underlord_1 = class(tInitData, nil, ability_base_ai)
]]
AI_SEARCH_BEHAVIOR_NONE = 1	-- 没有特别行为，有人就放
AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET = 2	-- 搜寻AOE技能最佳施法点
AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET = 3 -- 搜寻直线AOE技能最佳施法点，只在点目标技能下作用
if ability_base_ai == nil then
	ability_base_ai = class({
		iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET, -- 技能行为，一般只有被动施法技能需要指定，主动技能会自动读取kv技能行为:DOTA_ABILITY_BEHAVIOR_UNIT_TARGET,DOTA_ABILITY_BEHAVIOR_POINT
		iSearchBehavior = AI_SEARCH_BEHAVIOR_NONE, -- 技能AI搜寻行为
		-- iAOERadius = self:GetAOERadius(),	-- AOE技能搜寻范围，可以指定为指定值或者自动读取GetAOERadius的值，无目标技能不填则cd好了就放，填值则判断有单位就放
		-- iStartWidth = self:GetAOERadius(),	-- 直线技能搜寻开始范围，可以指定为指定值或者自动读取GetAOERadius的值
		-- iEndWidth = self:GetAOERadius(),	-- 直线技能搜寻结束范围，可以指定为指定值或者自动读取GetAOERadius的值
		-- iTargetTeam = self:GetAbilityTargetTeam(),	-- 搜寻队伍，可以指定为指定值或者自动读取kv配置
		-- iTargetType = self:GetAbilityTargetType(),	-- 搜寻类型，可以指定为指定值或者自动读取kv配置
		-- iTargetFlags = self:GetAbilityTargetFlags(),	-- 搜寻标记，可以指定为指定值或者自动读取kv配置
		-- funcSortFunction	-- 自定义搜寻单位组的排序规则，只在AI_SEARCH_BEHAVIOR_NONE模式下使用，比如选择生命值最小的单位：funcSortFunction = function (a, b) return a:GetHealth() < b:GetHealth() end
		-- funcCondition	-- 自定义额外规则
		-- funcUnitsCallback	-- 对搜寻单位组自定义操作
		iOrderType = FIND_ANY_ORDER, -- 搜寻距离类型：FIND_ANY_ORDER, FIND_CLOSEST, FIND_FARTHEST
		tExtraData = {}, -- 被动施法额外参数
	})
	ability_base_ai.constructor = function(self)
		if type(self.Spawn) == "function" then
			if self.Spawn ~= ability_base_ai.Spawn then
				local _Spawn = self.Spawn
				self.Spawn = function(...)
					local result = _Spawn(...)
					ability_base_ai.Spawn(...)
					return result
				end
			end
		else
			self.Spawn = ability_base_ai.Spawn
		end
	end
end
function ability_base_ai:Spawn()
	if IsServer() then
		local hCaster = self:GetCaster()
		-- 主动技能解析技能行为
		if not self:IsPassive() then
			local iBehavior = GetAbilityBehavior(self)
			if bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_NO_TARGET) == DOTA_ABILITY_BEHAVIOR_NO_TARGET then
				self.iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET
			elseif bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_UNIT_TARGET) == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
				self.iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET
			elseif bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_POINT) == DOTA_ABILITY_BEHAVIOR_POINT then
				self.iBehavior = DOTA_ABILITY_BEHAVIOR_POINT
			end
		end
		-- 初始化参数
		self.iTargetTeam = self.iTargetTeam or self:GetAbilityTargetTeam()
		self.iTargetType = self.iTargetType or self:GetAbilityTargetType()
		self.iTargetFlags = self.iTargetFlags or self:GetAbilityTargetFlags()
		-- 开启AI Think
		if self.iBehavior == DOTA_ABILITY_BEHAVIOR_NO_TARGET then	-- 无目标技能
			self:GameTimer(0, function()
				if self:IsAbilityReady() then
					if self.funcCondition and self.funcCondition(self) ~= true then
						goto continue
					end
					local iAOERadius = self.iAOERadius or self:GetAOERadius()
					if iAOERadius > 0 then
						local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, iAOERadius, self.iTargetTeam, self.iTargetType, self.iTargetFlags, self.iOrderType, false)
						if IsValid(tTargets[1]) then
							self:CastAbilityNoTarget()
						end
					else
						self:CastAbilityNoTarget()
					end
				end
				:: continue ::
				return AI_TIMER_TICK_TIME
			end)
		elseif self.iBehavior == DOTA_ABILITY_BEHAVIOR_POINT then	-- 点目标技能
			self:GameTimer(0, function()
				if self:IsAbilityReady() then
					if self.funcCondition and self.funcCondition(self) ~= true then
						goto continue
					end
					local flCastRange = self:GetCastRange(vec3_invalid, nil)
					local iAOERadius = self.iAOERadius or self:GetAOERadius()
					local iStartWidth = self.iStartWidth or self:GetAOERadius()
					local iEndWidth = self.iEndWidth or self:GetAOERadius()
					local vPosition = vec3_invalid
					if self.iSearchBehavior == AI_SEARCH_BEHAVIOR_NONE then
						local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, flCastRange, self.iTargetTeam, self.iTargetType, self.iTargetFlags, self.iOrderType, false)
						if self.funcSortFunction then
							table.sort(tTargets, function(a, b)
								return self.funcSortFunction(a, b, hCaster)
							end)
						end
						if IsValid(tTargets[1]) then
							vPosition = tTargets[1]:GetAbsOrigin()
						end
					elseif self.iSearchBehavior == AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET then
						vPosition = GetAOEMostTargetsPosition(hCaster:GetAbsOrigin(), flCastRange, hCaster:GetTeamNumber(), iAOERadius, self.iTargetTeam, self.iTargetType, self.iTargetFlags, self.iOrderType)
					elseif self.iSearchBehavior == AI_SEARCH_BEHAVIOR_MOST_LINE_TARGET then
						vPosition = GetLinearMostTargetsPosition(hCaster:GetAbsOrigin(), flCastRange, hCaster:GetTeamNumber(), iStartWidth, iEndWidth, self.iTargetTeam, self.iTargetType, self.iTargetFlags, self.iOrderType)
					end
					if vPosition ~= vec3_invalid then
						self:CastAbilityOnPosition(vPosition)
					end
				end
				:: continue ::
				return AI_TIMER_TICK_TIME
			end)
		elseif self.iBehavior == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then	-- 单位目标技能
			self:GameTimer(0, function()
				if self:IsAbilityReady() then
					if self.funcCondition and self.funcCondition(self) ~= true then
						goto continue
					end
					local flCastRange = self:GetCastRange(vec3_invalid, nil)
					local iAOERadius = self.iAOERadius or self:GetAOERadius()
					local hTarget = nil
					if self.iSearchBehavior == AI_SEARCH_BEHAVIOR_NONE then
						local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, flCastRange, self.iTargetTeam, self.iTargetType, self.iTargetFlags, self.iOrderType, false)
						if self.funcSortFunction then
							table.sort(tTargets, function(a, b)
								return self.funcSortFunction(a, b, hCaster)
							end)
						end
						if self.funcUnitsCallback then
							self.funcUnitsCallback(self, tTargets)
						end
						if IsValid(tTargets[1]) then
							hTarget = tTargets[1]
						end
					elseif self.iSearchBehavior == AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET then
						hTarget = GetAOEMostTargetsSpellTarget(hCaster:GetAbsOrigin(), flCastRange, hCaster:GetTeamNumber(), iAOERadius, self.iTargetTeam, self.iTargetType, self.iTargetFlags, self.iOrderType)
					end
					if hTarget then
						self:CastAbilityOnTarget(hTarget)
					end
				end
				:: continue ::
				return AI_TIMER_TICK_TIME
			end)
		end
	end

end
----------------------------------------------------------------------------------------------------
-- 施法指令
----------------------------------------------------------------------------------------------------
-- 无目标技能施法
function ability_base_ai:CastAbilityNoTarget()
	if self:IsPassive() then
		self:GetCaster():PassiveCast(self, DOTA_UNIT_ORDER_CAST_NO_TARGET)
	else
		ExecuteOrder(self:GetCaster(), DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self)
	end
end
-- 点目标技能施法
function ability_base_ai:CastAbilityOnPosition(vPosition)
	if self:IsPassive() then
		self:GetCaster():PassiveCast(self, DOTA_UNIT_ORDER_CAST_POSITION, TableOverride({ vPosition = vPosition }, self.tExtraData))
	else
		ExecuteOrder(self:GetCaster(), DOTA_UNIT_ORDER_CAST_POSITION, nil, self, vPosition)
	end
end
-- 单位目标技能施法
function ability_base_ai:CastAbilityOnTarget(hTarget)
	if self:IsPassive() then
		self:GetCaster():PassiveCast(self, DOTA_UNIT_ORDER_CAST_TARGET, TableOverride({ hTarget = hTarget }, self.tExtraData))
	else
		ExecuteOrder(self:GetCaster(), DOTA_UNIT_ORDER_CAST_TARGET, hTarget, self)
	end
end