LinkLuaModifier("modifier_juggernaut_1", "abilities/tower/juggernaut/juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_1_buff", "abilities/tower/juggernaut/juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_juggernaut_1_debuff", "abilities/tower/juggernaut/juggernaut_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if juggernaut_1 == nil then
	juggernaut_1 = class({})
end
function juggernaut_1:Precache(context)
	PrecacheResource("particle", "particles/units/heroes/juggernaut/juggernaut_1.vpcf", context)
end
function juggernaut_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vDirection = CalculateDirection(hTarget, hCaster)

	local vTarget = hTarget:GetAbsOrigin() + vDirection * (hCaster:GetHullRadius() + hTarget:GetHullRadius())
	if not GridNav:CanFindPath(hCaster:GetAbsOrigin(), vTarget) then
		vTarget = hTarget:GetAbsOrigin()
	end

	self:Slash(vTarget)

	ExecuteOrder(hCaster, DOTA_UNIT_ORDER_ATTACK_TARGET, hTarget, self)
	-- 技能2
	local hAbility = hCaster:FindAbilityByName("juggernaut_2")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		if hAbility:GetIntrinsicModifier() and hAbility:GetIntrinsicModifier():GetStackCount() >= hAbility:GetSpecialValueFor("unlock_count") then
			hAbility:Slash()
		else
			hAbility:Action()
		end
	end
end
function juggernaut_1:Slash(vTargetLoc)
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local flDuration = self:GetDuration()
	-- 冷却
	self:UseResources(false, false, true)
	-- 位移
	local vDir = (vTargetLoc - vCasterLoc):Normalized()
	FindClearSpaceForUnit(hCaster, vTargetLoc, true)
	ProjectileManager:ProjectileDodge(hCaster)
	-- 临时暴击
	hCaster:SetVal(ATTRIBUTE_KIND.PhysicalCrit, self:GetSpecialValueFor("crit_mult"), self, 100)

	-- 攻速
	hCaster:AddNewModifier(hCaster, self, "modifier_juggernaut_1_buff", { duration = flDuration })

	local tTargets = FindUnitsInLineWithAbility(hCaster, vCasterLoc, vTargetLoc, 150, self)
	for _, hUnit in pairs(tTargets) do
		-- 减甲
		if IsValid(hUnit) then
			-- hUnit:AddNewModifier(hCaster, self, "modifier_juggernaut_1_debuff", { duration = flDuration })
			-- 暴击
			hCaster:Attack(hUnit, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
			-- 移除减甲
			-- hUnit:RemoveModifierByName("modifier_juggernaut_1_debuff")
		end

	end
	-- 取消暴击
	hCaster:SetVal(ATTRIBUTE_KIND.PhysicalCrit, nil, self)

	-- particle
	local iPtclID = ParticleManager:CreateParticle("particles/units/heroes/juggernaut/juggernaut_1.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iPtclID, 0, vCasterLoc)
	ParticleManager:SetParticleControl(iPtclID, 1, hCaster:GetAbsOrigin())
	ParticleManager:ReleaseParticleIndex(iPtclID)

	hCaster:EmitSound("Hero_Juggernaut.OmniSlash.Damage")
end
function juggernaut_1:GetIntrinsicModifierName()
	return "modifier_juggernaut_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_juggernaut_1 == nil then
	modifier_juggernaut_1 = class({}, nil, eom_modifier)
end
function modifier_juggernaut_1:IsHidden()
	return true
end
function modifier_juggernaut_1:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
		self.bCast = false
		self:StartIntervalThink(0)
		self.tAnimations = {
			{ iAnimation = ACT_DOTA_ATTACK_EVENT, sActivityModifier = "favor" },
			{ iAnimation = ACT_DOTA_ATTACK_EVENT, sActivityModifier = "ti8" },
			{ iAnimation = ACT_DOTA_ATTACK_EVENT, sActivityModifier = "odachi" },
		}
	end
end
function modifier_juggernaut_1:OnRefresh(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.crit_mult = self:GetAbilitySpecialValueFor("crit_mult")
	if IsServer() then
	end
end
function modifier_juggernaut_1:OnIntervalThink()
	if IsServer() and self:GetParent():IsAlive() then
		local hParent = self:GetParent()
		local vParent = hParent:GetAbsOrigin()
		if self:GetAbility():IsAbilityReady() then
			local tTargets = FindUnitsInRadiusWithAbility(hParent, vParent, self.distance, self:GetAbility(), FIND_FARTHEST)
			local hTarget = tTargets[1]
			if IsValid(hTarget) and self.bCast == false then
				local tAnimation = RandomValue(self.tAnimations)
				hParent:PassiveCast(self:GetAbility(), DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = hTarget, sActivityModifier = tAnimation.sActivityModifier, iCastAnimation = tAnimation.iAnimation, bIgnoreBackswing = true })
			end
		end
	end
end
function modifier_juggernaut_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = { self:GetParent() }
	}
end
function modifier_juggernaut_1:OnDeath(params)
	if params.attacker == self:GetParent() then
		self:GetAbility():EndCooldown()
	end
end
---------------------------------------------------------------------
if modifier_juggernaut_1_debuff == nil then
	modifier_juggernaut_1_debuff = class({}, nil, eom_modifier)
end
function modifier_juggernaut_1_debuff:IsDebuff()
	return true
end
function modifier_juggernaut_1_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/juggernaut/jugg_arcana/juggernaut_arcana_omni_slash_tgt_bladekeeper.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_juggernaut_1_debuff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = -50
	}
end
function modifier_juggernaut_1_debuff:GetPhysicalArmorBonusPercentage()
	return -50
end
function modifier_juggernaut_1_debuff:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_juggernaut_1_buff == nil then
	modifier_juggernaut_1_buff = class({}, nil, eom_modifier)
end
function modifier_juggernaut_1_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
end
function modifier_juggernaut_1_buff:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_juggernaut_1_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed
	}
end
function modifier_juggernaut_1_buff:GetAttackSpeedBonus()
	return self.attackspeed
end
function modifier_juggernaut_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_juggernaut_1_buff:OnTooltip()
	return self.attackspeed
end