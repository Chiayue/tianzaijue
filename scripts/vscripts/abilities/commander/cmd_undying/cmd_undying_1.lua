LinkLuaModifier("modifier_cmd_undying_1", "abilities/commander/cmd_undying/cmd_undying_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_undying_1_buff", "abilities/commander/cmd_undying/cmd_undying_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_undying_1 == nil then
	cmd_undying_1 = class({})
end
function cmd_undying_1:GetIntrinsicModifierName()
	return "modifier_cmd_undying_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_undying_1 == nil then
	modifier_cmd_undying_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_undying_1:OnCreated(params)
end
function modifier_cmd_undying_1:OnRefresh(params)
end
function modifier_cmd_undying_1:IsHidden()
	return true
end
function modifier_cmd_undying_1:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath }
	}
end
function modifier_cmd_undying_1:OnDeath(params)
	local hParent = self:GetParent()
	local hVictim = EntIndexToHScript(params.entindex_killed)
	local iPlayerID_Enemy = GetPlayerID(hVictim)
	local iPlayerID = GetPlayerID(hParent)

	if - 1 ~= iPlayerID_Enemy and iPlayerID ~= iPlayerID_Enemy then
		return
	end

	if not hParent:IsFriendly(hVictim) and self:GetAbility():IsCooldownReady() and GSManager:getStateType() == GS_Battle then
		self:GetAbility():UseResources(true, false, true)
		local hUnit = CreateUnitByName("undying_zombie", hVictim:GetAbsOrigin(), false, hParent, hParent, hParent:GetTeamNumber())
		hUnit:FireSummonned(hParent)
		Attributes:Register(hUnit)
		hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_cmd_undying_1_buff", { duration = self:GetAbilitySpecialValueFor("duration") })
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_undying_1_buff == nil then
	modifier_cmd_undying_1_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_undying_1_buff:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	if IsServer() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/commander/cmd_undying/cmd_undying_1_tombstone.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		FindClearSpaceForUnit(self:GetParent(), self:GetParent():GetAbsOrigin() + RandomVector(125), true)
		-- local hCaster = self:GetCaster()
		-- local hParent = self:GetParent()
		-- local PlayerID = hCaster:GetPlayerOwnerID()
		-- if IsValid(hCaster) then
		-- 	local targets = FindUnitsInRadius(hCaster:GetTeamNumber(), hParent:GetAbsOrigin(), nil, 100, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		-- 	if #targets > 0 then
		-- 		for _, hUnit in ipairs(targets) do
		-- 			hCaster:KnockBack(hParent:GetAbsOrigin(), hUnit, 200, 0, 0.2, true)
		-- 			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, 1)
		-- 		end
		-- 	end
		-- end
	end
end
function modifier_cmd_undying_1_buff:OnRefresh(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	if IsServer() then
	end
end
function modifier_cmd_undying_1_buff:OnDestroy()
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():ForceKill(false)
		end
	end
end
function modifier_cmd_undying_1_buff:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_cmd_undying_1_buff:GetStatusHealthBonus()
	return self.health_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
end
function modifier_cmd_undying_1_buff:GetMagicalAttackBonus()
	return self.attack_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01
end
function modifier_cmd_undying_1_buff:GetPhysicalAttackBonus()
	return self.attack_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01
end
function modifier_cmd_undying_1_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_cmd_undying_1_buff:IsHidden()
	return true
end