LinkLuaModifier("modifier_spectre_1", "abilities/tower/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spectre_1_debuff", "abilities/tower/spectre/spectre_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if spectre_1 == nil then
	spectre_1 = class({}, nil, ability_base_ai)
end
function spectre_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function spectre_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local count = self:GetSpecialValueFor("count")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self, FIND_FARTHEST)
	for i = 1, math.min(count, #tTargets) do
		tTargets[i]:AddBuff(hCaster, BUFF_TYPE.AI_DISABLED, self:GetDuration())
		tTargets[i]:AddNewModifier(hCaster, self, "modifier_spectre_1_debuff", { duration = self:GetDuration() })
	end
	-- 如果有单位少于锁链数量会链接相同单位
	if #tTargets < count then
		for i = 1, count - #tTargets do
			local hUnit = RandomValue(tTargets)
			if hUnit then
				hUnit:AddBuff(hCaster, BUFF_TYPE.AI_DISABLED, self:GetDuration())
				hUnit:AddNewModifier(hCaster, self, "modifier_spectre_1_debuff", { duration = self:GetDuration() })
			end
		end
	end
	hCaster:EmitSound("Hero_Grimstroke.SoulChain.Partner")
	hCaster:EmitSound("Hero_Pudge.Dismember.Arcana")
end
function spectre_1:GetIntrinsicModifierName()
	return "modifier_spectre_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_spectre_1 == nil then
	modifier_spectre_1 = class({}, nil, eom_modifier)
end
function modifier_spectre_1:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_spectre_1:OnStackCountChanged(iStackCount)
	if IsServer() then
		self:ForceRefresh()
	end
end
function modifier_spectre_1:EDeclareFunctions()
	return {
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_spectre_1:GetStatusHealthBonus()
	return self:GetStackCount()
end
function modifier_spectre_1:OnBattleEnd()
	return self:SetStackCount(0)
end
function modifier_spectre_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_spectre_1:OnTooltip()
	return self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_spectre_1_debuff == nil then
	modifier_spectre_1_debuff = class({}, nil, ModifierHidden)
end
function modifier_spectre_1_debuff:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	if IsServer() then
		self:SetStackCount(1)
		self.speed = CalculateDistance(self:GetCaster(), self:GetParent()) / self:GetDuration() * 0.5
		if IsValid(self:GetParent()) and not self:GetParent():IsBoss() and not self:GetParent():IsElite() then
			ExecuteOrder(self:GetParent(), DOTA_UNIT_ORDER_MOVE_TO_POSITION, nil, nil, self:GetCaster():GetAbsOrigin())
		end
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/spectre/spectre_1.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 3, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_spectre_1_debuff:OnRefresh(params)
	if IsServer() then
		self:IncrementStackCount()
	end
end
function modifier_spectre_1_debuff:OnDestroy()
	if IsServer() then
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		if IsValid(hCaster) then
			for i = 1, self:GetStackCount() do
				hCaster:DealDamage(hParent, self:GetAbility())
			end
			hCaster:SetModifierStackCount("modifier_spectre_1", hCaster, hCaster:GetModifierStackCount("modifier_spectre_1", hCaster) + math.floor(hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.health_pct * 0.01))
			if hCaster:HasModifier("modifier_spectre_2") and hParent:IsAlive() then
				hCaster:FindAbilityByName("spectre_2"):OnSpellStart(hParent, self:GetStackCount())
			end
		end
	end
end
function modifier_spectre_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
		MODIFIER_PROPERTY_MOVESPEED_ABSOLUTE,
	}
end
function modifier_spectre_1_debuff:GetModifierIgnoreMovespeedLimit()
	if not self:GetParent():IsBoss() and not self:GetParent():IsElite() then
		return 1
	end
end
function modifier_spectre_1_debuff:GetModifierMoveSpeed_Absolute()
	if not self:GetParent():IsBoss() and not self:GetParent():IsElite() then
		return self.speed
	end
end
function modifier_spectre_1_debuff:CheckState()
	return {
		[MODIFIER_STATE_SILENCED] = not self:GetParent():IsBoss() and not self:GetParent():IsElite(),
		[MODIFIER_STATE_MUTED] = not self:GetParent():IsBoss() and not self:GetParent():IsElite(),
		[MODIFIER_STATE_DISARMED] = not self:GetParent():IsBoss() and not self:GetParent():IsElite(),
	}
end