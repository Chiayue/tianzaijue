LinkLuaModifier("modifier_item_last_prism", "abilities/items/item_last_prism.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_last_prism_thinker", "abilities/items/item_last_prism.lua", LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_item_last_prism_debuff", "abilities/items/item_last_prism.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_last_prism == nil then
	item_last_prism = class({}, nil, base_ability_attribute)
end
function item_last_prism:Precache(context)
	PrecacheResource("particle", "particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf", context)
	PrecacheResource("particle", "particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", context)
end
function item_last_prism:GetIntrinsicModifierName()
	return "modifier_item_last_prism"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_last_prism == nil then
	modifier_item_last_prism = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_last_prism:IsHidden()
	return true
end
function modifier_item_last_prism:OnCreated(params)
	if IsServer() then
		self.hPrism = CreateUnitByName("npc_dota_dummy", Vector(0, 0, 0), false, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
		self.hPrism:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_last_prism_thinker", nil)
	end
end
function modifier_item_last_prism:OnRefresh(params)
	if IsServer() then
		if IsValid(self.hPrism) then
			self.hPrism:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_last_prism_thinker", nil)
		end
	end
end
function modifier_item_last_prism:OnDestroy()
	if IsServer() then
		if IsValid(self.hPrism) then
			self.hPrism:ForceKill(false)
		end
	end
end
function modifier_item_last_prism:DeclareFunctions()
	return {
	}
end
---------------------------------------------------------------------
if modifier_item_last_prism_thinker == nil then
	modifier_item_last_prism_thinker = class({}, nil, BothModifier)
end
function modifier_item_last_prism_thinker:OnCreated(params)
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	self.active_count = self:GetAbilitySpecialValueFor("active_count")
	self.active_magical_factor = self:GetAbilitySpecialValueFor("active_magical_factor")
	self.duration = 2
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
		-- 环绕参数
		self.flAngle = 0	-- 记录角度
		self.flSpeed = 90	-- 角速度
		self.flRadius = self:GetCaster():GetHullRadius() + 50	-- 环绕半径
		-- 激活后上升至头顶参数
		self.flRiseRadius = self.flRadius	-- 记录上升半径
		self.flVerticalSpeed = 180	-- 上升速度
		self.flTime = 0.5	-- 上升时间
		-- 下降至环绕参数
		self.flFallRadius = 0	-- 下降半径
		-- 激活参数
		self.bActive = false	-- 激活标记
		self.bRise = false		-- 上升标记
		self.bFall = false		-- 下降标记
		self.iDamageCount = 0	-- 伤害次数记录
		if not self:ApplyHorizontalMotionController() or not self:ApplyVerticalMotionController() then
			self:Destroy()
			return
		end
		self.iParticlePrismID = ParticleManager:CreateParticle("particles/items/item_last_prism/last_prism.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(self.iParticlePrismID, 1, Vector(1, 0, 0))
		self:AddParticle(self.iParticlePrismID, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_ABILITY_EXECUTED, self)
end
function modifier_item_last_prism_thinker:OnRefresh(params)
	self.magical_factor = self:GetAbilitySpecialValueFor("magical_factor")
	self.active_count = self:GetAbilitySpecialValueFor("active_count")
	self.active_magical_factor = self:GetAbilitySpecialValueFor("active_magical_factor")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_last_prism_thinker:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			-- self:GetParent():RemoveSelf()
			self:GetParent():RemoveHorizontalMotionController(self)
			self:GetParent():RemoveVerticalMotionController(self)
		end
	end
	RemoveModifierEvents(MODIFIER_EVENT_ON_ABILITY_EXECUTED, self)
end
function modifier_item_last_prism_thinker:UpdateHorizontalMotion(me, dt)
	if IsServer() then
		local hCaster = self:GetCaster()
		local flRadius = self.flRadius
		if self.bRise then
			flRadius = self.flRiseRadius
		elseif self.bActive then
			flRadius = 0
		elseif self.bFall then
			flRadius = self.flFallRadius
		end
		me:SetAbsOrigin(hCaster:GetAbsOrigin() + AnglesToVector(QAngle(0, self.flAngle, 0)) * flRadius)
		self.flAngle = self.flAngle + self.flSpeed * dt

		-- 半径逐渐减少
		if self.bRise then
			self.flRiseRadius = self.flRiseRadius - (self.flRadius / self.flTime * dt)
			if self.flRiseRadius <= 0 then
				self.bRise = false
				-- 激活
				self.bActive = true
				self.flTimeRecord = 0
				ParticleManager:SetParticleControl(self.iParticlePrismID, 1, Vector(1.5, 0, 0))
				self:StartIntervalThink(0.1)
			end
		end
		if self.bFall then
			self.flFallRadius = self.flFallRadius + (self.flRadius / self.flTime * dt)
			if self.flFallRadius >= self.flRadius then
				self.flFallRadius = self.flRadius
				self.bFall = false
				ParticleManager:SetParticleControl(self.iParticlePrismID, 1, Vector(1, 0, 0))
			end
		end
	end
end
function modifier_item_last_prism_thinker:UpdateVerticalMotion(me, dt)
	if IsServer() then
		if self.bRise then
			me:SetAbsOrigin(me:GetAbsOrigin() + Vector(0, 0, self.flVerticalSpeed / self.flTime * dt))
		end
		if self.bFall then
			me:SetAbsOrigin(me:GetAbsOrigin() - Vector(0, 0, self.flVerticalSpeed / self.flTime * dt))
		end
	end
end
function modifier_item_last_prism_thinker:OnVerticalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_item_last_prism_thinker:OnHorizontalMotionInterrupted()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_item_last_prism_thinker:OnAbilityExecuted(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()
	if params.unit:IsFriendly(hParent) and hCaster:IsAlive() and not params.ability:IsItem() then
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), 1500, hAbility)
		if #tTargets > 0 then
			local hTarget = tTargets[1]
			-- 创建激光特效
			-- local iParticleID = ParticleManager:CreateParticle("particles/econ/items/tinker/tinker_ti10_immortal_laser/tinker_ti10_immortal_laser.vpcf", PATTACH_CUSTOMORIGIN, nil)
			-- ParticleManager:SetParticleControlEnt(iParticleID, 9, params.unit, PATTACH_POINT_FOLLOW, "attach_hitloc", params.unit:GetAbsOrigin(), false)
			-- ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
			-- ParticleManager:ReleaseParticleIndex(iParticleID)
			local iParticleID = ParticleManager:CreateParticle("particles/items/item_last_prism/last_prism_laser.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControlEnt(iParticleID, 9, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			-- 伤害
			local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical_factor * 0.01
			hCaster:DealDamage(hTarget, hAbility, flDamage)
		end
		-- 解锁效果，处于触发状态时不进入计数
		if hAbility:GetLevel() >= self.unlock_level and self.bActive == false and self.bRise == false then
			self:IncrementStackCount()
			if self:GetStackCount() >= self.active_count then
				self:SetStackCount(0)
				-- 进入上升状态
				self.bRise = true
				self.flRiseRadius = self.flRadius	-- 记录上升半径
			end
		end
	end
end
function modifier_item_last_prism_thinker:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if self.hTarget == nil or not IsValid(self.hTarget) or not self.hTarget:IsAlive() then
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), 1500, hAbility)
		if #tTargets > 0 then
			self.hTarget = tTargets[1]
			-- 创建特效
			if self.iParticleID ~= nil then
				ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hTarget:GetAbsOrigin(), false)
			else
				self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/phoenix/phoenix_solar_forge/phoenix_sunray_solar_forge.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(self.iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(self.iParticleID, 9, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self.hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", self.hTarget:GetAbsOrigin(), false)
				self:AddParticle(self.iParticleID, false, false, -1, false, false)
			end
			self.hTarget:AddNewModifier(hCaster, hAbility, "modifier_item_last_prism_debuff", { duration = self.duration })
		else
			if self.iParticleID ~= nil then
				ParticleManager:DestroyParticle(self.iParticleID, false)
				self.iParticleID = nil
			end
		end
	end
	self.flTimeRecord = self.flTimeRecord + 0.1
	if self.flTimeRecord > self.duration then
		if self.iParticleID ~= nil then
			ParticleManager:DestroyParticle(self.iParticleID, false)
			self.iParticleID = nil
		end
		self:StartIntervalThink(-1)
		self.bActive = false
		self.hTarget = nil
		-- 开始下降
		self.flFallRadius = 0
		self.bFall = true
	end
end
function modifier_item_last_prism_thinker:CheckState()
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
if modifier_item_last_prism_debuff == nil then
	modifier_item_last_prism_debuff = class({}, nil, eom_modifier)
end
function modifier_item_last_prism_debuff:IsDebuff()
	return true
end
function modifier_item_last_prism_debuff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_item_last_prism_debuff:OnCreated(params)
	self.magical_armor_reduce = self:GetAbilitySpecialValueFor("magical_armor_reduce")
	self.active_magical_factor = self:GetAbilitySpecialValueFor("active_magical_factor")
	if IsServer() then
		self.flInterval = 0.1
		self:StartIntervalThink(self.flInterval)
	end
end
function modifier_item_last_prism_debuff:OnIntervalThink()
	if IsServer() then
		local flDamage = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.active_magical_factor * 0.01 * self.flInterval
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), flDamage)
	end
end
function modifier_item_last_prism_debuff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS
	}
end
function modifier_item_last_prism_debuff:GetMagicalArmorBonus()
	return RemapValClamped(self:GetElapsedTime(), 0, self:GetDuration(), 0, -self.magical_armor_reduce * self:GetDuration())
end