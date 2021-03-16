LinkLuaModifier("modifier_shredderA_1", "abilities/tower/shredderA/shredderA_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderA_1_disarm", "abilities/tower/shredderA/shredderA_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderA_1_thinker", "abilities/tower/shredderA/shredderA_1.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_shredderA_1_debuff", "abilities/tower/shredderA/shredderA_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shredderA_2_thinker", "abilities/tower/shredderA/shredderA_2.lua", LUA_MODIFIER_MOTION_HORIZONTAL)
LinkLuaModifier("modifier_shredderA_2_disarm", "abilities/tower/shredderA/shredderA_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if shredderA_1 == nil then
	shredderA_1 = class({})
end
function shredderA_1:GetIntrinsicModifierName()
	return "modifier_shredderA_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderA_1 == nil then
	modifier_shredderA_1 = class({}, nil, eom_modifier)
end
function modifier_shredderA_1:IsHidden()
	return true
end
function modifier_shredderA_1:OnCreated(params)
	self.width = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
	end
end
function modifier_shredderA_1:OnRefresh(params)
	self.width = self:GetAbilitySpecialValueFor("width")
	if IsServer() then
	end
end
function modifier_shredderA_1:EDeclareFunctions()
	return {
		EMDF_ATTACKT_ANIMATION,
		EMDF_DO_ATTACK_BEHAVIOR,
		[MODIFIER_EVENT_ON_ATTACK_START] = { self:GetParent() }
	}
end
function modifier_shredderA_1:OnAttackStart()
	self:GetParent():EmitSound("Hero_Shredder.PreAttack")
end
function modifier_shredderA_1:GetAttackAnimation()
	return RollPercentage(50) and ACT_DOTA_CAST_ABILITY_4 or ACT_DOTA_CAST_ABILITY_6
end
function modifier_shredderA_1:DoAttackBehavior(tAttackInfo, hAttackAbility)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local hTarget = tAttackInfo.target
	-- 计算目标位置，飞盘会往目标身后的位置飞，有击退效果时额外增加距离
	local flDistance = self.width
	if hParent:HasModifier("modifier_shredderA_3") then
		flDistance = flDistance + RemapVal(CalculateDistance(hTarget, hParent), 0, hParent:Script_GetAttackRange(), 300, 10)
	end
	local vEnd = hTarget:GetAbsOrigin() + CalculateDirection(hTarget, hParent) * flDistance
	-- 使用备用飞盘攻击
	if hParent:HasModifier("modifier_shredderA_1_disarm") then
		if hParent:HasModifier("modifier_shredderA_2_buff") and hParent:FindModifierByName("modifier_shredderA_2_buff"):GetStackCount() > 0 then
			-- 创建投射物马甲
			local hThinker = CreateUnitByName("npc_dota_dummy", hParent:GetAbsOrigin(), false, hParent, hParent, hParent:GetTeamNumber())
			hThinker:AddNewModifier(hParent, hParent:FindAbilityByName("shredderA_2"), "modifier_shredderA_2_thinker", { vPosition = vEnd, record = tAttackInfo.record, iAbilityIndex = hAttackAbility:entindex() })
		else
			DelAttackInfo(AttackInfo.record)
		end
	else
		-- 创建投射物马甲
		local hThinker = CreateUnitByName("npc_dota_dummy", hParent:GetAbsOrigin(), false, hParent, hParent, hParent:GetTeamNumber())
		hThinker:AddNewModifier(hParent, hAbility, "modifier_shredderA_1_thinker", { vPosition = vEnd, record = tAttackInfo.record, iAbilityIndex = hAttackAbility:entindex() })
		hParent.hAttackTarget = nil
		hParent:Stop()
	end
	-- 如果开启备用飞盘则不缴械
	-- hParent:AddNewModifier(hParent, hAbility, "modifier_shredderA_1_disarm", nil)
	-- if hParent:HasModifier("modifier_shredderA_2_buff") then
	-- 	hParent:AddNewModifier(hParent, hParent:FindAbilityByName("shredderA_2"), "modifier_shredderA_2_disarm", nil)
	-- else
	-- end
end
function modifier_shredderA_1:CheckState()
	-- 没有备用飞盘使用次数时缴械
	local hParent = self:GetParent()
	local bDisarm = false
	local hModifier = hParent:FindModifierByName("modifier_shredderA_2_buff")
	if hParent:HasModifier("modifier_shredderA_1_disarm") and (not IsValid(hModifier) or hModifier:GetStackCount() == 0) then
		bDisarm = true
	end
	return {
		[MODIFIER_STATE_DISARMED] = bDisarm
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_shredderA_1_thinker == nil then
	modifier_shredderA_1_thinker = class({}, nil, HorizontalModifier)
end
function modifier_shredderA_1_thinker:OnCreated(params)
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
		-- 缴械
		self.hModifier = hCaster:AddNewModifier(hCaster, self:GetAbility(), "modifier_shredderA_1_disarm", nil)
		if not self:ApplyHorizontalMotionController() then
			self:Destroy()
		end
		-- 音效
		hCaster:EmitSound("Hero_Shredder.Chakram.Tree")
		hParent:EmitSound("Hero_Shredder.Chakram")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/shreddera/shreddera_1_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_shredderA_1_thinker:OnDestroy()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsServer() then
		hParent:RemoveHorizontalMotionController(self)
		if IsValid(hParent) then
			hParent:StopSound("Hero_Shredder.Chakram")
			hParent:RemoveSelf()
			DelAttackInfo(self.AttackInfo.record)
			if IsValid(self.hModifier) then
				self.hModifier:Destroy()
			end
		end
	end
end
function modifier_shredderA_1_thinker:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		-- 销毁飞盘
		if not IsValid(self:GetAbility()) or not IsValid(self:GetAbility():GetCaster()) then
			self:Destroy()
			return
		end
		local hCaster = self:GetAbility():GetCaster()
		local vDirection = self.bReturn and (hCaster:GetAbsOrigin() - me:GetAbsOrigin()):Normalized() or (self.vEnd - me:GetAbsOrigin()):Normalized()
		local flDistance = (self.vEnd - me:GetAbsOrigin()):Length2D()
		local iSpeed = RemapVal(flDistance, 0, self.flDistance, 10, self.iSpeed)	-- 速度随距离逐渐变化
		local vVelocity = vDirection * iSpeed
		me:SetAbsOrigin(GetGroundPosition(me:GetAbsOrigin() + vVelocity * dt, me))

		local tTargets = FindUnitsInRadiusWithAbility(hCaster, me:GetAbsOrigin(), self.iRadius, self:GetAbility())
		for _, hUnit in pairs(tTargets) do
			if TableFindKey(self.tTargets, hUnit) == nil then
				table.insert(self.tTargets, hUnit)
				-- 命中
				EModifier:NotifyEvt(EMDF_EVENT_ON_ATTACK_HIT, hUnit, self.AttackInfo)
				-- 伤害
				self.hAbility:OnDamage(hUnit, self.AttackInfo)
				-- 击退
				if hCaster:HasModifier("modifier_shredderA_3") and not hUnit:IsBoss() then
					me:KnockBack(hUnit:GetAbsOrigin() - vDirection, hUnit, RemapVal(iSpeed, 0, self.iSpeed, 10, 300), 0, 0.2, false)
				end
			end
			-- 持续伤害效果
			if not hUnit:HasModifier("modifier_shredderA_1_debuff") and hUnit then
				hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_shredderA_1_debuff", { iThinkerIndex = me:entindex() })
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
function modifier_shredderA_1_thinker:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_shredderA_1_thinker:CheckState()
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
if modifier_shredderA_1_debuff == nil then
	modifier_shredderA_1_debuff = class({}, nil, eom_modifier)
end
function modifier_shredderA_1_debuff:IsDebuff()
	return true
end
function modifier_shredderA_1_debuff:OnCreated(params)
	self.movespeed_reduce_pct = self:GetAbilitySpecialValueFor("movespeed_reduce_pct")
	if IsServer() then
		self.iRadius = self:GetAbilitySpecialValueFor("radius")			-- 伤害半径
		self.flInterval = self:GetAbilitySpecialValueFor("interval")	-- 伤害间隔
		self.hThinker = EntIndexToHScript(params.iThinkerIndex)			-- 飞盘马甲
		self:StartIntervalThink(self.flInterval)
	end
end
function modifier_shredderA_1_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsValid(hCaster) then
		hCaster:DealDamage(hParent, self:GetAbility(), 0)
		-- 三技能减甲效果
		if hCaster:HasModifier("modifier_shredderA_3") then
			hCaster:FindAbilityByName("shredderA_3"):Action(hParent)
		end
	end
	if not IsValid(self.hThinker) or CalculateDistance(self.hThinker, hParent) > self.iRadius then
		self:Destroy()
	end
end
function modifier_shredderA_1_debuff:EDeclareFunctions()
	return {
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_shredderA_1_debuff:GetMoveSpeedBonusPercentage()
	-- 三技能减速效果，数值配在1技能上，三技能数值仅做显示
	if IsValid(self:GetCaster()) and self:GetCaster():HasModifier("modifier_shredderA_3") then
		return -self.movespeed_reduce_pct
	end
end
function modifier_shredderA_1_debuff:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_shredderA_1_disarm == nil then
	modifier_shredderA_1_disarm = class({}, nil, eom_modifier)
end
function modifier_shredderA_1_disarm:IsHidden()
	return false
end
function modifier_shredderA_1_disarm:OnCreated(params)
	if IsServer() then
		self:GetParent():AddActivityModifier("chakram")
	end
end
function modifier_shredderA_1_disarm:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveActivityModifier("chakram")
	end
end