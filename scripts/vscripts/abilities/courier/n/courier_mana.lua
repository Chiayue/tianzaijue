LinkLuaModifier("modifier_courier_mana", "abilities/courier/n/courier_mana.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_mana_buff", "abilities/courier/n/courier_mana.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_mana == nil then
	courier_mana = class({})
end
function courier_mana:GetIntrinsicModifierName()
	return "modifier_courier_mana"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_mana == nil then
	modifier_courier_mana = class({}, nil, eom_modifier)
end
function modifier_courier_mana:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_courier_mana:OnRefresh(params)
	self:UpdateValues()
end
function modifier_courier_mana:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_courier_mana:IsHidden()
	return true
end
function modifier_courier_mana:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_courier_mana:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_courier_mana_buff", nil)
			end, UnitType.Building)
		end
	end
end
function modifier_courier_mana:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_courier_mana:OnInBattle()
	self:OnIntervalThink()
end
function modifier_courier_mana:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_courier_mana_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_courier_mana_buff == nil then
	modifier_courier_mana_buff = class({}, nil, eom_modifier)
end
function modifier_courier_mana_buff:OnCreated(params)
	self.bonus_max_mana = self:GetAbilitySpecialValueFor('bonus_max_mana')
	if IsServer() then
	end
end
function modifier_courier_mana_buff:OnRefresh(params)
	self.bonus_max_mana = self:GetAbilitySpecialValueFor('bonus_max_mana')
	if IsServer() then
	end
end
function modifier_courier_mana_buff:EDeclareFunctions()
	return {
		[EMDF_STATUS_MANA_BONUS] = self.bonus_max_mana,
	}
end
function modifier_courier_mana_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_courier_mana_buff:OnTooltip()
	return self.bonus_max_mana
end
function modifier_courier_mana_buff:GetStatusManaBonus()
	return self.bonus_max_mana
end