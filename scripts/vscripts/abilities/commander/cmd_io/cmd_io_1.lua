LinkLuaModifier("modifier_cmd_io_1", "abilities/commander/cmd_io/cmd_io_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_io_1_buff", "abilities/commander/cmd_io/cmd_io_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_io_2", "abilities/commander/cmd_io/cmd_io_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_io_1 == nil then
	cmd_io_1 = class({})
end
function cmd_io_1:GetIntrinsicModifierName()
	return "modifier_cmd_io_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_io_1 == nil then
	modifier_cmd_io_1 = class({}, nil, eom_modifier)
end
function modifier_cmd_io_1:IsHidden()
	return true
end
function modifier_cmd_io_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE
	}
end
function modifier_cmd_io_1:OnInBattle()
	local hTarget
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		if hTarget == nil then
			hTarget = hUnit
		else
			if CalculateDistance(self:GetParent(), hUnit) < CalculateDistance(self:GetParent(), hTarget) then
				hTarget = hUnit
			end
		end
	end, UnitType.Building)
	if hTarget then
		hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_cmd_io_1_buff", nil)
		local hAbility = self:GetParent():FindAbilityByName("cmd_io_2")
		if hAbility and hAbility:GetLevel() > 0 then
			hTarget:AddNewModifier(self:GetParent(), hAbility, "modifier_cmd_io_2", nil):StartIntervalThink(0.1)
		end
	end
	-- if not Spawner:IsBossRound() then
	-- end
end
---------------------------------------------------------------------
if modifier_cmd_io_1_buff == nil then
	modifier_cmd_io_1_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_io_1_buff:OnCreated(params)
	self.speed_up = self:GetAbilitySpecialValueFor("speed_up")
	self.hp_regen = self:GetAbilitySpecialValueFor("hp_regen")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_wisp/wisp_tether.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_cmd_io_1_buff:OnRefresh(params)
	self.speed_up = self:GetAbilitySpecialValueFor("speed_up")
	self.hp_regen = self:GetAbilitySpecialValueFor("hp_regen")
	self.mana_regen = self:GetAbilitySpecialValueFor("mana_regen")
	if IsServer() then
	end
end
function modifier_cmd_io_1_buff:OnIntervalThink()
	if not IsValid(self:GetCaster()) or not self:GetCaster():IsAlive() then
		self:Destroy()
	end
end
function modifier_cmd_io_1_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_MOVEMENT_SPEED_BONUS] = self.speed_up,
		EMDF_HEALTH_REGEN_BONUS,
		[EMDF_MANA_REGEN_BONUS] = self.mana_regen,
	}
end
function modifier_cmd_io_1_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_cmd_io_1_buff:GetMoveSpeedBonus()
	return self.speed_up
end
function modifier_cmd_io_1_buff:GetHealthRegenBonus()
	return self.hp_regen * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
end
function modifier_cmd_io_1_buff:GetManaRegenBonus()
	return self.mana_regen
end