if modifier_enemy_boss_ai == nil then
	modifier_enemy_boss_ai = class({})
end

local public = modifier_enemy_boss_ai

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
function public:GetPriority()
	return MODIFIER_PRIORITY_ULTRA
end
function public:OnCreated(params)
	local hParent = self:GetParent()

	self.STATE_IDLE = 0		--闲置
	self.STATE_ATTACK = 1	--攻击
	self.STATE_FOLLOW = 2	--追踪

	self.typeState = self.STATE_IDLE

	if IsServer() then
		self.casting = false
		self.iAttackCapability = hParent:GetAttackCapability()
		self:StartIntervalThink(AI_TIMER_TICK_TIME)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ORDER, self, self:GetParent())
end
function public:OnDestroy()
	if IsServer() then
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ORDER, self, self:GetParent())
end
function public:OnIntervalThink()
	if IsServer() then
		if GSManager:getStateType() ~= GS_Battle or self:GetParent():GetCurrentActiveAbility() ~= nil then
			return
		end
		local hParent = self:GetParent()

		if self.typeState == self.STATE_IDLE then
			--施法中
			if hParent:IsChanneling() or self.casting then
				return
			end
			--闲置时，寻找目标
			-- hParent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			local hTarget, bValid = self:FindTargets()
			self.hTarget = hTarget

			if hTarget then
				if bValid then
					--攻击有效单位
					self.typeState = self.STATE_ATTACK
					hParent:SetAttackCapability(self.iAttackCapability)
					hParent:MoveToTargetToAttack(hTarget)
					-- ExecuteOrderFromTable({
					-- 	UnitIndex = hParent:entindex(),
					-- 	OrderType = DOTA_UNIT_ORDER_ATTACK_MOVE,
					-- 	Position = hTarget:GetAbsOrigin()
					-- })
				else
					--无可攻击单位，但也会向其他单位移动
					self.typeState = self.STATE_FOLLOW
					ExecuteOrderFromTable({
						UnitIndex = hParent:entindex(),
						OrderType = DOTA_UNIT_ORDER_MOVE_TO_POSITION,
						Position = hTarget:GetAbsOrigin()
					})
				end
			end
		elseif self.typeState == self.STATE_ATTACK then
			--攻击中，监视攻击目标是否有效
			if not IsValid(self.hTarget) or not self.hTarget:IsAlive() then
				self.typeState = self.STATE_IDLE
				hParent:SetAttackCapability(DOTA_UNIT_CAP_NO_ATTACK)
			end
		elseif self.typeState == self.STATE_FOLLOW then
			--追踪时，如果监测到有效单位出现则攻击
			local hTarget, bValid = self:FindTargets()
			if bValid and hTarget then
				--攻击有效单位
				self.hTarget = hTarget
				self.typeState = self.STATE_ATTACK
				hParent:SetAttackCapability(self.iAttackCapability)
				hParent:MoveToTargetToAttack(hTarget)
			end
		end
	end
end
function public:CheckState()
	return {
		-- [MODIFIER_STATE_CANNOT_BE_MOTION_CONTROLLED] = true,
		-- [MODIFIER_STATE_STUNNED] = false,
		-- [MODIFIER_STATE_ROOTED] = false,
		[MODIFIER_STATE_SILENCED] = false,
		-- [MODIFIER_STATE_DISARMED] = false,
		[MODIFIER_STATE_FROZEN] = false,
		[MODIFIER_STATE_HEXED] = false,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
	}
end
function public:DeclareFunctions()
	return {
	-- MODIFIER_EVENT_ON_ORDER,
	}
end
function public:OnOrder(params)
	if params.unit ~= self:GetParent() then return end

	if params.order_type ~= DOTA_UNIT_ORDER_ATTACK_MOVE then
	end

	if params.ability ~= nil then
		self.casting = true

		params.unit:GameTimer(math.max(params.ability:GetCastPoint(), 0.1), function()
			self.casting = false
		end)
	end
end

----
--寻找目标
function public:FindTargets()
	local hParent = self:GetParent()

	--寻找最近单位
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 3000,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	0,
	FIND_CLOSEST, true)

	--过滤不能攻击的单位
	-- local hTarget_Invalid
	-- removeAll(tTargets, function(v)
	-- 	if v:HasModifier('modifier_building_ai') then
	-- 		if not IsCanAttack(hParent, v) then
	-- 			if not hTarget_Invalid then
	-- 				hTarget_Invalid = v
	-- 			end
	-- 			return true
	-- 		end
	-- 	end
	-- end)
	--随机单位
	for _, hTarget in ipairs(tTargets) do
		if hTarget then
			return hTarget, true
		end
	end
	return nil, false


end