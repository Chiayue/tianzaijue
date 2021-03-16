LinkLuaModifier("modifier_art_curse_sword", "abilities/artifact/art_curse_sword.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_curse_sword_buff", "abilities/artifact/art_curse_sword.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_curse_sword == nil then
	art_curse_sword = class({}, nil, artifact_base)
end
function art_curse_sword:OnTowerDeath(hParent, tEvent)
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()
	if hParent == hUnit then
		EachUnits(GetPlayerID(hUnit), function(hTarget)
			hTarget:AddNewModifier(hParent, self, "modifier_art_curse_sword_buff", nil)
		end, UnitType.Building)
	end
end
function art_curse_sword:OnBattleEnd(hParent)
	hParent:RemoveModifierByName("modifier_art_curse_sword_buff")
end

-- function art_curse_sword:GetIntrinsicModifierName()
-- 	return "modifier_art_curse_sword"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_curse_sword == nil then
	modifier_art_curse_sword = class({}, nil, eom_modifier)
end
function modifier_art_curse_sword:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster.iArtPanguAxeDeathRecord = 0
		self.tModifiers = {}

		self:OnIntervalThink()
	end
end
function modifier_art_curse_sword:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_curse_sword:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_curse_sword:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier("modifier_art_curse_sword_buff") and hUnit:IsRangedAttacker() then
					table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_curse_sword_buff", nil))
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_curse_sword:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_curse_sword:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_curse_sword:OnBattleEnd()
	self:GetCaster().iArtPanguAxeDeathRecord = 0
	if IsValid(self:GetAbility()) and self:GetAbility().RefreshAttackSpeedBonus then
		self:GetAbility():RefreshAttackSpeedBonus()
	end
end
function modifier_art_curse_sword:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and hUnit:IsRangedAttacker() then
		table.insert(self.tModifiers, hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_curse_sword_buff", nil))
	end
end


------------------------------------------------------------------------------
if modifier_art_curse_sword_buff == nil then
	modifier_art_curse_sword_buff = class({}, nil, eom_modifier)
end
function modifier_art_curse_sword_buff:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_art_curse_sword_buff:OnCreated(params)
	self.attack_speed_bonus_pct = self:GetAbilitySpecialValueFor("attack_speed_bonus_pct")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_art_curse_sword_buff:OnRefresh(params)
	self.attack_speed_bonus_pct = self:GetAbilitySpecialValueFor("attack_speed_bonus_pct")
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_art_curse_sword_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_curse_sword_buff:EDeclareFunctions()
	return {
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE,
	}
end
function modifier_art_curse_sword_buff:GetAttackSpeedPercentage()
	return self.attack_speed_bonus_pct * self:GetStackCount()
end
function modifier_art_curse_sword_buff:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_curse_sword_buff:OnTooltip()
	return self.attack_speed_bonus_pct * self:GetStackCount()
end