LinkLuaModifier("modifier_omniknight_7", "abilities/boss/omniknight_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_7_summon", "abilities/boss/omniknight_7.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_omniknight_7_illusion", "abilities/boss/omniknight_7.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if omniknight_7 == nil then
	omniknight_7 = class({})
	omniknight_7.tSummonned = {}
end
function omniknight_7:OnAbilityPhaseStart()
	self:GetCaster():AddBuff(self:GetCaster(), BUFF_TYPE.TENACITY, self:GetCastPoint())
	return true
end
function omniknight_7:OnSpellStart()
	self:Summon()
end
function omniknight_7:Summon()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_4)
	local angle = self:GetSpecialValueFor("angle")
	local distance = self:GetSpecialValueFor("distance")
	local summon_count = self:GetSpecialValueFor("summon_count")
	local vDirection = -hCaster:GetForwardVector()
	local tPosition = {
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(angle)) * distance,
		hCaster:GetAbsOrigin() + Rotation2D(vDirection, math.rad(-angle)) * distance,
	}
	for i = 1, summon_count do
		local hUnit = CreateUnitByName(hCaster:GetUnitName(), tPosition[i], false, hCaster, hCaster, hCaster:GetTeamNumber())
		hUnit:RemoveAbility("omniknight_7")
		hUnit:SetForwardVector(-vDirection)
		hUnit:AddNewModifier(hCaster, self, "modifier_omniknight_7_summon", { duration = 3.9 })
		hUnit:AddNewModifier(hCaster, self, "modifier_omniknight_7_illusion", nil)
		hUnit:SetControllableByPlayer(hCaster:GetPlayerOwnerID(), true)
		Attributes:Register(hUnit)
		FindClearSpaceForUnit(hUnit, tPosition[i], true)
		table.insert(self.tSummonned, hUnit)
	end

	self:GetIntrinsicModifier().bTrigger = true
end
function omniknight_7:GetIntrinsicModifierName()
	return "modifier_omniknight_7"
end
---------------------------------------------------------------------
--Modifiers
if modifier_omniknight_7 == nil then
	modifier_omniknight_7 = class({}, nil, BaseModifier)
end
function modifier_omniknight_7:IsHidden()
	return true
end
function modifier_omniknight_7:OnCreated(params)
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	if IsServer() then
		self.bTrigger = false
		self:StartIntervalThink(1)
	end
end
function modifier_omniknight_7:OnIntervalThink()
	local hParent = self:GetParent()
	if self.bTrigger == false and hParent:GetHealthPercent() <= self.trigger_pct and hParent:IsAbilityReady(self:GetAbility()) then
		hParent:Purge(false, true, false, true, true)
		ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_NO_TARGET, nil, self:GetAbility())
	end
end
---------------------------------------------------------------------
if modifier_omniknight_7_summon == nil then
	modifier_omniknight_7_summon = class({}, nil, BaseModifier)
end
function modifier_omniknight_7_summon:IsHidden()
	return true
end
function modifier_omniknight_7_summon:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(3.9)
		-- self:GetParent():StartGestureWithPlaybackRate(ACT_DOTA_CAST_ABILITY_5, 2.2)
		self:GetParent():AddNoDraw()
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/omniknight/omniknight_7.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 0, self:GetParent():GetForwardVector())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_omniknight_7_summon:OnIntervalThink()
	self:GetParent():RemoveNoDraw()
end
function modifier_omniknight_7_summon:CheckState()
	return {
		[MODIFIER_STATE_DISARMED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
	}
end
---------------------------------------------------------------------
if modifier_omniknight_7_illusion == nil then
	modifier_omniknight_7_illusion = class({}, nil, BaseModifier)
end
function modifier_omniknight_7_illusion:IsHidden()
	return true
end
function modifier_omniknight_7_illusion:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_huskar_lifebreak.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		self:AddParticle(iParticleID, false, true, 10, false, false)
	end
end
function modifier_omniknight_7_illusion:OnIntervalThink()
	if not self:GetCaster():IsAlive() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_omniknight_7_illusion:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end