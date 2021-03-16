LinkLuaModifier("modifier_courier_crit", "abilities/courier/sr/courier_crit.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_courier_crit_buff", "abilities/courier/sr/courier_crit.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_crit == nil then
	courier_crit = class({})
end
function courier_crit:GetIntrinsicModifierName()
	return "modifier_courier_crit"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_crit == nil then
	modifier_courier_crit = class({}, nil, eom_modifier)
end
function modifier_courier_crit:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
	end
	self:UpdateValues()
end
function modifier_courier_crit:OnRefresh(params)
	self:UpdateValues()
end
function modifier_courier_crit:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_courier_crit:IsHidden()
	return true
end
function modifier_courier_crit:UpdateValues()
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_courier_crit:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_courier_crit_buff", nil)
			end, UnitType.Building)
		end
	end
end
function modifier_courier_crit:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_courier_crit:OnInBattle()
	self:OnIntervalThink()
end
function modifier_courier_crit:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_courier_crit_buff", nil)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_courier_crit_buff == nil then
	modifier_courier_crit_buff = class({}, nil, eom_modifier)
end
function modifier_courier_crit_buff:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor('crit_chance')
	self.crit_damage = self:GetAbilitySpecialValueFor('crit_damage')
end
function modifier_courier_crit_buff:OnRefresh(rarams)
	self.crit_chance = self:GetAbilitySpecialValueFor('crit_chance')
	self.crit_damage = self:GetAbilitySpecialValueFor('crit_damage')
end
function modifier_courier_crit_buff:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
	}
end
function modifier_courier_crit_buff:GetAttackCritBonus()
	return self.crit_damage, self.crit_chance
end