LinkLuaModifier("modifier_sp_tower", "abilities/spell/sp_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_sp_tower_debuff", "abilities/spell/sp_tower.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sp_tower == nil then
	sp_tower = class({}, nil, sp_base)
end
function sp_tower:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function sp_tower:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local duration = self:GetSpecialValueFor("duration")
	local hCommander = Commander:GetCommander(hCaster:GetPlayerOwnerID())
	local iTeamNumber = hCaster:GetTeamNumber()

	DotaTD:EachPlayer(function(_, iPlayerID)
		if PlayerData:IsPointInPlayerRange(iPlayerID, vPosition) then
			iTeamNumber = PlayerData:GetHero(iPlayerID):GetTeamNumber()
		end
	end)

	local type = 1
	if hCommander:HasAbility("base_attack_2") then
		type = 2
	elseif hCommander:HasAbility("base_attack_3") then
		type = 3
	elseif hCommander:HasAbility("base_attack_4") then
		type = 4
	end

	-- bFindClearSpace要填为false，不然无法诞生到指定位置
	local hTower = CreateUnitByName("spell_tower", vPosition, false, hCaster, hCaster, iTeamNumber)
	Attributes:Register(hTower)
	hTower:SetVal(ATTRIBUTE_KIND.StatusHealth, 1, ATTRIBUTE_KEY.BASE)
	hTower:AddNewModifier(hCommander, self, "modifier_sp_tower", { duration = duration })
	hTower:SetAcquisitionRange(3000)
	hTower:FireSummonned(hCommander)
	hTower:RemoveAbility("base_attack_1")
	hTower:RemoveAbility("base_attack_2")
	hTower:RemoveAbility("base_attack_3")
	hTower:RemoveAbility("base_attack_4")
	hTower:AddAbility("base_attack_" .. type):SetLevel(1)
	ResolveNPCPositions(vPosition, self:GetSpecialValueFor("radius"))

	local iParticleID = ParticleManager:CreateParticle("particles/radiant_fx/tower_good3_destroy_lvl3_fallback_med.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTower)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	EmitSoundOnLocationWithCaster(vPosition, "Ability.Starfall", hCaster)
	self:GameTimer(0.3, function()
		ScreenShake(vPosition, 20, 12, 0.5, 6000, 0, true)
	end)
end
---------------------------------------------------------------------
--Modifiers
if modifier_sp_tower == nil then
	modifier_sp_tower = class({}, nil, eom_modifier)
end
function modifier_sp_tower:IsHidden()
	return true
end
function modifier_sp_tower:IsDebuff()
	return false
end
function modifier_sp_tower:IsPurgable()
	return false
end
function modifier_sp_tower:IsPurgeException()
	return false
end
function modifier_sp_tower:IsStunDebuff()
	return false
end
function modifier_sp_tower:OnCreated(params)
	self.inherited_percent = self:GetAbilitySpecialValueFor("inherited_percent")
	self.debuff_duration = self:GetAbilitySpecialValueFor("debuff_duration")
	if IsServer() then
		self:SetStackCount(Spawner:GetRound())
	end
end
function modifier_sp_tower:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		hParent:ForceKill(false)
		hParent:AddNoDraw()

		local iParticleID = ParticleManager:CreateParticle("particles/radiant_fx/tower_good3_destroy_lvl3.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_sp_tower:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
		[MODIFIER_STATE_ROOTED] = true,
	}
end
function modifier_sp_tower:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_LIFETIME_FRACTION,
	}
end
function modifier_sp_tower:GetUnitLifetimeFraction()
	return self:GetRemainingTime() / self:GetDuration()
end
function modifier_sp_tower:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		EMDF_STATUS_HEALTH_BONUS,
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_sp_tower:GetMagicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_tower:GetPhysicalAttackBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_tower:GetStatusHealthBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.inherited_percent * 0.01 - 1
	end
	return 0
end
function modifier_sp_tower:GetMagicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalArmor) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_tower:GetPhysicalArmorBonus()
	if IsValid(self:GetCaster()) then
		return self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self.inherited_percent * 0.01
	end
	return 0
end
function modifier_sp_tower:OnBattleEnd()
	self:Destroy()
end
function modifier_sp_tower:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	hTarget:AddNewModifier(hParent, hAbility, "modifier_sp_tower_debuff", { duration = GetStatusDebuffDuration(self.debuff_duration, hTarget, hParent) })
end
---------------------------------------------------------------------
if modifier_sp_tower_debuff == nil then
	modifier_sp_tower_debuff = class({}, nil, eom_modifier)
end
function modifier_sp_tower_debuff:IsHidden()
	return false
end
function modifier_sp_tower_debuff:IsDebuff()
	return true
end
function modifier_sp_tower_debuff:IsPurgable()
	return true
end
function modifier_sp_tower_debuff:IsPurgeException()
	return true
end
function modifier_sp_tower_debuff:IsStunDebuff()
	return false
end
function modifier_sp_tower_debuff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_sp_tower_debuff:OnCreated(params)
	self.armor_reduction = self:GetAbilitySpecialValueFor("armor_reduction")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		if self:GetStackCount() < self.max_stack_count then
			self:IncrementStackCount()
		end
	end
end
function modifier_sp_tower_debuff:OnRefresh(params)
	self.armor_reduction = self:GetAbilitySpecialValueFor("armor_reduction")
	self.max_stack_count = self:GetAbilitySpecialValueFor("max_stack_count")
	if IsServer() then
		if self:GetStackCount() < self.max_stack_count then
			self:IncrementStackCount()
		end
	end
end
function modifier_sp_tower_debuff:GetMagicalArmorBonus()
	return -self.armor_reduction * self:GetStackCount()
end
function modifier_sp_tower_debuff:GetPhysicalArmorBonus()
	return -self.armor_reduction * self:GetStackCount()
end
function modifier_sp_tower_debuff:OnTooltip()
	return self.armor_reduction * self:GetStackCount()
end