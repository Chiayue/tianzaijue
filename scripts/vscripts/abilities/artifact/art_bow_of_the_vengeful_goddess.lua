LinkLuaModifier("modifier_art_bow_of_the_vengeful_goddess", "abilities/artifact/art_bow_of_the_vengeful_goddess.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_bow_of_the_vengeful_goddess_buff", "abilities/artifact/art_bow_of_the_vengeful_goddess.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_bow_of_the_vengeful_goddess == nil then
	art_bow_of_the_vengeful_goddess = class({}, nil, artifact_base)
end
function art_bow_of_the_vengeful_goddess:GetPhysicalAttackBonusPercentage(hParent)
	if hParent:IsRangedAttacker() then
		return self:GetSpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function art_bow_of_the_vengeful_goddess:GetMagicalAttackBonusPercentage(hParent)
	if hParent:IsRangedAttacker() then
		return self:GetSpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function art_bow_of_the_vengeful_goddess:GetAttackRangeOverride(hParent)
	if hParent:IsRangedAttacker() then
		return self:GetSpecialValueFor("attack_range")
	end
end
-- function art_bow_of_the_vengeful_goddess:GetIntrinsicModifierName()
-- 	return "modifier_art_bow_of_the_vengeful_goddess"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_bow_of_the_vengeful_goddess == nil then
	modifier_art_bow_of_the_vengeful_goddess = class({}, nil, eom_modifier)
end
function modifier_art_bow_of_the_vengeful_goddess:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_bow_of_the_vengeful_goddess:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_bow_of_the_vengeful_goddess:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_bow_of_the_vengeful_goddess:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_bow_of_the_vengeful_goddess_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_bow_of_the_vengeful_goddess_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_bow_of_the_vengeful_goddess:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_bow_of_the_vengeful_goddess:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_bow_of_the_vengeful_goddess:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_bow_of_the_vengeful_goddess_buff", nil)
	end
end

------------------------------------------------------------------------------
if modifier_art_bow_of_the_vengeful_goddess_buff == nil then
	modifier_art_bow_of_the_vengeful_goddess_buff = class({}, nil, eom_modifier)
end
function modifier_art_bow_of_the_vengeful_goddess_buff:OnCreated(params)
	self.attack_range = 0
	self.outgoing_damage_bonus_pct = 0
	if self:GetParent():IsRangedAttacker() then
		self.attack_range = math.max(0, self:GetAbilitySpecialValueFor("attack_range") - self:GetParent():Script_GetAttackRange())
		self.outgoing_damage_bonus_pct = self:GetAbilitySpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function modifier_art_bow_of_the_vengeful_goddess_buff:OnRefresh(params)
	self.attack_range = 0
	self.outgoing_damage_bonus_pct = 0
	if self:GetParent():IsRangedAttacker() then
		self.attack_range = math.max(0, self:GetAbilitySpecialValueFor("attack_range") - self:GetParent():Script_GetAttackRange())
		self.outgoing_damage_bonus_pct = self:GetAbilitySpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function modifier_art_bow_of_the_vengeful_goddess_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_bow_of_the_vengeful_goddess_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_art_bow_of_the_vengeful_goddess_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS
	}
end
function modifier_art_bow_of_the_vengeful_goddess_buff:GetMagicalAttackBonusPercentage()
	return self.outgoing_damage_bonus_pct
end
function modifier_art_bow_of_the_vengeful_goddess_buff:GetPhysicalAttackBonusPercentage()
	return self.outgoing_damage_bonus_pct
end
function modifier_art_bow_of_the_vengeful_goddess_buff:GetModifierAttackRangeBonus()
	return self.attack_range
end