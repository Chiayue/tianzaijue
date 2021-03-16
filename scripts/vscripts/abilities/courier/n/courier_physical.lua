LinkLuaModifier("modifier_courier_physical", "abilities/courier/n/courier_physical.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_physical_buff", "abilities/courier/n/courier_physical.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_physical == nil then
	courier_physical = class({})
end
function courier_physical:GetIntrinsicModifierName()
	return "modifier_courier_physical"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_physical == nil then
	modifier_courier_physical = class({}, nil, eom_modifier)
end
function modifier_courier_physical:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_courier_physical:OnRefresh(params)
	self:UpdateValues()
end
function modifier_courier_physical:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_courier_physical:IsHidden()
	return true
end
function modifier_courier_physical:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_courier_physical:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_courier_physical_buff", nil)
			end, UnitType.Building)
		end
	end
end
function modifier_courier_physical:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_courier_physical:OnInBattle()
	self:OnIntervalThink()
end
function modifier_courier_physical:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_courier_physical_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_courier_physical_buff == nil then
	modifier_courier_physical_buff = class({}, nil, eom_modifier)
end
function modifier_courier_physical_buff:OnCreated(params)
	self.bonus_physical_damage_pct = self:GetAbilitySpecialValueFor('bonus_physical_damage_pct')
	if IsServer() then
	end
end
function modifier_courier_physical_buff:OnRefresh(params)
	self.bonus_physical_damage_pct = self:GetAbilitySpecialValueFor('bonus_physical_damage_pct')
	if IsServer() then
	end
end
function modifier_courier_physical_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.bonus_physical_damage_pct
	}
end
function modifier_courier_physical_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_courier_physical_buff:OnTooltip()
	return self.bonus_physical_damage_pct
end
function modifier_courier_physical_buff:GetPhysicalAttackBonusPercentage()
	return self.bonus_physical_damage_pct
end