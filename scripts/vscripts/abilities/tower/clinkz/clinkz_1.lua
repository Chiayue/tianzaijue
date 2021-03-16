LinkLuaModifier("modifier_clinkz_1", "abilities/tower/clinkz/clinkz_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if clinkz_1 == nil then
	clinkz_1 = class({}, nil, ability_base_ai)
end
function clinkz_1:GetCastRange(vLocation, hTarget)
	return self:GetCaster():GetHullRadius() + self:GetCaster():Script_GetAttackRange()
end
function clinkz_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local fDuration = self:GetDuration()
	local damage = self:GetSpecialValueFor("damage")

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_death_pact.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 5, hCaster, PATTACH_ABSORIGIN_FOLLOW, nil, hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Clinkz.DeathPact", hTarget)

	local fDamage = damage * hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)*0.01
	ApplyDamage({
		attacker = hCaster,
		victim = hTarget,
		ability = self,
		damage = fDamage,
		damage_type = self:GetAbilityDamageType(),
	})

	hCaster:AddNewModifier(hCaster, self, "modifier_clinkz_1", {duration=fDuration})

	hCaster:EmitSound("Hero_Clinkz.DeathPact.Cast")

	local hAbility = hCaster:FindAbilityByName("clinkz_2")
	if IsValid(hAbility) and hAbility:GetLevel() > 0 then
		hAbility:OnSpellStart()
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_clinkz_1 == nil then
	modifier_clinkz_1 = class({}, nil, eom_modifier)
end
function modifier_clinkz_1:IsHidden()
	return false
end
function modifier_clinkz_1:IsDebuff()
	return false
end
function modifier_clinkz_1:IsPurgable()
	return false
end
function modifier_clinkz_1:IsPurgeException()
	return false
end
function modifier_clinkz_1:IsStunDebuff()
	return false
end
function modifier_clinkz_1:AllowIllusionDuplicate()
	return false
end
function modifier_clinkz_1:OnCreated(params)
	self.bonus_attack_damage = self:GetAbilitySpecialValueFor("bonus_attack_damage")
	self.arrow_count = self:GetAbilitySpecialValueFor("arrow_count")
	self:GetParent().modifier_clinkz_1 = self
	if IsServer() then
		self.tData = {{
			fDieTime = self:GetDieTime()
		}}
		self:IncrementStackCount()

		self:StartIntervalThink(0)
	end
end
function modifier_clinkz_1:OnRefresh(params)
	self.bonus_attack_damage = self:GetAbilitySpecialValueFor("bonus_attack_damage")
	self.arrow_count = self:GetAbilitySpecialValueFor("arrow_count")
	if IsServer() then
		table.insert(self.tData, {
			fDieTime = self:GetDieTime()
		})
		self:IncrementStackCount()
	end
end
function modifier_clinkz_1:OnIntervalThink()
	if IsServer() then
		local fTime = GameRules:GetGameTime()

		for i = #self.tData, 1, -1 do
			if fTime >= self.tData[i].fDieTime then
				table.remove(self.tData, i)
				self:DecrementStackCount()
			end
		end
	end
end
function modifier_clinkz_1:OnDestroy()
	self:GetParent().modifier_clinkz_1 = nil
end
function modifier_clinkz_1:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_clinkz_1:OnTooltip()
	self._tooltip = (self._tooltip or 0) % 2 + 1
	if self._tooltip == 1 then
		return self:GetPhysicalAttackBonus()
	elseif self._tooltip == 2 then
		return self:GetArrowCount()
	end
end
function modifier_clinkz_1:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		[MODIFIER_EVENT_ON_ATTACK] = {self:GetParent()},
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_clinkz_1:GetPhysicalAttackBonus()
	return self.bonus_attack_damage * self:GetStackCount()
end
function modifier_clinkz_1:GetArrowCount()
	return self.arrow_count * self:GetStackCount()
end
function modifier_clinkz_1:OnAttack(params)
	local hParent = self:GetParent()
	if params.attacker ~= hParent or not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if hParent:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK, ATTACK_STATE_SKIPCOUNTING) then
		return
	end

	local iCount = 0
	local iMaxCount = self:GetArrowCount()
	local tTargets = FindUnitsInRadius(hParent:GetTeamNumber(), hParent:GetAbsOrigin(), nil, hParent:GetHullRadius()+hParent:Script_GetAttackRange(), DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
	for _, hUnit in pairs(tTargets) do
		if hUnit ~= params.target then
			local iAttackState = ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_IGNOREINVIS + ATTACK_STATE_NO_CLEAVE + ATTACK_STATE_NO_EXTENDATTACK + ATTACK_STATE_SKIPCOUNTING
			hParent:Attack(hUnit, iAttackState)
			iCount = iCount + 1
			if iCount >= iMaxCount then
				break
			end
		end
	end
end
function modifier_clinkz_1:OnBattleEnd()
	self:Destroy()
end