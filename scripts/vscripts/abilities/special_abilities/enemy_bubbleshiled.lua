LinkLuaModifier("modifier_enemy_bubbleshiled", "abilities/special_abilities/enemy_bubbleshiled.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_bubbleshiled_buff", "abilities/special_abilities/enemy_bubbleshiled.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_bubbleshiled_debuff", "abilities/special_abilities/enemy_bubbleshiled.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_bubbleshiled == nil then
	enemy_bubbleshiled = class({})
end
function enemy_bubbleshiled:GetIntrinsicModifierName()
	return "modifier_enemy_bubbleshiled"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_bubbleshiled == nil then
	modifier_enemy_bubbleshiled = class({}, nil, eom_modifier)
end
function modifier_enemy_bubbleshiled:OnCreated(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.miss_chance = self:GetAbilitySpecialValueFor("miss_chance")
	self.range = self:GetAbilitySpecialValueFor("range")
	local iPlayerID = self:GetParent():GetPlayerOwnerID()


	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_enemy_bubbleshiled_debuff') and hUnit then
					hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enemy_bubbleshiled_debuff", {})
				end
			end, UnitType.Building)
		end
		self:StartIntervalThink(self:GetAbility():GetCooldown(self:GetAbility():GetLevel() - 1))
	end
end
function modifier_enemy_bubbleshiled:OnRefresh(params)
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.miss_chance = self:GetAbilitySpecialValueFor("miss_chance")
	self.range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	end
end
function modifier_enemy_bubbleshiled:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_bubbleshiled:OnIntervalThink()
	if self:GetParent():PassivesDisabled() then return end
	if self:GetParent():HasModifier("modifier_ghost_enemy") then return end
	if IsValid(self:GetParent()) and IsServer() then
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()

		if hAbility and GSManager:getStateType() == GS_Battle then
			hParent:AddNewModifier(hParent, hAbility, "modifier_enemy_bubbleshiled_buff", {})
		end
	end


end
function modifier_enemy_bubbleshiled:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end

-- function modifier_enemy_bubbleshiled:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
-- 	if nil == hTarget
-- 	or tAttackInfo.attacker == self:GetParent()
-- 	or IsAttackMiss(tAttackInfo)
-- 	or self:GetParent():PassivesDisabled()
-- 	or not self:GetParent():HasModifier("modifier_enemy_bubbleshiled_buff")
-- 	then return end
-- 	local hAttacker = tAttackInfo.attacker
-- 	local hParent = self:GetParent()
-- 	local vSelfPos = hParent:GetAbsOrigin()
-- 	local vAttackerPos = hAttacker:GetAbsOrigin()
-- 	local distance = (vAttackerPos - vSelfPos):Length2D()
-- 	if RollPercentage(self.miss_chance) and distance > self.range then
-- 		if hAttacker:GetUnitName() ~= hParent:GetUnitName() then
-- 			for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
-- 				if iDamageType then
-- 					tDamageInfo.damage = 0
-- 					tDamageInfo.damage_base = 0
-- 				end
-- 			end
-- 		end
-- 	end
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_bubbleshiled_buff == nil then
	modifier_enemy_bubbleshiled_buff = class({}, nil, ParticleModifier)
end
function modifier_enemy_bubbleshiled_buff:OnCreated(params)
	local range = self:GetAbilitySpecialValueFor("range")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_brewmaster/brewmaster_drunkenbrawler_evade.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(range, range, range))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_bubbleshiled_debuff == nil then
	modifier_enemy_bubbleshiled_debuff = class({}, nil, eom_modifier)
end
function modifier_enemy_bubbleshiled_debuff:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.miss_chance = self:GetAbilitySpecialValueFor("miss_chance")
	if IsServer() then
	else

	end
end
function modifier_enemy_bubbleshiled_debuff:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.miss_chance = self:GetAbilitySpecialValueFor("miss_chance")
	if IsServer() then
	else

	end
end
function modifier_enemy_bubbleshiled_debuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_enemy_bubbleshiled_debuff:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_bubbleshiled_debuff:IsHidden()
	return true
end
function modifier_enemy_bubbleshiled_debuff:OnBattleEnd()
	self:Destroy()
end

function modifier_enemy_bubbleshiled_debuff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if nil == hTarget
	or tAttackInfo.attacker ~= self:GetParent()
	or not hTarget:HasModifier("modifier_enemy_bubbleshiled_buff")
	then return end

	local hAttacker = tAttackInfo.attacker
	local hParent = self:GetParent()
	local vSelfPos = hParent:GetAbsOrigin()
	local vAttackerPos = hTarget:GetAbsOrigin()
	local distance = (vAttackerPos - vSelfPos):Length2D()
	if RollPercentage(self.miss_chance) and distance > self.range then
		for iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
			if iDamageType then
				tDamageInfo.damage = 0
				tDamageInfo.damage_base = 0
			end
		end
		SendOverheadEventMessage(nil, OVERHEAD_ALERT_MISS, hTarget, 0, nil)
		-- SendOverheadEventMessage(hTarget, OVERHEAD_ALERT_LAST_HIT_MISS, hTarget, 0, nil)
	end
end