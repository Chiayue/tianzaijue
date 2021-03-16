LinkLuaModifier("modifier_art_ominous_boots", "abilities/artifact/art_ominous_boots.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_ominous_boots_buff", "abilities/artifact/art_ominous_boots.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_ominous_boots == nil then
	art_ominous_boots = class({}, nil, artifact_base)
end
function art_ominous_boots:GetIntrinsicModifierName()
	return "modifier_art_ominous_boots"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_ominous_boots == nil then
	modifier_art_ominous_boots = class({}, nil, eom_modifier)
end
function modifier_art_ominous_boots:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_ominous_boots:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_ominous_boots:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_ominous_boots:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_ominous_boots_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_ominous_boots_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_ominous_boots:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_art_ominous_boots:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_ominous_boots:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_ominous_boots_buff", nil)
	end
end

------------------------------------------------------------------------------
if modifier_art_ominous_boots_buff == nil then
	modifier_art_ominous_boots_buff = class({}, nil, eom_modifier)
end
function modifier_art_ominous_boots_buff:OnCreated(params)
	self.movespeed_bonus_pct = self:GetAbilitySpecialValueFor("movespeed_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.move_per = self:GetAbilitySpecialValueFor("move_per")
	if IsServer() then
	end
end
function modifier_art_ominous_boots_buff:OnRefresh(params)
	self.movespeed_bonus_pct = self:GetAbilitySpecialValueFor("movespeed_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	self.move_per = self:GetAbilitySpecialValueFor("move_per")
	if IsServer() then
	end
end
function modifier_art_ominous_boots_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_ominous_boots_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE
	}
end
function modifier_art_ominous_boots_buff:OnInBattle()
	self:StartIntervalThink(AI_TIMER_TICK_TIME)
	self.fDistance = 0
	self.vOrigin = self:GetParent():GetAbsOrigin()
end
function modifier_art_ominous_boots_buff:OnBattleEnd()
	self:SetStackCount(0)
	self:StartIntervalThink(-1)
end
function modifier_art_ominous_boots_buff:GetMoveSpeedBonusPercentage()
	return self.movespeed_bonus_pct
end
function modifier_art_ominous_boots_buff:GetMagicalAttackBonusPercentage()
	return self.attack_bonus_pct * self:GetStackCount()
end
function modifier_art_ominous_boots_buff:GetPhysicalAttackBonusPercentage()
	return self.attack_bonus_pct * self:GetStackCount()
end
function modifier_art_ominous_boots_buff:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		self.fDistance = self.fDistance + CalculateDistance(self.vOrigin, hParent)
		self.vOrigin = hParent:GetAbsOrigin()
		local iStack = math.floor(self.fDistance / self.move_per)
		if iStack ~= self:GetStackCount() then
			self:SetStackCount(math.max(0, iStack))
		end
		if self:GetStackCount() >= 40 then
			self:SetStackCount(40)
		end
	end
end
function modifier_art_ominous_boots_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_ominous_boots_buff:OnTooltip()
	return self.attack_bonus_pct * self:GetStackCount()
end