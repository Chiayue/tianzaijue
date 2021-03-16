if modifier_passive_cast == nil then
	modifier_passive_cast = class({})
end

local public = modifier_passive_cast

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
	return false
end
-- function public:RemoveOnDeath()
-- 	return false
-- end
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
	if IsServer() then
		hParent:Stop()
		self:StartIntervalThink(0)
		self.bSuccessed = false
		self.flTime = 0
		-- 参数
		self.flCastPoint = params.flCastPoint
		self.iCastAnimation = params.iCastAnimation
		self.bIgnoreBackswing = params.bIgnoreBackswing and true or false
		self.iOrderType = params.iOrderType
		self.iAnimationRate = params.iAnimationRate
		self.bUseCooldown = params.bUseCooldown == 1 and true or false
		self.vPosition = params.vPosition and StringToVector(params.vPosition) or nil
		self.hTarget = params.iTargetIndex and EntIndexToHScript(params.iTargetIndex) or nil
		self.bFadeAnimation = params.bFadeAnimation and true or false
		if params.sActivityModifier ~= nil then
			self.sActivityModifier = string.split(params.sActivityModifier, ",")
		end
		-- 自定义施法抬手与打断
		self.OnAbilityPhaseStart = self:GetAbility().CustomAbilityPhaseStart
		self.OnAbilityPhaseInterrupted = self:GetAbility().CustomAbilityPhaseInterrupted
		-- 播放施法动作
		if self.iCastAnimation then
			if self.sActivityModifier then
				if type(self.sActivityModifier) == "string" then
					hParent:AddActivityModifier(self.sActivityModifier)
				else
					for _, sActivityModifier in ipairs(self.sActivityModifier) do
						hParent:AddActivityModifier(sActivityModifier)
					end
				end
			end
			if self.iAnimationRate then
				hParent:StartGestureWithPlaybackRate(self.iCastAnimation, self.iAnimationRate)
			else
				hParent:StartGesture(self.iCastAnimation)
			end
			if self.sActivityModifier then
				if type(self.sActivityModifier) == "string" then
					hParent:RemoveActivityModifier(self.sActivityModifier)
				else
					for _, sActivityModifier in ipairs(self.sActivityModifier) do
						hParent:RemoveActivityModifier(sActivityModifier)
					end
				end
			end
		end
		-- 施法后摇
		if not self.bIgnoreBackswing then
			self:SetDuration(math.max(hParent:ActiveSequenceDuration(), self.flCastPoint), true)
		end
		-- self.flBackPoint = hParent:ActiveSequenceDuration() - self.flCastPoint
		-- 调用技能的OnAbilityPhaseStart
		if self.iOrderType == DOTA_UNIT_ORDER_CAST_TARGET then
			hParent:SetCursorCastTarget(self.hTarget)
		elseif self.iOrderType == DOTA_UNIT_ORDER_CAST_POSITION then
			hParent:SetCursorPosition(self.vPosition)
		end
		if self.OnAbilityPhaseStart then
			if self.OnAbilityPhaseStart(self:GetAbility()) ~= true then
				self:Destroy()
			end
		elseif self:GetAbility():OnAbilityPhaseStart() ~= true then
			self:Destroy()
		end
		if self.iOrderType == DOTA_UNIT_ORDER_CAST_TARGET then
			if not IsValid(self.hTarget) then
				self:Destroy()
			end
			hParent:SetCursorCastTarget(nil)
		elseif self.iOrderType == DOTA_UNIT_ORDER_CAST_POSITION then
			hParent:SetCursorPosition(vec3_invalid)
		end
		-- 有目标技能转向目标
		if self.iOrderType == DOTA_UNIT_ORDER_CAST_POSITION or self.iOrderType == DOTA_UNIT_ORDER_CAST_TARGET then
			-- hParent:FaceTowards(self.vPosition or self.hTarget:GetAbsOrigin())
			local vPosition = self.vPosition or self.hTarget:GetAbsOrigin()
			local vDirection = (vPosition - hParent:GetAbsOrigin()):Normalized()
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, hParent:GetAbsOrigin() + vDirection)
		end
	end
end
function public:OnRefresh(params)
	local hParent = self:GetParent()
	-- 打断上次的施法动作
	if self.iCastAnimation then
		hParent:FadeGesture(self.iCastAnimation)
	end
	-- 重新开始
	self:OnCreated(params)
end
function public:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	self.flTime = self.flTime + FrameTime()
	if self.flTime >= self.flCastPoint and self.bSuccessed == false then
		self.bSuccessed = true
		self:OnSuccess()
	end
	if self:GetRemainingTime() <= 0 and self.bSuccessed == true then
		self:Destroy()
	end
	if self.bSuccessed == false then
		if
		-- hParent:IsSilenced() or			-- 沉默
		hParent:IsStunned() or				-- 晕眩
		hParent:IsHexed() or				-- 妖术
		hParent:IsCommandRestricted() or	-- 无法执行命令
		hParent:PassivesDisabled() or		-- 禁用被动
		not hParent:IsAlive() or			-- 死亡
		not hAbility:IsActivated() or		-- 技能禁用
		-- not hAbility:IsCooldownReady() or	-- 技能冷却中
		(self.iOrderType == DOTA_UNIT_ORDER_CAST_TARGET and (not IsValid(self.hTarget) or not self.hTarget:IsAlive()))
		then
			self:Destroy()
		end
	else

	end
end
function public:OnDestroy()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		-- 施法打断
		if not self.bSuccessed then
			if self.iCastAnimation then
				hParent:FadeGesture(self.iCastAnimation)
			end
			-- 调用技能的OnAbilityPhaseInterrupted
			if self.OnAbilityPhaseInterrupted then
				self.OnAbilityPhaseInterrupted(hAbility)
			else
				hAbility:OnAbilityPhaseInterrupted()
			end
		end
	end
end
function public:OnSuccess()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		if self.bSuccessed then
			if self.bUseCooldown then
				hAbility:UseResources(false, false, true)
			end
			-- 回调
			if self.iOrderType == DOTA_UNIT_ORDER_CAST_TARGET then
				hParent:SetCursorCastTarget(self.hTarget)
			elseif self.iOrderType == DOTA_UNIT_ORDER_CAST_POSITION then
				hParent:SetCursorPosition(self.vPosition)
			end
			if self.callback then
				self.callback(hAbility)
			else
				hAbility:OnSpellStart()	-- 默认调用技能的OnSpellStart
			end
			if self.iOrderType == DOTA_UNIT_ORDER_CAST_TARGET then
				hParent:SetCursorCastTarget(nil)
			elseif self.iOrderType == DOTA_UNIT_ORDER_CAST_POSITION then
				hParent:SetCursorPosition(vec3_invalid)
			end
		end
		-- 结束施法动作
		if self.iCastAnimation and self.bFadeAnimation == true then
			hParent:FadeGesture(self.iCastAnimation)
		end
	end
end
function public:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ORDER
	}
end
function public:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
	}
end
function public:OnOrder(params)
	-- 打断施法
	if params.unit == self:GetParent() and self:GetElapsedTime() > FrameTime() then
		if params.ability ~= nil then
			if params.ability == self:GetAbility() then
				return
			end
			local iBehavior = GetAbilityBehavior(params.ability)
			if bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_IMMEDIATE) == DOTA_ABILITY_BEHAVIOR_IMMEDIATE or bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_TOGGLE) == DOTA_ABILITY_BEHAVIOR_TOGGLE then
				if not (bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT) == DOTA_ABILITY_BEHAVIOR_DONT_RESUME_MOVEMENT or bit.band(iBehavior, DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK) == DOTA_ABILITY_BEHAVIOR_DONT_RESUME_ATTACK) then
					return
				end
			end
		end
		if params.order_type == DOTA_UNIT_ORDER_TRAIN_ABILITY
		or params.order_type == DOTA_UNIT_ORDER_PURCHASE_ITEM
		or params.order_type == DOTA_UNIT_ORDER_SELL_ITEM
		or params.order_type == DOTA_UNIT_ORDER_MOVE_ITEM
		or params.order_type == DOTA_UNIT_ORDER_DISASSEMBLE_ITEM
		or params.order_type == DOTA_UNIT_ORDER_CAST_TOGGLE_AUTO
		or params.order_type == DOTA_UNIT_ORDER_GLYPH
		or params.order_type == DOTA_UNIT_ORDER_EJECT_ITEM_FROM_STASH
		or params.order_type == DOTA_UNIT_ORDER_RADAR then
			return
		end
		self:Destroy()
	end
end