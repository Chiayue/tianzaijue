LinkLuaModifier("modifier_naturecaller_3", "abilities/tower/naturecaller/naturecaller_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if naturecaller_3 == nil then
	naturecaller_3 = class({})
end
function naturecaller_3:GetIntrinsicModifierName()
	return "modifier_naturecaller_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_naturecaller_3 == nil then
	modifier_naturecaller_3 = class({}, nil, eom_modifier)
end
function modifier_naturecaller_3:OnCreated(params)
	self.blood_suck_pct = self:GetAbilitySpecialValueFor("blood_suck_pct")
	if IsServer() then
		self.type_damage = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_naturecaller_3:OnRefresh(params)
	self.blood_suck_pct = self:GetAbilitySpecialValueFor("blood_suck_pct")
	if IsServer() then
		self.type_damage = self:GetAbility():GetAbilityDamageType()
	end
end
function modifier_naturecaller_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_naturecaller_3:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_naturecaller_3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hCaster = self:GetCaster()
	local tTargets = {}
	EachUnits(self:GetPlayerID(), function(hUnit)
		if hUnit:GetHealthPercent() == 100 then
			return
		end
		table.insert(tTargets, hUnit)
	end, UnitType.AllFirends)
	local hUnit = tTargets[RandomInt(1, #tTargets)]

	if IsValid(hUnit) and BuildSystem:IsBuilding(hUnit) then
		-- 伤害百分比治疗目标
		local tDamageData = tAttackInfo.tDamageInfo[DAMAGE_TYPE_MAGICAL]
		hUnit:Heal(tDamageData.damage * self.blood_suck_pct * 0.01, self)

		--播一个特效，吸血
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_undying/undying_soul_rip_heal.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end

end