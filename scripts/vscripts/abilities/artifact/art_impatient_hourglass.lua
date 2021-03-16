LinkLuaModifier("modifier_art_impatient_hourglass", "abilities/artifact/art_impatient_hourglass.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_impatient_hourglass_buff", "abilities/artifact/art_impatient_hourglass.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_impatient_hourglass == nil then
	art_impatient_hourglass = class({}, nil, artifact_base)
end
function art_impatient_hourglass:OnInBattle(hParent)
	hParent:GiveMana(self:GetSpecialValueFor("mana_bonus"))
end
function art_impatient_hourglass:GetManaRegenBonus(hParent)
	return self:GetSpecialValueFor("bonus_mana_regen")
end
-- function art_impatient_hourglass:GetIntrinsicModifierName()
-- 	return "modifier_art_impatient_hourglass"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_impatient_hourglass == nil then
	modifier_art_impatient_hourglass = class({}, nil, eom_modifier)
end
function modifier_art_impatient_hourglass:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_impatient_hourglass:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_impatient_hourglass:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_impatient_hourglass:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_impatient_hourglass_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_impatient_hourglass_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_impatient_hourglass:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_impatient_hourglass:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_impatient_hourglass:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_impatient_hourglass_buff", nil)
	end
end

------------------------------------------------------------------------------
if modifier_art_impatient_hourglass_buff == nil then
	modifier_art_impatient_hourglass_buff = class({}, nil, eom_modifier)
end
function modifier_art_impatient_hourglass_buff:OnCreated(params)
	self.mana_bonus = self:GetAbilitySpecialValueFor("mana_bonus")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	-- self.attack_speed_bonus_pct = self:GetAbilitySpecialValueFor("attack_speed_bonus_pct")
	if IsServer() then

	end
end
function modifier_art_impatient_hourglass_buff:OnRefresh(params)
	self.mana_bonus = self:GetAbilitySpecialValueFor("mana_bonus")
	self.bonus_mana_regen = self:GetAbilitySpecialValueFor("bonus_mana_regen")
	-- self.attack_speed_bonus_pct = self:GetAbilitySpecialValueFor("attack_speed_bonus_pct")
	if IsServer() then
	end
end
function modifier_art_impatient_hourglass_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_impatient_hourglass_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_MANA_REGEN_BONUS

	-- MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE
	}
end
function modifier_art_impatient_hourglass_buff:GetManaRegenBonus()
	return self.bonus_mana_regen
end
function modifier_art_impatient_hourglass_buff:OnInBattle()
	if self:GetParent() then
		self:GetParent():GiveMana(self.mana_bonus)
	end

end