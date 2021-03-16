LinkLuaModifier("modifier_lich_2", "abilities/tower/lich/lich_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lich_2_buff", "abilities/tower/lich/lich_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if lich_2 == nil then
	lich_2 = class({})
end
function lich_2:OnSpellStart()
	local hCaster = self:GetCaster()
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_lich_2_buff", nil)
	end, UnitType.AllFirends)
end
function lich_2:GetIntrinsicModifierName()
	return "modifier_lich_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_lich_2 == nil then
	modifier_lich_2 = class({}, nil, ModifierHidden)
end
---------------------------------------------------------------------
if modifier_lich_2_buff == nil then
	modifier_lich_2_buff = class({}, nil, eom_modifier)
end
function modifier_lich_2_buff:OnCreated(params)
	self.armor_factor = self:GetAbilitySpecialValueFor("armor_factor")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.magical_attack_bonus = self:GetAbilitySpecialValueFor("magical_attack_bonus")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	self.bonus_pct = self:GetAbilitySpecialValueFor("bonus_pct")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	self:SetStackCount(self.attack_count)
end
function modifier_lich_2_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
	}
end
function modifier_lich_2_buff:OnAttackLanded(params)
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then
		self:Destroy()
		return
	end
	local hParent = self:GetParent()
	local hTarget = params.target
	local flDamage = hParent:GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.armor_factor * 0.01 + hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical_attack_bonus * 0.01
	if hTarget:HasModifier("modifier_froze") then
		flDamage = flDamage * self.bonus_pct * 0.01
	end
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hTarget:GetAbsOrigin(), self.radius, self:GetAbility())
	hParent:DealDamage(tTargets, self:GetAbility(), flDamage)
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lich/lich_frost_nova_flash_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 0, hTarget:GetAbsOrigin())
	self:AddParticle(iParticleID, false, false, -1, false, false)
	if RollPercentage(self.chance) then
		hTarget:AddBuff(hCaster, BUFF_TYPE.FROZEN, self:GetAbility():GetDuration())
	end
	self:DecrementStackCount()
	if self:GetStackCount() < 1 then
		self:Destroy()
	end
end
function modifier_lich_2_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_lich_2_buff:OnTooltip()
	return self.chance
end