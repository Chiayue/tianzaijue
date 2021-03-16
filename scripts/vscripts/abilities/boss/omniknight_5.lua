LinkLuaModifier( "modifier_omniknight_5", "abilities/boss/omniknight_5.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_omniknight_5_illusion", "abilities/boss/omniknight_5.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if omniknight_5 == nil then
	omniknight_5 = class({})
end
function omniknight_5:GetIntrinsicModifierName()
	return "modifier_omniknight_5"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_5 == nil then
	modifier_omniknight_5 = class({}, nil, eom_modifier)
end
function modifier_omniknight_5:IsHidden()
	return true
end
function modifier_omniknight_5:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.boss_health_pct = self:GetAbilitySpecialValueFor("boss_health_pct")
	if IsServer() then
	end
end
function modifier_omniknight_5:OnDestroy()
	if IsServer() then
	end
end
function modifier_omniknight_5:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {self:GetParent()}
	}
end
function modifier_omniknight_5:OnDeath(params)
	if params.attacker == self:GetParent() and params.attacker:GetHealthPercent() <= self.trigger_pct and not params.unit:IsFriendly(params.attacker) then
		local hUnit = CreateUnitByName("knight_skeleton", params.unit:GetAbsOrigin(), false, self:GetParent(), self:GetParent(), self:GetParent():GetTeamNumber())
		hUnit:SetControllableByPlayer(self:GetParent():GetPlayerOwnerID(), true)
		hUnit:AddNewModifier(params.attacker, self, "modifier_omniknight_5_illusion", nil)
		FindClearSpaceForUnit(hUnit, params.unit:GetAbsOrigin(), true)
		Attributes:Register(hUnit)
		hUnit:SetBaseMaxHealth(params.attacker:GetMaxHealth() * self.boss_health_pct * 0.01)
		hUnit:SetMaxHealth(hUnit:GetBaseMaxHealth())
		hUnit:SetHealth(hUnit:GetBaseMaxHealth())
		-- 添加到玩家怪物列表
		Spawner:AddMissing(nil, hUnit)
	end
end
---------------------------------------------------------------------
if modifier_omniknight_5_illusion == nil then
	modifier_omniknight_5_illusion = class({}, nil, BaseModifier)
end
function modifier_omniknight_5_illusion:IsHidden()
	return true
end
function modifier_omniknight_5_illusion:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lycan/lycan_summon_wolves_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_5_illusion:OnIntervalThink()
	if not self:GetCaster():IsAlive() then
		self:GetParent():ForceKill(false)
	end
end