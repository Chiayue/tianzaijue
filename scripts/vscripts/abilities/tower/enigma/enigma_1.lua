LinkLuaModifier("modifier_enigma_1_enigma", "abilities/tower/enigma/enigma_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enigma_1_enigma3", "abilities/tower/enigma/enigma_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enigma_1 == nil then
	enigma_1 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, iOrderType = FIND_ANY_ORDER }, nil, ability_base_ai)
end
function enigma_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local duration = self:GetSpecialValueFor("duration")
	local iPlayerID = GetPlayerID(hCaster)
	local hHero = PlayerData:GetHero(iPlayerID)

	local hEnigma = CreateUnitByName("little_enigma", hTarget:GetAbsOrigin(), true, hHero, hHero, hCaster:GetTeamNumber())
	hEnigma:FireSummonned(hCaster)
	hEnigma:SetAcquisitionRange(2000)
	Attributes:Register(hEnigma)
	hEnigma:AddNewModifier(hCaster, self, "modifier_enigma_1_enigma", { duration = duration })

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hEnigma)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Enigma.Demonic_Conversion", hCaster)
end
---------------------------------------------------------------------
--Modifiers
--小谜团第一次召唤
if modifier_enigma_1_enigma == nil then
	modifier_enigma_1_enigma = class({}, nil, eom_modifier)
end
function modifier_enigma_1_enigma:OnCreated(params)
	self.enigma_count = self:GetAbilitySpecialValueFor("enigma_count")
	self.enigma_attack = self:GetAbilitySpecialValueFor("enigma_attack")
	self.enigma_health = self:GetAbilitySpecialValueFor("enigma_health")
	self.enigma_armor = self:GetAbilitySpecialValueFor("enigma_armor")
	self.division_attackcount = self:GetAbilitySpecialValueFor("division_attackcount")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_enigma_1_enigma:OnRefresh(params)
	self.enigma_count = self:GetAbilitySpecialValueFor("enigma_count")
	self.enigma_attack = self:GetAbilitySpecialValueFor("enigma_attack")
	self.enigma_health = self:GetAbilitySpecialValueFor("enigma_health")
	self.enigma_armor = self:GetAbilitySpecialValueFor("enigma_armor")
	self.division_attackcount = self:GetAbilitySpecialValueFor("division_attackcount")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_enigma_1_enigma:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_enigma_1_enigma:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS,
		[EMDF_STATUS_HEALTH_BONUS] = self.enigma_health,
		[EMDF_MAGICAL_ARMOR_BONUS] = self.enigma_armor,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.enigma_armor,
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END,
	-- [MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() },
	}
end

function modifier_enigma_1_enigma:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local iPlayerID = GetPlayerID(hCaster)
	local hHero = PlayerData:GetHero(iPlayerID)

	if not IsValid(hCaster) then return end

	--三次攻击开始分裂，仅能分裂一次
	self:IncrementStackCount()
	if self:GetStackCount() >= self.division_attackcount then
		for i = 1, 3 do
			local hEnigma = CreateUnitByName("little_enigma", hParent:GetAbsOrigin() + RandomVector(200), true, hHero, hHero, hCaster:GetTeamNumber())
			hEnigma:FireSummonned(hCaster)
			Attributes:Register(hEnigma)
			hEnigma:AddNewModifier(hCaster, self:GetAbility(), "modifier_enigma_1_enigma3", { duration = self.duration })

			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_enigma/enigma_demonic_conversion.vpcf", PATTACH_ABSORIGIN_FOLLOW, hEnigma)
			ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end

		self:Destroy()
		return
	end

	-- 如果有2技能则可以将敌人束缚
	local hAbility2 = hCaster:FindAbilityByName("enigma_2")
	if IsValid(hAbility2) and hAbility2:GetLevel() > 0 and hAbility2.OnEnigmaHit then
		hAbility2:OnEnigmaHit(hTarget, hParent)
	end
end

function modifier_enigma_1_enigma:OnBattleEnd()
	self:Destroy()
end
function modifier_enigma_1_enigma:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self.enigma_attack * 0.01 * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)
	end
end
function modifier_enigma_1_enigma:GetStatusHealthBonus()
	return self.enigma_health
end
function modifier_enigma_1_enigma:GetMagicalArmorBonus()
	return self.enigma_armor
end
function modifier_enigma_1_enigma:GetPhysicalArmorBonus()
	return self.enigma_armor
end
---------------------------------------------------------------------
--Modifiers
--小谜团分裂
if modifier_enigma_1_enigma3 == nil then
	modifier_enigma_1_enigma3 = class({}, nil, eom_modifier)
end
function modifier_enigma_1_enigma3:OnCreated(params)
	self.enigma_count = self:GetAbilitySpecialValueFor("enigma_count")
	self.enigma_attack = self:GetAbilitySpecialValueFor("enigma_attack")
	self.enigma_health = self:GetAbilitySpecialValueFor("enigma_health")
	self.enigma_armor = self:GetAbilitySpecialValueFor("enigma_armor")
	self.division_attackcount = self:GetAbilitySpecialValueFor("division_attackcount")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_enigma_1_enigma3:OnRefresh(params)
	self.enigma_count = self:GetAbilitySpecialValueFor("enigma_count")
	self.enigma_attack = self:GetAbilitySpecialValueFor("enigma_attack")
	self.enigma_health = self:GetAbilitySpecialValueFor("enigma_health")
	self.enigma_armor = self:GetAbilitySpecialValueFor("enigma_armor")
	self.division_attackcount = self:GetAbilitySpecialValueFor("division_attackcount")
	self.duration = self:GetAbilitySpecialValueFor("duration")
end
function modifier_enigma_1_enigma3:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_enigma_1_enigma3:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ATTACK_BONUS,
		[EMDF_STATUS_HEALTH_BONUS] = self.enigma_health,
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.enigma_armor,
		[EMDF_MAGICAL_ARMOR_BONUS] = self.enigma_armor,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_enigma_1_enigma3:OnBattleEnd()
	self:Destroy()
end
function modifier_enigma_1_enigma3:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self.enigma_attack * 0.01 * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack)
	end
end
function modifier_enigma_1_enigma3:GetStatusHealthBonus()
	return self.enigma_health
end
function modifier_enigma_1_enigma3:GetMagicalArmorBonus()
	return self.enigma_armor
end
function modifier_enigma_1_enigma3:GetPhysicalArmorBonus()
	return self.enigma_armor
end

function modifier_enigma_1_enigma3:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local iPlayerID = GetPlayerID(hParent)

	if not IsValid(hCaster) then return end

	-- 如果有2技能则可以将敌人束缚
	local hAbility2 = hCaster:FindAbilityByName("enigma_2")
	if IsValid(hAbility2) and hAbility2:GetLevel() > 0 and hAbility2.OnEnigmaHit then
		hAbility2:OnEnigmaHit(hTarget, self:GetParent())
	end
end