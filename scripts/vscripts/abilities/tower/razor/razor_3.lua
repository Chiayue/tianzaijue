LinkLuaModifier("modifier_razor_3", "abilities/tower/razor/razor_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_3_buff", "abilities/tower/razor/razor_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_razor_3_debuff", "abilities/tower/razor/razor_3.lua", LUA_MODIFIER_MOTION_NONE)
if razor_3 == nil then
	razor_3 = class({})
end
function razor_3:GetIntrinsicModifierName()
	return "modifier_razor_3"
end
---------------------------------------------------------------------
-- Modifiers
if modifier_razor_3 == nil then
	modifier_razor_3 = class({}, nil, eom_modifier)
end
function modifier_razor_3:IsHidden()
	return true
end
function modifier_razor_3:OnCreated(params)
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:OnInBattle()
		end
	end
end
function modifier_razor_3:OnDestroy()
	if IsServer() then
		self:OnBattleEnd()
	end
end
function modifier_razor_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_razor_3:OnInBattle()
	self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_razor_3_buff", nil)
end
function modifier_razor_3:OnBattleEnd()
	self:GetParent():RemoveModifierByName("modifier_razor_3_buff")
end
---------------------------------------------------------------------
if modifier_razor_3_buff == nil then
	modifier_razor_3_buff = class({}, nil, BaseModifier)
end
function modifier_razor_3_buff:IsHidden()
	return true
end
function modifier_razor_3_buff:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor("interval")
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.reduce_duration = self:GetAbilitySpecialValueFor("reduce_duration")
	self.chance = self:GetAbilitySpecialValueFor("chance")
	local hParent = self:GetParent()
	if IsServer() then
		self:StartIntervalThink(self.interval)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_rain_storm.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_razor_3_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hTarget = hParent:GetAttackTarget()
		if hTarget == nil then
			local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, self:GetAbility(), FIND_CLOSEST)
			if IsValid(tTargets[1]) then
				hTarget = tTargets[1]
			end
		end
		if IsValid(hTarget) then
			if RollPercentage(self.chance) then
				local hAbility = self:GetParent():FindAbilityByName("razor_1")
				hAbility:OnSpellStart(hTarget)
			end
			hParent:DealDamage(hTarget, self:GetAbility(), 0)
			hTarget:AddNewModifier(hParent, self:GetAbility(), "modifier_razor_3_debuff", { duration = self.reduce_duration })
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_razor/razor_storm_lightning_strike.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin() + Vector(0, 0, 500))
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
			self:AddParticle(iParticleID, false, false, 0, false, false)
		end
	end
end
---------------------------------------------------------------------
if modifier_razor_3_debuff == nil then
	modifier_razor_3_debuff = class({}, nil, eom_modifier)
end
function modifier_razor_3_debuff:IsDebuff()
	return true
end
function modifier_razor_3_debuff:OnCreated(params)
	self.armor_reduce = self:GetAbilitySpecialValueFor("armor_reduce")
	if IsServer() then
		self.tData = {}
		table.insert(self.tData, self:GetDieTime())
		self:IncrementStackCount()
		self:StartIntervalThink(0)
	end
end
function modifier_razor_3_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
		table.insert(self.tData, self:GetDieTime())
	end
end
function modifier_razor_3_debuff:OnIntervalThink()
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i] < flTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end
function modifier_razor_3_debuff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
	}
end
function modifier_razor_3_debuff:GetMagicalArmorBonus()
	return -self.armor_reduce * self:GetStackCount()
end
function modifier_razor_3_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_razor_3_debuff:OnTooltip()
		return self.armor_reduce * self:GetStackCount()
end