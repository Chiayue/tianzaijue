LinkLuaModifier("modifier_shredderA_2_buff", "abilities/tower/shredderA/shredderA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderA_2_debuff", "abilities/tower/shredderA/shredderA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderA_2_thinker", "abilities/tower/shredderA/shredderA_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
if shredderA_2 == nil then
	shredderA_2 = class({}, nil, ability_base_ai)
end
function shredderA_2:OnSpellStart()
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_shredderA_2_buff", { duration = self:GetDuration() })
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderA_2_buff == nil then
	modifier_shredderA_2_buff = class({}, nil, eom_modifier)
end
function modifier_shredderA_2_buff:OnCreated(params)
	self.count = self:GetAbilitySpecialValueFor("count")
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	if IsServer() then
		self:SetStackCount(self.count)
	end
end
function modifier_shredderA_2_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed
	}
end
function modifier_shredderA_2_buff:GetAttackSpeedBonus()
	return self.attackspeed
end
---------------------------------------------------------------------
if modifier_shredderA_2_thinker == nil then
	modifier_shredderA_2_thinker = class({}, nil, HorizontalModifier)
end
function modifier_shredderA_2_thinker:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		self.iSpeed = self:GetAbilitySpecialValueFor("speed")	-- 初始速度
		self.iRadius = self:GetAbilitySpecialValueFor("radius")	-- 伤害半径
		self.AttackInfo = GetAttackInfo(params.record)			-- attack record
		self.hAbility = EntIndexToHScript(params.iAbilityIndex)	-- 攻击技能
		-- 运动相关
		self.tTargets = {}										-- 记录被撞的单位
		self.vStart = hParent:GetAbsOrigin()					-- 起始点
		self.vEnd = StringToVector(params.vPosition)			-- 目标点
		self.flDistance = (self.vEnd - self.vStart):Length2D()	-- 初始距离
		-- 如果目标比较近，减慢初始速度
		self.iSpeed = RemapVal(self.flDistance, 0, hParent:Script_GetAttackRange(), self.iSpeed * 0.1, self.iSpeed)
		self.bReturn = false									-- 回归状态
		-- 音效
		hCaster:EmitSound("Hero_Shredder.Chakram.Tree")
		-- 减备用飞盘次数
		local hModifier = hCaster:FindModifierByName("modifier_shredderA_2_buff")
		if IsValid(hModifier) then
			hModifier:DecrementStackCount()
		end
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/shreddera/shreddera_2_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shredderA_2_thinker:OnDestroy()
	local hParent = self:GetParent()
	local hCaster = self:GetParent()
	if IsServer() then
		hParent:RemoveHorizontalMotionController(self)
		if IsValid(hParent) then
			hParent:RemoveSelf()
			DelAttackInfo(self.AttackInfo.record)
			-- self.hModifier:Destroy()
		end
		-- 加次数
		if IsValid(hCaster) then
			local hModifier = hCaster:FindModifierByName("modifier_shredderA_2_buff")
			if IsValid(hModifier) then
				hModifier:IncrementStackCount()
			end
		end
	end
end
function modifier_shredderA_2_thinker:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		if not IsValid(self) then return end
		if not IsValid(self:GetAbility()) then
			self:Destroy()
			return
		end
		local hCaster = self:GetAbility():GetCaster()
		if not IsValid(hCaster) then
			self:Destroy()
			return
		end

		-- 销毁飞盘
		local vDirection = self.bReturn and (hCaster:GetAbsOrigin() - me:GetAbsOrigin()):Normalized() or (self.vEnd - me:GetAbsOrigin()):Normalized()
		local flDistance = (self.vEnd - me:GetAbsOrigin()):Length2D()
		local iSpeed = RemapVal(flDistance, 0, self.flDistance, 20, self.iSpeed)	-- 备用飞盘速度比较快
		local vVelocity = vDirection * iSpeed
		me:SetAbsOrigin(GetGroundPosition(me:GetAbsOrigin() + vVelocity * dt, me))

		local tTargets = FindUnitsInRadiusWithAbility(hCaster, me:GetAbsOrigin(), self.iRadius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				--命中
				EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hUnit, self.AttackInfo)
				--伤害
				self.hAbility:OnDamage(hUnit, self.AttackInfo)
				-- 击退（备用飞盘不造成击退）
				-- local flKnockbackDistance = RemapVal(iSpeed, 0, self.iSpeed / 2, 0, 200)
				-- if flKnockbackDistance > 0 then
				-- 	me:KnockBack(me:GetAbsOrigin(), hUnit, RemapVal(iSpeed, 0, self.iSpeed, 10, 200), 0, 0.2, false)
				-- end
			end
			if not hUnit:HasModifier("modifier_shredderA_2_debuff") then
				hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_shredderA_2_debuff", { iThinkerIndex = me:entindex() })
			end
		end
		-- 到达目标位置
		if flDistance < 10 then
			self.tTargets = {}
			self.bReturn = true
		end
		-- 结束
		if self.bReturn and CalculateDistance(hCaster, me) < iSpeed * dt then
			self:Destroy()
		end
	end
end
function modifier_shredderA_2_thinker:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_shredderA_2_thinker:CheckState()
	return {
		[MODIFIER_STATE_FLYING_FOR_PATHING_PURPOSES_ONLY] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true
	}
end
---------------------------------------------------------------------
if modifier_shredderA_2_debuff == nil then
	modifier_shredderA_2_debuff = class({}, nil, eom_modifier)
end
function modifier_shredderA_2_debuff:IsDebuff()
	return true
end
function modifier_shredderA_2_debuff:OnCreated(params)
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	if IsServer() then
		self.iRadius = self:GetAbilitySpecialValueFor("radius")	-- 伤害半径
		self.flInterval = self:GetAbilitySpecialValueFor("interval")
		self.hThinker = EntIndexToHScript(params.iThinkerIndex)
		self:StartIntervalThink(self.flInterval)
	end
end
function modifier_shredderA_2_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if hCaster then
		hCaster:DealDamage(hParent, self:GetAbility(), 0)
	end
	-- 减甲
	if hCaster:HasModifier("modifier_shredderA_3") then
		hCaster:FindAbilityByName("shredderA_3"):Action(hParent)
	end
	if not IsValid(self.hThinker) or CalculateDistance(self.hThinker, hParent) > self.iRadius then
		self:Destroy()
	end
end
function modifier_shredderA_2_debuff:EDeclareFunctions()
	return {
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_shredderA_2_debuff:GetMoveSpeedBonusPercentage()
	-- 三技能减速效果，数值配在2技能上，三技能数值仅做显示
	if self:GetCaster():HasModifier("modifier_shredderA_3") then
		return -self.movespeed_reduce_pct
	end
end
function modifier_shredderA_2_debuff:IsHidden()
	return true
end