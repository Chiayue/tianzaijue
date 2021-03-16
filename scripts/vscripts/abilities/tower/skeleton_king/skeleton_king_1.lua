LinkLuaModifier("modifier_skeleton_king_1", "abilities/tower/skeleton_king/skeleton_king_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_king_1_summon", "abilities/tower/skeleton_king/skeleton_king_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if skeleton_king_1 == nil then
	skeleton_king_1 = class({})
end
function skeleton_king_1:GetIntrinsicModifierName()
	return "modifier_skeleton_king_1"
end
function skeleton_king_1:Trigger()
	local hCaster = self:GetCaster()
	local hHero = PlayerData:GetHero(hCaster:GetPlayerOwnerID())
	local duration = self:GetSpecialValueFor("duration")
	local count = self:GetSpecialValueFor("count")

	for i = 1, count do
		local hSummon = CreateUnitByName("npc_dota_skeleton_king_skeleton_warrior", hCaster:GetAbsOrigin()+RandomVector(RandomFloat(100, 200)), true, hHero, hHero, hCaster:GetTeamNumber())
		Attributes:Register(hSummon)
		hSummon:SetVal(ATTRIBUTE_KIND.StatusHealth, 1, ATTRIBUTE_KEY.BASE)
		hSummon:AddNewModifier(hCaster, self, "modifier_skeleton_king_1_summon", {duration=duration})
		hSummon:AddNewModifier(hCaster, self, "modifier_building_ai", nil)
		hSummon:SetMana(0)
		hSummon:SetForwardVector(hCaster:GetForwardVector())
		hSummon:SetAcquisitionRange(3000)
		hSummon:FireSummonned(hCaster)
		local hAbility = hSummon:FindAbilityByName("skeleton_king_1")
		if IsValid(hAbility) then
			hAbility:SetLevel(self:GetLevel())
		end

		local hModifier = hCaster:FindModifierByName("modifier_skeleton_king_3_buff")
		if IsValid(hModifier) and IsValid(hModifier:GetAbility()) then
			hSummon:AddNewModifier(hCaster, hModifier:GetAbility(), "modifier_skeleton_king_3_buff", {duration=hModifier:GetRemainingTime()})
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_skeleton_king_1 == nil then
	modifier_skeleton_king_1 = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_1:IsHidden()
	return true
end
function modifier_skeleton_king_1:IsDebuff()
	return false
end
function modifier_skeleton_king_1:IsPurgable()
	return false
end
function modifier_skeleton_king_1:IsPurgeException()
	return false
end
function modifier_skeleton_king_1:IsStunDebuff()
	return false
end
function modifier_skeleton_king_1:AllowIllusionDuplicate()
	return false
end
function modifier_skeleton_king_1:OnCreated(params)
	self.crit_damage = self:GetAbilitySpecialValueFor("crit_damage")
	if IsServer() then
		self.bCrit = false
	end
end
function modifier_skeleton_king_1:OnRefresh(params)
	self.crit_damage = self:GetAbilitySpecialValueFor("crit_damage")
	if IsServer() then
	end
end
function modifier_skeleton_king_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_skeleton_king_1:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		[MODIFIER_EVENT_ON_ATTACK] = {self:GetParent()},
	}
end
function modifier_skeleton_king_1:GetAttackCritBonus()
	local hAbility = self:GetAbility()
	if IsValid(hAbility) then
		if hAbility:IsCooldownReady() and hAbility:IsOwnersManaEnough() then
			self.bCrit = true
			return self.crit_damage, 100
		end
	end
	self.bCrit = false
end
function modifier_skeleton_king_1:OnAttack(params)
	local hAbility = self:GetAbility()
	local hParent = self:GetParent()
	if params.attacker == hParent then
		if self.bCrit then
			hAbility:UseResources(true, false, true)
			if hParent:GetUnitName() ~= "npc_dota_skeleton_king_skeleton_warrior" then
				if type(hAbility.Trigger) == "function" then
					hAbility:Trigger()
				end
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_skeleton_king_1_summon == nil then
	modifier_skeleton_king_1_summon = class({}, nil, eom_modifier)
end
function modifier_skeleton_king_1_summon:IsHidden()
	return true
end
function modifier_skeleton_king_1_summon:IsDebuff()
	return false
end
function modifier_skeleton_king_1_summon:IsPurgable()
	return false
end
function modifier_skeleton_king_1_summon:IsPurgeException()
	return false
end
function modifier_skeleton_king_1_summon:IsStunDebuff()
	return false
end
function modifier_skeleton_king_1_summon:OnCreated(params)
	self.inherited_percent = self:GetAbilitySpecialValueFor("inherited_percent")
	self.health_percent = self:GetAbilitySpecialValueFor("health_percent")
end
function modifier_skeleton_king_1_summon:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_skeleton_king_1_summon:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_skeleton_king_1_summon:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_skeleton_king_1_summon:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_skeleton_king_1_summon:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_skeleton_king_1_summon:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.inherited_percent*0.01
	end
	return 0
end
function modifier_skeleton_king_1_summon:GetPhysicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.inherited_percent*0.01
	end
	return 0
end
function modifier_skeleton_king_1_summon:GetStatusHealthBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.health_percent*0.01 - 1
	end
	return 0
end
function modifier_skeleton_king_1_summon:GetMagicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.inherited_percent*0.01
	end
	return 0
end
function modifier_skeleton_king_1_summon:GetPhysicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.inherited_percent*0.01
	end
	return 0
end
function modifier_skeleton_king_1_summon:OnBattleEnd()
	self:Destroy()
end