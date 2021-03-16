LinkLuaModifier("modifier_item_reincarnation_lamp", "abilities/items/item_reincarnation_lamp.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_reincarnation_lamp_buff", "abilities/items/item_reincarnation_lamp.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_reincarnation_lamp == nil then
	item_reincarnation_lamp = class({}, nil, base_ability_attribute)
end
function item_reincarnation_lamp:GetIntrinsicModifierName()
	return "modifier_item_reincarnation_lamp"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_reincarnation_lamp == nil then
	modifier_item_reincarnation_lamp = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_reincarnation_lamp:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_item_reincarnation_lamp:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_reincarnation_lamp:UpdateValues()
	if IsServer() then
		self:Action()
	end
end
function modifier_item_reincarnation_lamp:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_item_reincarnation_lamp:Action()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier("modifier_item_reincarnation_lamp_buff") then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_item_reincarnation_lamp_buff", nil)
				end
			end, UnitType.Building)
			-- local hCommander = Commander:GetCommander(iPlayerID)
			-- self.tModifiers[hCommander:entindex()] = hCommander:AddNewModifier(hCaster, self:GetAbility(), "modifier_item_reincarnation_lamp_buff", nil)
		end
	end
end
function modifier_item_reincarnation_lamp:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_item_reincarnation_lamp:OnInBattle()
	self:Action()
end
function modifier_item_reincarnation_lamp:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and not hUnit:HasModifier("modifier_item_reincarnation_lamp_buff") then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_item_reincarnation_lamp_buff", nil)
	end
end
-- TODO: 重生重做
---------------------------------------------------------------------
--Modifiers
if modifier_item_reincarnation_lamp_buff == nil then
	modifier_item_reincarnation_lamp_buff = class({}, nil, eom_modifier)
end
function modifier_item_reincarnation_lamp_buff:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT
end
function modifier_item_reincarnation_lamp_buff:OnCreated(params)
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.duration = self:GetAbilitySpecialValueFor('duration')
	self.health_regen_bonus = self:GetAbilitySpecialValueFor('health_regen_bonus')
	if IsServer() then
		self.tModifiers = self:GetAbility():GetIntrinsicModifier().tModifiers
		self.flHealthRegenTotal = 0
		self:StartIntervalThink(self.interval)
	end
end
function modifier_item_reincarnation_lamp_buff:OnRefresh(params)
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor('attack_bonus_pct')
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.duration = self:GetAbilitySpecialValueFor('duration')
	self.health_regen_bonus = self:GetAbilitySpecialValueFor('health_regen_bonus')
	if IsServer() then
	end
end
function modifier_item_reincarnation_lamp_buff:EDeclareFunctions()
	return {
		[EMDF_REINCARNATION] = {2},
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_item_reincarnation_lamp_buff:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_HEAL_RECEIVED
	}
end
function modifier_item_reincarnation_lamp_buff:OnBattleEnd()
	self:SetStackCount(0)
end
function modifier_item_reincarnation_lamp_buff:GetHealthRegenBonus()
	return self.health_regen_bonus * self:GetStackCount()
end
function modifier_item_reincarnation_lamp_buff:GetModifierReincarnation()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsValid(hAbility)
	and hAbility:GetLevel() > 0
	and hAbility:IsCooldownReady() then
		hAbility:UseResources(false, false, true)
		local iParticleID = ParticleManager:CreateParticle("particles/items/item_reincarnation_lamp/item_reincarnation_lamp.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		GameTimer(self.duration, function()
			ParticleManager:DestroyParticle(iParticleID, false)
			if GSManager:getStateType() ~= GS_Battle then
				return
			end
			if IsValid(self) then
				self:IncrementStackCount()
			end
		end)
		return self.duration
	end
end
function modifier_item_reincarnation_lamp_buff:OnIntervalThink()
	local iInjuryCount = 0
	for iEntIndex, hModifier in pairs(self.tModifiers) do
		local hUnit = EntIndexToHScript(iEntIndex)
		if IsValid(hUnit) and hUnit:IsAlive() then
			if hUnit:GetHealthPercent() == 100 then
				self.flHealthRegenTotal = self.flHealthRegenTotal + hUnit:GetVal(ATTRIBUTE_KIND.HealthRegen) + hUnit:GetVal(ATTRIBUTE_KIND.StatusHealth) * self.heal_pct * 0.01
			else
				iInjuryCount = iInjuryCount + 1
			end
		end
	end
	if self:GetParent():GetHealthPercent() < 100 and self:GetParent():IsAlive() then
		local flHealAmount = math.ceil(self.flHealthRegenTotal / iInjuryCount) + self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.heal_pct * 0.01
		self:GetParent():Heal(flHealAmount, self:GetAbility())
	end
	self.flHealthRegenTotal = 0
end
function modifier_item_reincarnation_lamp_buff:OnHealReceived(params)
	if params.inflictor ~= nil
	and params.inflictor ~= self:GetAbility()
	and params.gain > 0
	and params.unit:GetHealthPercent() == 100
	then
		self.flHealthRegenTotal = self.flHealthRegenTotal + params.gain
	end
end