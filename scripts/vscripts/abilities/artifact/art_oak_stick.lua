LinkLuaModifier("modifier_art_oak_stick", "abilities/artifact/art_oak_stick.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_oak_stick_buff", "abilities/artifact/art_oak_stick.lua", LUA_MODIFIER_MOTION_NONE)
-- 橡木杖
--Abilities
if art_oak_stick == nil then
	art_oak_stick = class({}, nil, artifact_base)
end
function art_oak_stick:GetPhysicalAttackBonusPercentage(hParent)
	return self:GetSpecialValueFor("all_physical_attack_bonus_pct")
end
function art_oak_stick:GetMagicalAttackBonusPercentage(hParent)
	return self:GetSpecialValueFor("all_magic_attack_bonus_pct")
end
-- function art_oak_stick:GetIntrinsicModifierName()
-- 	return "modifier_art_oak_stick"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_oak_stick == nil then
	modifier_art_oak_stick = class({}, nil, eom_modifier)
end
function modifier_art_oak_stick:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_oak_stick:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_oak_stick:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_oak_stick:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_oak_stick_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_oak_stick_buff", nil)
				end
			end)
		end
	end
end
function modifier_art_oak_stick:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_oak_stick:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_oak_stick:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_oak_stick_buff", nil)
	end
end

------------------------------------------------------------------------------
if modifier_art_oak_stick_buff == nil then
	modifier_art_oak_stick_buff = class({}, nil, eom_modifier)
end
function modifier_art_oak_stick_buff:OnCreated(params)
	self.all_physical_attack_bonus_pct = self:GetAbilitySpecialValueFor("all_physical_attack_bonus_pct")
	self.all_magic_attack_bonus_pct = self:GetAbilitySpecialValueFor("all_magic_attack_bonus_pct")
end
function modifier_art_oak_stick_buff:OnRefresh(params)
	self.all_physical_attack_bonus_pct = self:GetAbilitySpecialValueFor("all_physical_attack_bonus_pct")
	self.all_magic_attack_bonus_pct = self:GetAbilitySpecialValueFor("all_magic_attack_bonus_pct")
end
function modifier_art_oak_stick_buff:OnDestroy(params)
end
function modifier_art_oak_stick_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_art_oak_stick_buff:GetPhysicalAttackBonusPercentage()
	return self.all_physical_attack_bonus_pct
end
function modifier_art_oak_stick_buff:GetMagicalAttackBonusPercentage()
	return self.all_magic_attack_bonus_pct
end