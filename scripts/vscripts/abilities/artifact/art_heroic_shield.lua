LinkLuaModifier("modifier_art_heroic_shield", "abilities/artifact/art_heroic_shield.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_heroic_shield_buff", "abilities/artifact/art_heroic_shield.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_heroic_shield == nil then
	art_heroic_shield = class({}, nil, artifact_base)
end
function art_heroic_shield:OnEquip()
	if IsServer() then
		self.tBuildingList = {}
	end
end
function art_heroic_shield:GetModifierAvoidDamage(hParent, params)
	if TableFindKey(self.tBuildingList, hParent) ~= nil then
		if params.damage >= hParent:GetHealth() then
			local health_recover_pct = self:GetSpecialValueFor("health_recover_pct")
			local radius = self:GetSpecialValueFor("radius")

			local flHealAmount = hParent:GetMaxHealth() * health_recover_pct * 0.01
			hParent:Heal(flHealAmount, self)

			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			hParent:DealDamage(tTargets, self, flHealAmount, DAMAGE_TYPE_PURE)

			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:SetParticleControl(iParticleID, 1, Vector(radius, radius, radius))
			ParticleManager:ReleaseParticleIndex(iParticleID)

			hParent:EmitSound("Hero_Omniknight.Purification")

			ArrayRemove(self.tBuildingList, hParent)

			return 1
		end
	end
end
function art_heroic_shield:OnInBattle(hParent)
	if TableFindKey(self.tBuildingList, hParent) == nil then
		table.insert(self.tBuildingList, hParent)
	end
end
function art_heroic_shield:OnBattleEnd(hParent)
	self.tBuildingList = {}
end
function art_heroic_shield:OnTowerSpawned(hParent, tEvent)
	if TableFindKey(self.tBuildingList, hParent) == nil then
		table.insert(self.tBuildingList, hParent)
	end
end
-- function art_heroic_shield:GetIntrinsicModifierName()
-- 	return "modifier_art_heroic_shield"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_heroic_shield == nil then
	modifier_art_heroic_shield = class({}, nil, eom_modifier)
end
function modifier_art_heroic_shield:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:AddBuff()
	end
end
function modifier_art_heroic_shield:OnRefresh(params)
	if IsServer() then
		self:AddBuff()
	end
end
function modifier_art_heroic_shield:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_heroic_shield:AddBuff()
	if IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and GSManager:getStateType() == GS_Battle
	then
		local hCaster = self:GetCaster()
		local iPlayerID = self:GetPlayerID()
		EachUnits(iPlayerID, function(hUnit)
			if not hUnit:HasModifier('modifier_art_heroic_shield_buff') then
				self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_heroic_shield_buff", {})
			end
		end, UnitType.Building)
	end
end
function modifier_art_heroic_shield:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_heroic_shield:OnInBattle()
	self:AddBuff()
end
function modifier_art_heroic_shield:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	and GSManager:getStateType() == GS_Battle
	then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_heroic_shield_buff", nil)
	end
end

------------------------------------------------------------------------------
if modifier_art_heroic_shield_buff == nil then
	modifier_art_heroic_shield_buff = class({}, nil, BaseModifier)
end
function modifier_art_heroic_shield_buff:OnCreated(params)
	if IsServer() then
		self.health_recover_pct = self:GetAbilitySpecialValueFor('health_recover_pct')
		self.radius = self:GetAbilitySpecialValueFor('radius')
		self:SetStackCount(1)
	end
end
function modifier_art_heroic_shield_buff:OnRefresh(params)
	if IsServer() then
		self.health_recover_pct = self:GetAbilitySpecialValueFor('health_recover_pct')
		self.radius = self:GetAbilitySpecialValueFor('radius')
		self:SetStackCount(1)
	end
end
function modifier_art_heroic_shield_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_heroic_shield_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_art_heroic_shield_buff:GetModifierAvoidDamage(params)
	if params.damage >= self:GetParent():GetHealth() then
		local hParent = self:GetParent()
		self:SetStackCount(self:GetStackCount() - 1)
		local flHealAmount = hParent:GetMaxHealth() * self.health_recover_pct * 0.01
		hParent:Heal(flHealAmount, self:GetAbility())
		-- 伤害
		local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		hParent:DealDamage(tTargets, self:GetAbility(), flHealAmount, DAMAGE_TYPE_PURE)
		-- 特效
		local iPtclID = ParticleManager:CreateParticle('particles/econ/items/omniknight/hammer_ti6_immortal/omniknight_purification_ti6_immortal.vpcf', PATTACH_CUSTOMORIGIN_FOLLOW, hParent)
		self:AddParticle(iPtclID, false, false, -1, false, false)
		ParticleManager:SetParticleControl(iPtclID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iPtclID, 1, Vector(300, 300, 300))
		ParticleManager:SetParticleControl(iPtclID, 3, hParent:GetAbsOrigin() + Vector(0, 0, 2000))
		ParticleManager:ReleaseParticleIndex(iPtclID)
		-- 音效
		hParent:EmitSound("Hero_Omniknight.Purification")
		if self:GetStackCount() == 0 then
			self:Destroy()
		end
		return 1
	end
end