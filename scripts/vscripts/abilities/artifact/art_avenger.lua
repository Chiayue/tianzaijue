LinkLuaModifier("modifier_art_avenger", "abilities/artifact/art_avenger.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_avenger_buff", "abilities/artifact/art_avenger.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_avenger == nil then
	art_avenger = class({}, nil, artifact_base)
end
function art_avenger:GetPhysicalAttackBonusPercentage(hParent)
	local reduce_health_pct = self:GetSpecialValueFor("reduce_health_pct")
	local physical_attack_bonus_pct = self:GetSpecialValueFor("physical_attack_bonus_pct")
	if IsServer() then
		local fHealth = hParent:GetHealth()
		local fMaxHealth = hParent:GetMaxHealth()
		local iStack = math.floor((fMaxHealth - fHealth) * 100 / fMaxHealth / reduce_health_pct)
		return iStack * physical_attack_bonus_pct
	else
		local iStack = math.floor((100 - hParent:GetHealthPercent()) / reduce_health_pct)
		return iStack * physical_attack_bonus_pct
	end
end
function art_avenger:GetMagicalAttackBonusPercentage(hParent)
	local reduce_health_pct = self:GetSpecialValueFor("reduce_health_pct")
	local physical_attack_bonus_pct = self:GetSpecialValueFor("physical_attack_bonus_pct")
	if IsServer() then
		local fHealth = hParent:GetHealth()
		local fMaxHealth = hParent:GetMaxHealth()
		local iStack = math.floor((fMaxHealth - fHealth) * 100 / fMaxHealth / reduce_health_pct)
		return iStack * physical_attack_bonus_pct
	else
		local iStack = math.floor((100 - hParent:GetHealthPercent()) / reduce_health_pct)
		return iStack * physical_attack_bonus_pct
	end
end
-- function art_avenger:GetIntrinsicModifierName()
-- 	return "modifier_art_avenger"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_avenger == nil then
	modifier_art_avenger = class({}, nil, eom_modifier)
end
function modifier_art_avenger:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_avenger:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_avenger:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_avenger:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_avenger_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_avenger_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_avenger:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_avenger:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_avenger:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_avenger_buff", nil)
	end
end



------------------------------------------------------------------------------
if modifier_art_avenger_buff == nil then
	modifier_art_avenger_buff = class({}, nil, eom_modifier)
end
function modifier_art_avenger_buff:OnCreated(params)
	self.reduce_health_pct = self:GetAbilitySpecialValueFor("reduce_health_pct")
	self.physical_attack_bonus_pct = self:GetAbilitySpecialValueFor("physical_attack_bonus_pct")
	if IsServer() then
		self:StartIntervalThink()
	end
end
function modifier_art_avenger_buff:OnRefresh(params)
	self.reduce_health_pct = self:GetAbilitySpecialValueFor("reduce_health_pct")
	self.physical_attack_bonus_pct = self:GetAbilitySpecialValueFor("physical_attack_bonus_pct")
end
function modifier_art_avenger_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_avenger_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_art_avenger_buff:GetPhysicalAttackBonusPercentage()
	return self.physical_attack_bonus_pct * self:GetStackCount()
end
function modifier_art_avenger_buff:GetMagicalAttackBonusPercentage()
	return self.physical_attack_bonus_pct * self:GetStackCount()
end
function modifier_art_avenger_buff:OnTakeDamage(params)
	if params.unit ~= self:GetParent() then
		return
	end

	local hParent = self:GetParent()
	local fHealth = hParent:GetHealth()
	local fMaxHealth = hParent:GetMaxHealth()
	local iStack = math.floor((fMaxHealth - fHealth) * 100 / fMaxHealth / self.reduce_health_pct)
	self:SetStackCount(iStack)
	-- if math.abs(iStack - self:GetStackCount()) > 1 then
	-- end
end
function modifier_art_avenger_buff:OnBattleEnd()
	self:SetStackCount(0)
end
function modifier_art_avenger_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2,
	}
end
function modifier_art_avenger_buff:OnTooltip()
	return self:GetPhysicalAttackBonusPercentage()
end
function modifier_art_avenger_buff:OnTooltip2()
	return self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, self)
end