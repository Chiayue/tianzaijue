LinkLuaModifier("modifier_sk_4", "abilities/boss/sk_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_4_burrow", "abilities/boss/sk_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_4_unburrow", "abilities/boss/sk_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_4_burrow_forward_strike", "abilities/boss/sk_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sk_4_burrow_backward_strike", "abilities/boss/sk_4.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if sk_4 == nil then
	sk_4 = class({})
end
function sk_4:OnAbilityPhaseStart()
	if IsServer() then
		EmitSoundOn("Hero_NyxAssassin.Burrow.In", self:GetCaster())
		local nFXIndex = ParticleManager:CreateParticle("particles/units/boss/sand_king/nyx_assassin_burrow.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(nFXIndex, 0, self:GetCaster():GetOrigin())
		ParticleManager:SetParticleControlForward(nFXIndex, 0, self:GetCaster():GetForwardVector())

		self.hModifier = self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY)
	end
	return true
end
function sk_4:GetPlaybackRateOverride()
	return 0.75
end
function sk_4:OnSpellStart()
	self.hModifier:Destroy()
	local duration = self:GetSpecialValueFor("duration")
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_sk_4_burrow", { duration = duration })
end
function sk_4:GetIntrinsicModifierName()
	return "modifier_sk_4"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_sk_4 == nil then
	modifier_sk_4 = class({}, nil, BaseModifier)
end
function modifier_sk_4:OnCreated(params)
	self.threshold = self:GetAbilitySpecialValueFor("threshold")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_sk_4:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if self:GetParent():IsAbilityReady(self:GetAbility()) and self:GetParent():GetHealthPercent() < self.threshold then
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.distance, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST, false)
		if IsValid(tTargets[1]) then
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end
function modifier_sk_4:IsHidden()
	return true
end
---------------------------------------------------------------------
if modifier_sk_4_burrow == nil then
	modifier_sk_4_burrow = class({})
end
function modifier_sk_4_burrow:IsHidden()
	return true
end
function modifier_sk_4_burrow:GetPriority()
	return MODIFIER_PRIORITY_SUPER_ULTRA
end
function modifier_sk_4_burrow:OnCreated(kv)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.damage_reduce = self:GetAbilitySpecialValueFor("damage_reduce")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.backward_chance = self:GetAbilitySpecialValueFor("backward_chance")
	self.hull_radius = self:GetAbilitySpecialValueFor("hull_radius")
	if IsServer() then
		self.flHullRadius = self:GetParent():GetHullRadius()
		self:GetParent():SetHullRadius(self.hull_radius)
		self:StartIntervalThink(self:GetAbilitySpecialValueFor("interval"))
		self:OnIntervalThink()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sandking/sandking_epicenter_tell.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_tail", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)

		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_nyx_assassin/nyx_assassin_burrow_inground.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end

end
function modifier_sk_4_burrow:OnRefresh(kv)
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
end
function modifier_sk_4_burrow:OnDestroy()
	local hAbility = self:GetAbility()
	if IsServer() then
		self:GetParent():SetHullRadius(self.flHullRadius)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_sk_4_unburrow", { duration = 3.3 })
		local tTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), self:GetParent():GetAbsOrigin(), nil, 320, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_ANY_ORDER, false)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_phased", { duration = 1 })
		end
	end
end
function modifier_sk_4_burrow:CheckState()
	local state =	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = false,
	}
	return state
end
function modifier_sk_4_burrow:DeclareFunctions()
	local funcs =	{
		MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
		MODIFIER_PROPERTY_TURN_RATE_PERCENTAGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE
	}
	return funcs
end
function modifier_sk_4_burrow:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if self.attack_count <= 0 then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	local vStart = hParent:GetAbsOrigin()
	-- 索敌
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), vStart, nil, self.distance, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags(), FIND_CLOSEST, false)
	if IsValid(tTargets[1]) then
		hParent:FaceTowards(tTargets[1]:GetAbsOrigin())
	end
	local vForward = IsValid(tTargets[1]) and (vStart - tTargets[1]:GetAbsOrigin()):Normalized() or hParent:GetForwardVector() * -1
	local vEnd = vStart + vForward * self.distance
	-- 身后是否有敌人
	local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), vStart, vEnd, nil, self.width, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags())
	if IsValid(tTargets[1]) and RollPercentage(self.backward_chance) then
		hParent:AddNewModifier(hParent, hAbility, "modifier_sk_4_burrow_backward_strike", nil)
		hParent:StartGesture(ACT_DOTA_CAST_ABILITY_ROT)
	else
		hParent:AddNewModifier(hParent, hAbility, "modifier_sk_4_burrow_forward_strike", nil)
		hParent:StartGesture(ACT_DOTA_CAST_ABILITY_7)
	end
	self.attack_count = self.attack_count - 1
end
function modifier_sk_4_burrow:GetActivityTranslationModifiers(params)
	return "burrowed"
end
function modifier_sk_4_burrow:GetModifierTurnRate_Percentage(params)
	return -50
end
function modifier_sk_4_burrow:GetModifierIncomingDamage_Percentage(params)
	return -self.damage_reduce
end
---------------------------------------------------------------------
if modifier_sk_4_burrow_forward_strike == nil then
	modifier_sk_4_burrow_forward_strike = class({})
end
function modifier_sk_4_burrow_forward_strike:IsHidden()
	return true
end
function modifier_sk_4_burrow_forward_strike:OnCreated(kv)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(1.5)
	end
end
function modifier_sk_4_burrow_forward_strike:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vForward = hParent:GetForwardVector()
	local vStart = hParent:GetAbsOrigin()
	local vEnd = vStart + vForward * self.distance
	local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), vStart, vEnd, nil, self.width, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags())
	for _, hUnit in pairs(tTargets) do
		local damageInfo =		{
			victim = hUnit,
			attacker = hParent,
			damage = hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.damage * 0.01,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = hAbility,
		}
		hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.stun_duration * hUnit:GetStatusResistanceFactor() })
		ApplyDamage(damageInfo)
	end

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_fallback_mid.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
	self:Destroy()
end
---------------------------------------------------------------------
if modifier_sk_4_burrow_backward_strike == nil then
	modifier_sk_4_burrow_backward_strike = class({})
end
function modifier_sk_4_burrow_backward_strike:IsHidden()
	return true
end
function modifier_sk_4_burrow_backward_strike:OnCreated(kv)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	if IsServer() then
		self.damage = self:GetAbility():GetAbilityDamage()
		self:StartIntervalThink(0.84)
	end
end
function modifier_sk_4_burrow_backward_strike:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	local vForward = hParent:GetForwardVector() * -1
	local vStart = hParent:GetAbsOrigin()
	local vEnd = vStart + vForward * self.distance
	local tTargets = FindUnitsInLine(hParent:GetTeamNumber(), vStart, vEnd, nil, self.width, hAbility:GetAbilityTargetTeam(), hAbility:GetAbilityTargetType(), hAbility:GetAbilityTargetFlags())
	for _, hUnit in pairs(tTargets) do
		local damageInfo =		{
			victim = hUnit,
			attacker = hParent,
			damage = hParent:GetAverageTrueAttackDamage(hUnit) * self.damage * 0.01,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = hAbility,
		}
		ApplyDamage(damageInfo)
		hUnit:AddNewModifier(hParent, hAbility, "modifier_stunned", { duration = self.stun_duration * hUnit:GetStatusResistanceFactor() })
	end

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/earthshaker/egteam_set/hero_earthshaker_egset/earthshaker_fissure_fallback_mid.vpcf", PATTACH_ABSORIGIN, hParent)
	ParticleManager:SetParticleControl(iParticleID, 0, vStart)
	ParticleManager:SetParticleControl(iParticleID, 1, vEnd)
	self:Destroy()
end
---------------------------------------------------------------------
if modifier_sk_4_unburrow == nil then
	modifier_sk_4_unburrow = class({})
end
function modifier_sk_4_unburrow:IsHidden()
	return true
end
function modifier_sk_4_unburrow:OnCreated(kv)
	if IsServer() then
		self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_RAZE_2, 0.5)
	end
end
function modifier_sk_4_unburrow:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveGesture(ACT_DOTA_RAZE_2)
	end
end
function modifier_sk_4_unburrow:CheckState()
	local state =	{
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	}
	return state
end