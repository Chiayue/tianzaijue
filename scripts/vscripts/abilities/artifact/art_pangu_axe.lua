LinkLuaModifier("modifier_art_pangu_axe", "abilities/artifact/art_pangu_axe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_pangu_axe_buff", "abilities/artifact/art_pangu_axe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_pangu_axe == nil then
	art_pangu_axe = class({}, nil, artifact_base)
end
function art_pangu_axe:GetPhysicalAttackBonusPercentage(hParent)
	if not hParent:IsRangedAttacker() then
		return self:GetSpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function art_pangu_axe:GetMagicalAttackBonusPercentage(hParent)
	if not hParent:IsRangedAttacker() then
		return self:GetSpecialValueFor("outgoing_damage_bonus_pct")
	end
end
-- function art_pangu_axe:GetIncomingPercentage(hParent)
-- 	if not hParent:IsRangedAttacker() then
-- 		return -self:GetSpecialValueFor("damage_reduce_pct")
-- 	end
-- end
function art_pangu_axe:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
function art_pangu_axe:GetIntrinsicModifierName()
	return "modifier_art_pangu_axe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_pangu_axe == nil then
	modifier_art_pangu_axe = class({}, nil, eom_modifier)
end
function modifier_art_pangu_axe:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_pangu_axe:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_pangu_axe:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_pangu_axe:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_pangu_axe_buff') and not hUnit:IsRangedAttacker() then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_pangu_axe_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_pangu_axe:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_pangu_axe:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_pangu_axe:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and not hUnit:IsRangedAttacker() then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_pangu_axe_buff", nil)
	end
end

------------------------------------------------------------------------------
if modifier_art_pangu_axe_buff == nil then
	modifier_art_pangu_axe_buff = class({}, nil, eom_modifier)
end
function modifier_art_pangu_axe_buff:OnCreated(params)
	self.damage_reduce_pct = 0
	self.outgoing_damage_bonus_pct = 0
	if not self:GetParent():IsRangedAttacker() then
		self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
		self.outgoing_damage_bonus_pct = self:GetAbilitySpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function modifier_art_pangu_axe_buff:OnRefresh(params)
	self.damage_reduce_pct = 0
	self.outgoing_damage_bonus_pct = 0
	if not self:GetParent():IsRangedAttacker() then
		self.damage_reduce_pct = self:GetAbilitySpecialValueFor("damage_reduce_pct")
		self.outgoing_damage_bonus_pct = self:GetAbilitySpecialValueFor("outgoing_damage_bonus_pct")
	end
end
function modifier_art_pangu_axe_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_pangu_axe_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
	-- EMDF_INCOMING_PERCENTAGE
	}
end

function modifier_art_pangu_axe_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true
	}
end
-- function modifier_art_pangu_axe_buff:GetMagicalAttackBonusPercentage()
-- 	return self.outgoing_damage_bonus_pct
-- end
-- function modifier_art_pangu_axe_buff:GetPhysicalAttackBonusPercentage()
-- 	return self.outgoing_damage_bonus_pct
-- end
function modifier_art_pangu_axe_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_pangu_axe_buff:OnTooltip()
	return self.outgoing_damage_bonus_pct
end
-- function modifier_art_pangu_axe_buff:GetIncomingPercentage()
-- 	return -self.damage_reduce_pct
-- end