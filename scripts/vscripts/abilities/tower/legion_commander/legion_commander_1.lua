LinkLuaModifier("modifier_legion_commander_1", "abilities/tower/legion_commander/legion_commander_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_1_buff", "abilities/tower/legion_commander/legion_commander_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_legion_commander_1_buff_1", "abilities/tower/legion_commander/legion_commander_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if legion_commander_1 == nil then
	legion_commander_1 = class({}, nil, ability_base_ai)
end
function legion_commander_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function legion_commander_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vCasterLoc = hCaster:GetAbsOrigin()
	local flRadius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vCasterLoc, flRadius, self)
	local flDamage = self:GetSpecialValueFor("damage_per_unit_pct") * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * #tTargets
	hCaster:AddNewModifier(hCaster, self, "modifier_legion_commander_1_buff", { duration = self:GetDuration(), iCount = #tTargets })
	for _, hUnit in pairs(tTargets) do
		-- hUnit:AddNewModifier(hCaster, self, "modifier_legion_commander_1_buff_1", { duration = self:GetDuration() })
		hUnit:AddBuff(hCaster, BUFF_TYPE.TAUNT, self:GetDuration())
		hCaster:DealDamage(hUnit, self, flDamage)
		hUnit:EmitSound("Hero_LegionCommander.Overwhelming.Hero")
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/legion_commander/legion_commander_1.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_LegionCommander.Overwhelming.Cast")
end
function legion_commander_1:GetIntrinsicModifierName()
	return "modifier_legion_commander_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_legion_commander_1 == nil then
	modifier_legion_commander_1 = class({}, nil, eom_modifier)
end
function modifier_legion_commander_1:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_legion_commander_1:OnCreated(params)
	self.atk_bonus = self:GetAbilitySpecialValueFor("atk_bonus")
	if IsServer() then
		self:SetStackCount(self:GetAbility():Load("iStackCount"))
	end
end
function modifier_legion_commander_1:OnRefresh(params)
	self.atk_bonus = self:GetAbilitySpecialValueFor("atk_bonus")
end
function modifier_legion_commander_1:AddStackCount()
	self.atk_bonus = self:GetAbilitySpecialValueFor("atk_bonus")
	if IsServer() then
		self:IncrementStackCount(self.atk_bonus)
		self:GetAbility():Save("iStackCount", self:GetStackCount())
	end
end
function modifier_legion_commander_1:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_legion_commander_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_legion_commander_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	self:AddStackCount()
end
function modifier_legion_commander_1:OnTooltip()
	return self:GetStackCount()
end
function modifier_legion_commander_1:GetPhysicalAttackBonus(params)
	return self:GetStackCount()
end
---------------------------------------------------------------------
--Modifiers
if modifier_legion_commander_1_buff == nil then
	modifier_legion_commander_1_buff = class({}, nil, eom_modifier)
end
function modifier_legion_commander_1_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_legion_commander_1_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.attackspeed_per_unit = self:GetAbilitySpecialValueFor("attackspeed_per_unit")
	if IsServer() then
		self:SetStackCount(params.iCount)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_legion_commander/legion_commander_odds.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 4, Vector(self.radius, 0, 0))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_legion_commander_1_buff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE
	}
end
function modifier_legion_commander_1_buff:GetAttackSpeedPercentage()
	return self.attackspeed_per_unit * self:GetStackCount()
end
function modifier_legion_commander_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_legion_commander_1_buff:OnTooltip()
	return self.attackspeed_per_unit * self:GetStackCount()
end
---------------------------------------------------------------------
--Modifiers
if modifier_legion_commander_1_buff_1 == nil then
	modifier_legion_commander_1_buff_1 = class({}, nil, eom_modifier)
end
function modifier_legion_commander_1_buff_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_legion_commander_1_buff_1:OnCreated(params)
	self.atk_bonus = self:GetAbilitySpecialValueFor("atk_bonus")
	if IsServer() then
	else
	end
end
function modifier_legion_commander_1_buff_1:EDeclareFunctions()
	return {
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_legion_commander_1_buff_1:IsDebuff()
	return true
end
function modifier_legion_commander_1_buff_1:OnDeath(params)
	if params.unit == self:GetParent() then
		self:GetAbility():GetIntrinsicModifier():AddStackCount()
	end
end