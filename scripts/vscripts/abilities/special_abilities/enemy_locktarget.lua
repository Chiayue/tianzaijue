LinkLuaModifier("modifier_enemy_locktarget", "abilities/special_abilities/enemy_locktarget.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_locktarget_lockbuff", "abilities/special_abilities/enemy_locktarget.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_locktarget == nil then
	enemy_locktarget = class({})
end
function enemy_locktarget:GetIntrinsicModifierName()
	return "modifier_enemy_locktarget"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_locktarget == nil then
	modifier_enemy_locktarget = class({}, nil, eom_modifier)
end
function modifier_enemy_locktarget:OnCreated(params)
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	local hParent = self:GetParent()
	self.bLoadBuff = true
	self.hUnit = {}
	if IsServer() then
		if self.bLoadBuff then
			EachUnits(iPlayerID, function(hUnit)
				table.insert(self.hUnit, hUnit)
				if hUnit:HasModifier('modifier_enemy_locktarget_lockbuff') then
					self.bLoadBuff = false
					return true
				end
			end, UnitType.Building)
			local hhUnit = GetRandomElement(self.hUnit)
			if self.bLoadBuff == true and hhUnit then
				hhUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enemy_locktarget_lockbuff", {})
			end
		end
		self:StartIntervalThink(0.5)
	end
end
function modifier_enemy_locktarget:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_locktarget:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_locktarget:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = 100
	}
end

function modifier_enemy_locktarget:GetMoveSpeedBonusPercentage()
	return 100
end
function modifier_enemy_locktarget:OnIntervalThink()
	local hParent = self:GetParent()
	if hParent:IsAlive() then
		local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), hParent:GetAbsOrigin(), nil, 3000, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_ANY_ORDER, false)
		for _, hTarget in ipairs(targets) do
			if hTarget:HasModifier("modifier_enemy_locktarget_lockbuff") and hTarget then
				hParent:SetForceAttackTarget(hTarget)
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_locktarget_lockbuff == nil then
	modifier_enemy_locktarget_lockbuff = class({}, nil, eom_modifier)
end
function modifier_enemy_locktarget_lockbuff:OnCreated(params)
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID1 = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID1, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID1, false, false, -1, false, false)
	end
end
function modifier_enemy_locktarget_lockbuff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_locktarget_lockbuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_PREPARATION
	}
end
function modifier_enemy_locktarget_lockbuff:OnDestroy()
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	if IsServer() then
		-- if self:GetParent():IsAlive() then return end
		EachUnits(iPlayerID, function(hUnit)
			if not hUnit:HasModifier('modifier_enemy_locktarget_lockbuff') and hUnit then
				hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_enemy_locktarget_lockbuff", {})
				return true
			end
		end, UnitType.Building)
	end
end
function modifier_enemy_locktarget_lockbuff:OnBattleEnd()
	self:Destroy()
end
function modifier_enemy_locktarget_lockbuff:OnPreparation()
	local iPlayerID = self:GetParent():GetPlayerOwnerID()
	EachUnits(iPlayerID, function(hUnit)
		if hUnit:HasModifier('modifier_enemy_locktarget_lockbuff') and hUnit then
			hUnit:RemoveModifierByName("modifier_enemy_locktarget_lockbuff")
		end
	end, UnitType.Building)
end