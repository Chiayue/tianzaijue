LinkLuaModifier("modifier_kingkong_4", "abilities/boss/kingkong_4.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_kingkong_4_regen", "abilities/boss/kingkong_4.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if kingkong_4 == nil then
	kingkong_4 = class({})
end
function kingkong_4:OnAbilityPhaseStart()
	self.hModifier = self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY)
	return true
end
function kingkong_4:OnAbilityPhaseInterrupted()
	self.hModifier:Destroy()
end
function kingkong_4:OnSpellStart()
	if IsValid(self.hModifier) then
		self.hModifier:Destroy()
	end
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_kingkong_4_regen", nil)
end
function kingkong_4:OnChannelFinish(bInterrupted)
	self:GetCaster():RemoveModifierByName("modifier_kingkong_4_regen")
	if bInterrupted == false then
		self:GetCaster():FindModifierByName("modifier_kingkong_3"):SetStackCount(0)
	end
end
function kingkong_4:GetIntrinsicModifierName()
	return "modifier_kingkong_4"
end
---------------------------------------------------------------------
--Modifiers
if modifier_kingkong_4 == nil then
	modifier_kingkong_4 = class({}, nil, BaseModifier)
end
function modifier_kingkong_4:IsHidden()
	return true
end
function modifier_kingkong_4:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_kingkong_4:OnIntervalThink()
	if self:GetParent():GetHealthPercent() <= self.trigger_pct then
		self:GetParent():Purge(false, true, false, true, true)
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex(),
		})
		self:StartIntervalThink(-1)
	end
end
---------------------------------------------------------------------
if modifier_kingkong_4_regen == nil then
	modifier_kingkong_4_regen = class({}, nil, BaseModifier)
end
function modifier_kingkong_4_regen:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.regen_pct = (self.health_pct - self:GetParent():GetHealthPercent()) / self:GetAbility():GetChannelTime()
	if IsServer() then
		self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY, self:GetDuration())
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_4.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_kingkong_4_regen:OnDestroy()
	if IsServer() then
	end
end
function modifier_kingkong_4_regen:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE
	}
end
function modifier_kingkong_4_regen:GetModifierHealthRegenPercentage()
	return self.regen_pct
end