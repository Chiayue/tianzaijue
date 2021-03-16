LinkLuaModifier("modifier_clinkz_2", "abilities/tower/clinkz/clinkz_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if clinkz_2 == nil then
	clinkz_2 = class({})
end
function clinkz_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hHero = PlayerData:GetHero(hCaster:GetPlayerOwnerID())
	local fDuration = self:GetDuration()
	local count = self:GetSpecialValueFor("count")

	local hAbility = hCaster:FindAbilityByName("clinkz_3")
	
	for i = 1, count do
		local hSummon = CreateUnitByName("npc_dota_clinkz_skeleton_archer", hCaster:GetAbsOrigin()+RandomVector(RandomFloat(100, 200)), true, hHero, hHero, hCaster:GetTeamNumber())
		Attributes:Register(hSummon)
		hSummon:AddNewModifier(hCaster, self, "modifier_clinkz_2", {duration=fDuration})
		hSummon:AddNewModifier(hCaster, self, "modifier_building_ai", nil)
		hSummon:SetForwardVector(hCaster:GetForwardVector())
		hSummon:SetAcquisitionRange(3000)
		hSummon:FireSummonned(hCaster)

		if IsValid(hAbility) then
			local _hAbility = hSummon:FindAbilityByName(hAbility:GetAbilityName())
			if IsValid(_hAbility) then
				_hAbility:SetLevel(hAbility:GetLevel())
			end
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_clinkz_2 == nil then
	modifier_clinkz_2 = class({}, nil, eom_modifier)
end
function modifier_clinkz_2:IsHidden()
	return true
end
function modifier_clinkz_2:IsDebuff()
	return false
end
function modifier_clinkz_2:IsPurgable()
	return false
end
function modifier_clinkz_2:IsPurgeException()
	return false
end
function modifier_clinkz_2:IsStunDebuff()
	return false
end
function modifier_clinkz_2:AllowIllusionDuplicate()
	return false
end
function modifier_clinkz_2:OnCreated(params)
	self.inherited_percent = self:GetAbilitySpecialValueFor("inherited_percent")
	self.hits_to_kill = self:GetAbilitySpecialValueFor("hits_to_kill")
	if IsServer() then
		self.iHits = self.hits_to_kill
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_burning_army.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_clinkz/clinkz_burning_army_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_clinkz_2:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_clinkz_2:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function modifier_clinkz_2:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_clinkz_2:GetModifierAvoidDamage()
	return 1
end
function modifier_clinkz_2:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_clinkz_2:EDeclareFunctions()
	return {
		EMDF_ATTACK_RANGE_OVERRIDE,
		EMDF_ATTACKT_SPEED_OVERRIDE,
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		[MODIFIER_EVENT_ON_ATTACK] = {self:GetParent()},
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = {nil, self:GetParent()},
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_clinkz_2:GetAttackRangeOverride()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():Script_GetAttackRange()
	end
end
function modifier_clinkz_2:GetAttackSpeedOverride()
	if IsValid(self:GetCaster()) then
		return 100 + (self:GetCaster():GetAttackSpeed() - 1)*100 * self.inherited_percent*0.01
	end
end
function modifier_clinkz_2:GetPhysicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.inherited_percent*0.01
	end
end
function modifier_clinkz_2:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.inherited_percent*0.01
	end
end
function modifier_clinkz_2:GetMagicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.inherited_percent*0.01
	end
end
function modifier_clinkz_2:GetPhysicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.inherited_percent*0.01
	end
end
function modifier_clinkz_2:OnAttack(params)
	if not IsValid(self:GetCaster()) or not IsValid(self:GetCaster().modifier_clinkz_1) then
		return
	end
	local hParent = self:GetParent()
	if params.attacker ~= hParent or not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if hParent:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK, ATTACK_STATE_SKIPCOUNTING) then
		return
	end

	local iCount = 0
	local iMaxCount = self:GetCaster().modifier_clinkz_1:GetArrowCount()
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
function modifier_clinkz_2:OnAttackLanded(params)
	local hParent = self:GetParent()
	if params.target == hParent then
		self.iHits = self.iHits - 1
		if self.iHits <= 0 then
			hParent:Kill(self:GetAbility(), params.attacker)
		else
			hParent:ModifyHealth(hParent:GetMaxHealth()*self.iHits/self.hits_to_kill, self:GetAbility(), false, 0)
		end
	end
end
function modifier_clinkz_2:OnBattleEnd()
	self:Destroy()
end