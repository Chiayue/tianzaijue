LinkLuaModifier("modifier_contract_shadow_guardian", "abilities/contract/contract_shadow_guardian.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_shadow_guardian == nil then
	contract_shadow_guardian = class({ iOrderType = FIND_CLOSEST }, nil, ability_base_ai)
end
function contract_shadow_guardian:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vCenter = hTarget:GetAbsOrigin()
	local trap_duration = self:GetSpecialValueFor("trap_duration")
	local count = self:GetSpecialValueFor("count")
	local stats_pct = self:GetSpecialValueFor("stats_pct")
	local iTreeCount = 8
	for i = 1, iTreeCount do
		CreateTempTree(RotatePosition(vCenter, QAngle(0, i * 360 / iTreeCount, 0), vCenter + Vector(0, 150, 0)), trap_duration)
	end
	-- 树人
	hCaster:GameTimer(trap_duration, function()
		if GSManager:getStateType() == GS_Battle and PlayerData:GetPlayerRoundResult(GetPlayerID(hCaster)) == nil then
			for i = 1, count do
				local hUnit = CreateUnitByName("npc_dota_contract_treant", vCenter, true, hCaster, hCaster, hCaster:GetTeamNumber())
				hUnit:FireSummonned(hCaster)
				Attributes:Register(hUnit)
				hUnit:AddNewModifier(hCaster, self, "modifier_contract_shadow_guardian", nil)
				hUnit:SetVal(ATTRIBUTE_KIND.StatusHealth, hCaster:GetVal(ATTRIBUTE_KIND.StatusHealth) * stats_pct * 0.01, ATTRIBUTE_KEY.BASE)
				AttributeSystem[ATTRIBUTE_KIND.StatusHealth]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)

				hUnit:SetVal(ATTRIBUTE_KIND.PhysicalAttack, hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * stats_pct * 0.01, ATTRIBUTE_KEY.BASE)
				AttributeSystem[ATTRIBUTE_KIND.PhysicalAttack]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)

				hUnit:SetVal(ATTRIBUTE_KIND.MagicalAttack, hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * stats_pct * 0.01, ATTRIBUTE_KEY.BASE)
				AttributeSystem[ATTRIBUTE_KIND.MagicalAttack]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)

				hUnit:SetVal(ATTRIBUTE_KIND.PhysicalArmor, hCaster:GetVal(ATTRIBUTE_KIND.PhysicalArmor) * stats_pct * 0.01, ATTRIBUTE_KEY.BASE)
				AttributeSystem[ATTRIBUTE_KIND.PhysicalArmor]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)

				hUnit:SetVal(ATTRIBUTE_KIND.MagicalArmor, hCaster:GetVal(ATTRIBUTE_KIND.MagicalArmor) * stats_pct * 0.01, ATTRIBUTE_KEY.BASE)
				AttributeSystem[ATTRIBUTE_KIND.MagicalArmor]:UpdateClient(hUnit, ATTRIBUTE_KEY.BASE)
			end
		end
	end)
	EmitSoundOnLocationWithCaster(vCenter, "Hero_Furion.Sprout", hCaster)
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_shadow_guardian == nil then
	modifier_contract_shadow_guardian = class({}, nil, eom_modifier)
end
function modifier_contract_shadow_guardian:IsHidden()
	return true
end
function modifier_contract_shadow_guardian:OnCreated(params)
	self.root_duration = self:GetAbilitySpecialValueFor("root_duration")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	if IsServer() then
	end
end
function modifier_contract_shadow_guardian:OnRefresh(params)
	self.root_duration = self:GetAbilitySpecialValueFor("root_duration")
	self.attack_count = self:GetAbilitySpecialValueFor("attack_count")
	if IsServer() then
	end
end
function modifier_contract_shadow_guardian:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_contract_shadow_guardian:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_contract_shadow_guardian:OnBattleEnd()
	if IsServer() then
		self:Destroy()
	end
end
function modifier_contract_shadow_guardian:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hCaster = self:GetCaster()
	local hAbility = self:GetAbility()

	self:IncrementStackCount()
	if self:GetStackCount() >= self.attack_count then
		hTarget:AddBuff(hCaster, BUFF_TYPE.ROOT, self.root_duration)
		self:SetStackCount(0)
	end

end