LinkLuaModifier("modifier_pangolier_3", "abilities/tower/pangolier/pangolier_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pangolier_3_buff", "abilities/tower/pangolier/pangolier_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if pangolier_3 == nil then
	pangolier_3 = class({})
end
function pangolier_3:Prechace(context)
	PrecacheResource("particle", "particles/units/heroes/pangolier/pangolier_3.vpcf", context)
end
function pangolier_3:GetIntrinsicModifierName()
	return "modifier_pangolier_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_pangolier_3 == nil then
	modifier_pangolier_3 = class({}, nil, eom_modifier)
end
function modifier_pangolier_3:IsHidden()
	return true
end
function modifier_pangolier_3:OnCreated(params)
	self.counter_chance = self:GetAbilitySpecialValueFor("counter_chance")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/pangolier/pangolier_3.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_weapon", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_weapon", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pangolier_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_pangolier_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hTarget == hParent and
	RollPercentage(self.counter_chance) and
	hParent:IsAbilityReady(hAbility) then
		hParent:AddNewModifier(hParent, hAbility, "modifier_pangolier_3_buff", { duration = 0.1, vPosition = tAttackInfo.attacker:GetAbsOrigin() })
		return true
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_pangolier_3_buff == nil then
	modifier_pangolier_3_buff = class({}, nil, eom_modifier)
end
function modifier_pangolier_3_buff:IsHidden()
	return true
end
function modifier_pangolier_3_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_pangolier_3_buff:OnCreated(params)
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	self.width = self:GetAbilitySpecialValueFor("width")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
		local hParent = self:GetParent()
		local vPosition = StringToVector(params.vPosition)
		local vForward = (vPosition - hParent:GetAbsOrigin()):Normalized()
		self.vStart = hParent:GetAbsOrigin() + vForward * self.width
		self.vEnd = hParent:GetAbsOrigin() + vForward * self.range
		self:StartIntervalThink(0)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_pangolier/pangolier_swashbuckler.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 1, vForward)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_pangolier_3_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local tTargets = FindUnitsInLineWithAbility(hParent, self.vStart, self.vEnd, self.width, self:GetAbility())
	for _, hUnit in pairs(tTargets) do
		hParent:Attack(hUnit, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE + ATTACK_STATE_SKIPCOUNTING)
	end
	self:StartIntervalThink(-1)
	-- self:Destroy()
	return
end
function modifier_pangolier_3_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_damage_pct,
	}
end
function modifier_pangolier_3_buff:GetPhysicalAttackBonusPercentage()
	return self.bonus_damage_pct
end