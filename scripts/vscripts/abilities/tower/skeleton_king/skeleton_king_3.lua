LinkLuaModifier("modifier_skeleton_king_3", "abilities/tower/skeleton_king/skeleton_king_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_3_buff", "abilities/tower/skeleton_king/skeleton_king_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skeleton_king_3 == nil then
	skeleton_king_3 = class({})
end
function skeleton_king_3:GetIntrinsicModifierName()
	return "modifier_skeleton_king_3"
end
function skeleton_king_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")

	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_INVULNERABLE, FIND_CLOSEST, false)
	for _, hTarget in pairs(tTargets) do
		if hTarget == hCaster or (hTarget:IsSummoned() and hTarget:GetSummoner() == hCaster) then
			hTarget:AddNewModifier(hCaster, self, "modifier_skeleton_king_3_buff", {duration=duration})
		end
	end

	hCaster:EmitSound("Hero_SkeletonKing.Reincarnate.Ghost")
end
---------------------------------------------------------------------
--Modifiers
if modifier_skeleton_king_3 == nil then
	modifier_skeleton_king_3 = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_3:IsHidden()
	return true
end
function modifier_skeleton_king_3:IsDebuff()
	return false
end
function modifier_skeleton_king_3:IsPurgable()
	return false
end
function modifier_skeleton_king_3:IsPurgeException()
	return false
end
function modifier_skeleton_king_3:IsStunDebuff()
	return false
end
function modifier_skeleton_king_3:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_king_3:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0)
	end
end
function modifier_skeleton_king_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_skeleton_king_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_skeleton_king_3:OnIntervalThink()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if not IsValid(hCaster) or not IsValid(hAbility) then
			self:Destroy()
			return
		end
		if GSManager:getStateType() ~= GS_Battle then
			self:StartIntervalThink(0)
			return
		end

		if hAbility:IsCooldownReady() and hAbility:IsOwnersManaEnough() then
			hAbility:UseResources(true, false, true)
			hAbility:OnSpellStart()
		end
		self:StartIntervalThink(hAbility:GetCooldownTimeRemaining())
	end
end
---------------------------------------------------------------------
if modifier_skeleton_king_3_buff == nil then
	modifier_skeleton_king_3_buff = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_3_buff:IsHidden()
	return false
end
function modifier_skeleton_king_3_buff:IsDebuff()
	return false
end
function modifier_skeleton_king_3_buff:IsPurgable()
	return true
end
function modifier_skeleton_king_3_buff:IsPurgeException()
	return true
end
function modifier_skeleton_king_3_buff:IsStunDebuff()
	return false
end
function modifier_skeleton_king_3_buff:GetStatusEffectName()
	return "particles/status_fx/status_effect_wraithking_ghosts.vpcf"
end
function modifier_skeleton_king_3_buff:StatusEffectPriority()
	return 100
end
function modifier_skeleton_king_3_buff:OnCreated(params)
	self.bonus_move_speed = self:GetAbilitySpecialValueFor("bonus_move_speed")
	self.bonus_attack_damage_pct = self:GetAbilitySpecialValueFor("bonus_attack_damage_pct")
	self.lifesteal = self:GetAbilitySpecialValueFor("lifesteal")
	if IsServer() then
		self:StartIntervalThink(0)
		self:OnIntervalThink()
	else
		if self:GetParent() == self:GetCaster() then
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_skeletonking/wraith_king_ghosts_ambient.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			self:AddParticle(iParticleID, false, false, -1, false, false)
		end
	end
end
function modifier_skeleton_king_3_buff:OnRefresh(params)
	self.bonus_move_speed = self:GetAbilitySpecialValueFor("bonus_move_speed")
	self.bonus_attack_damage_pct = self:GetAbilitySpecialValueFor("bonus_attack_damage_pct")
	self.lifesteal = self:GetAbilitySpecialValueFor("lifesteal")
end
function modifier_skeleton_king_3_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = self:GetCaster() == self:GetParent(),
	}
end
function modifier_skeleton_king_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
	}
end
function modifier_skeleton_king_3_buff:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 3 + 1
	if self._tooltip == 1 then
		return self:GetMoveSpeedBonusPercentage()
	elseif self._tooltip == 2 then
		return self:GetPhysicalAttackBonusPercentage()
	elseif self._tooltip == 3 then
		return self:GetAttackHealBonusPercentage()
	end
end
function modifier_skeleton_king_3_buff:GetModifierIgnoreMovespeedLimit()
	return 1
end
function modifier_skeleton_king_3_buff:EDeclareFunctions()
	return {
		EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_ATTACK_HELF_BONUS_PERCENTAGE,
	}
end
function modifier_skeleton_king_3_buff:GetMoveSpeedBonusPercentage()
	return self.bonus_move_speed
end
function modifier_skeleton_king_3_buff:GetPhysicalAttackBonusPercentage()
	return self.bonus_attack_damage_pct
end
function modifier_skeleton_king_3_buff:GetAttackHealBonusPercentage()
	return self.lifesteal
end