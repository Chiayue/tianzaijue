LinkLuaModifier("modifier_enemy_slaughter", "abilities/special_abilities/enemy_slaughter.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_slaughter == nil then
	enemy_slaughter = class({})
end
function enemy_slaughter:GetIntrinsicModifierName()
	return "modifier_enemy_slaughter"
end
function enemy_slaughter:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, self:GetAbilityTargetTeam(), self:GetAbilityTargetType(), self:GetAbilityTargetFlags(), FIND_FARTHEST, false)
	for _, hTarget in ipairs(tTargets) do
		if IsValid(hTarget) and hTarget:IsRangedAttacker() and not IsCommanderTower(hTarget) then
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_loadout.vpcf", PATTACH_ABSORIGIN, hCaster)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			hCaster:SetAbsOrigin(hTarget:GetAbsOrigin())
			FindClearSpaceForUnit(hCaster, hTarget:GetAbsOrigin(), true)
			if hTarget then
				ExecuteOrder(hCaster, DOTA_UNIT_ORDER_ATTACK_TARGET, hTarget)
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_slaughter == nil then
	modifier_enemy_slaughter = class({}, nil, eom_modifier)
end
function modifier_enemy_slaughter:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_slaughter:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_enemy_slaughter:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_slaughter:OnIntervalThink()
	local hAblt = self:GetAbility()
	local hParent = self:GetParent()
	if IsServer() then
		if hAblt:IsCooldownReady() and hAblt then
			local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 900, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_FARTHEST, false)
			local hTarget = tTargets[RandomInt(1, #tTargets)]
			if IsValid(hTarget) then
				ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_TARGET, hTarget, hAblt)
			end
		end
	end
end
function modifier_enemy_slaughter:DeclareFunctions()
	return {
	}
end