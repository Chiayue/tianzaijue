LinkLuaModifier("modifier_druid_1", "abilities/tower/druid/druid_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_druid_1_bear", "abilities/tower/druid/druid_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if druid_1 == nil then
	druid_1 = class({})
end
function druid_1:Spawn()
	if IsServer() then
		local hCaster = self:GetCaster()
		hCaster.GetBear = function(hCaster)
			if self.bear == nil or not IsValid(self.bear) or not self.bear:IsAlive() then
				return nil
			else
				return self.bear
			end
		end
		-- 记录熊玲灵力
		self:Save("iStackCount", 0)
	end
end
function druid_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flRadius = self:GetSpecialValueFor("radius")
	-- 记录熊灵
	if self.bear == nil or not IsValid(self.bear) or not self.bear:IsAlive() then
		self.bear = CreateUnitByName("npc_dota_druid_bear", vPosition, false, hCaster, hCaster, hCaster:GetTeamNumber())
		self.bear:FireSummonned(hCaster)
		Attributes:Register(self.bear)
		self.bear:AddNewModifier(hCaster, self, "modifier_druid_1_bear", nil)
		self.bear:AddNewModifier(hCaster, hCaster:FindAbilityByName("druid_2"), "modifier_druid_2_bear", nil)
		self.bear:AddNewModifier(hCaster, nil, "modifier_building_ai", nil)
		-- 初始灵力
		local iStackCount = self:Load("iStackCount")
		if iStackCount > 0 then
			self.bear:FindModifierByName("modifier_druid_4"):SetStackCount(iStackCount)
		end
		-- 三技能
		if hCaster:HasModifier("modifier_druid_3") then
			self.bear:AddAbility("druid_5"):SetLevel(1)
		end
	else
		-- 原地伤害晕眩
		local tTargets = FindUnitsInRadiusWithAbility(hCaster, self.bear:GetAbsOrigin(), flRadius, self)
		for _, hUnit in pairs(tTargets) do
			hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetDuration())
			hCaster:DealDamage(hUnit, self)
		end
		-- 加灵力
		self.bear:FindModifierByName("modifier_druid_4"):Stack()
		-- 记录灵力值
		self:Save("iStackCount", self.bear:FindModifierByName("modifier_druid_4"):GetStackCount())
		-- 主身加灵力
		if hCaster:HasModifier("modifier_druid_2") then
			hCaster:FindModifierByName("modifier_druid_2"):IncrementStackCount()
			-- 记录灵力值
			local tAbilityData = PlayerData:GetAbilityData(hCaster, "druid_2")
			tAbilityData.iStackCount = hCaster:FindModifierByName("modifier_druid_2"):GetStackCount()
		end
		-- 特效
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self.bear:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- 音效
		EmitSoundOnLocationWithCaster(self.bear:GetAbsOrigin(), "LoneDruid_SpiritBear.ReturnStart", hCaster)
	end
	-- 传送到目标点
	FindClearSpaceForUnit(self.bear, vPosition, true)
	-- 目标伤害晕眩
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetDuration())
		hCaster:DealDamage(hUnit, self)
	end
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.bear)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	-- 音效
	self.bear:EmitSound("LoneDruid_SpiritBear.Return")
end
function druid_1:GetIntrinsicModifierName()
	return "modifier_druid_1"
end
---------------------------------------------------------------------
--Modifiers
if modifier_druid_1 == nil then
	modifier_druid_1 = class({}, nil, eom_modifier)
end
function modifier_druid_1:IsHidden()
	return true
end
function modifier_druid_1:OnCreated(params)
	if IsServer() then
		self.flDistance = self:GetAbility():GetCastRange(vec3_invalid, nil)
		self:StartIntervalThink(0.5)
	end
end
function modifier_druid_1:OnIntervalThink()
	local hParent = self:GetParent()
	if self:GetAbility():IsAbilityReady() then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.flDistance, self:GetAbility())
		if IsValid(tTargets[1]) then
			ExecuteOrder(hParent, DOTA_UNIT_ORDER_CAST_POSITION, nil, self:GetAbility(), tTargets[1]:GetAbsOrigin())
		end
	end
end
function modifier_druid_1:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TELEPORTED] = { self:GetParent() }
	}
end
function modifier_druid_1:OnTeleported(params)
	local hParent = self:GetParent()
	local hBear = hParent.GetBear and hParent:GetBear() or nil
	if hBear then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, hBear:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		FindClearSpaceForUnit(hBear, hParent:GetBuilding().vLocation + RandomVector(100), true)
		hBear:SetForwardVector(hParent:GetForwardVector())
		hBear:Stop()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_blink_end.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.bear)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hBear:EmitSound("LoneDruid_SpiritBear.Return")
	end
end
---------------------------------------------------------------------
if modifier_druid_1_bear == nil then
	modifier_druid_1_bear = class({}, nil, eom_modifier)
end
function modifier_druid_1_bear:OnCreated(params)
	self.health_pct = self:GetAbilitySpecialValueFor("health_pct")
	self.attack_pct = self:GetAbilitySpecialValueFor("attack_pct")
	self.health = self.health_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
	self.attack = self.attack_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01
	if IsServer() then
		self.tAbilityData = PlayerData:GetAbilityData(self:GetCaster(), self:GetAbility():GetAbilityName())
		self:StartIntervalThink(1)
	end
end
function modifier_druid_1_bear:OnRefresh(params)
	self:OnCreated(params)
end
function modifier_druid_1_bear:OnDestroy()
	if IsServer() then
		if self:GetAbility() then
			local iStackCount = self:GetAbility():Load("iStackCount")
			if self:GetCaster():HasModifier("modifier_druid_3") then
				self:GetAbility():Save("iStackCount", math.ceil(iStackCount / 2))
			end
		end
	end
end
function modifier_druid_1_bear:OnIntervalThink()
	if not IsValid(self:GetCaster()) then
		self:GetParent():ForceKill(false)
	end
end
function modifier_druid_1_bear:EDeclareFunctions()
	return {
		[EMDF_STATUS_HEALTH_BONUS] = self.health,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.attack,
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_druid_1_bear:GetStatusHealthBonus()
	return self.health
end
function modifier_druid_1_bear:GetMagicalAttackBonus()
	return self.attack
end
function modifier_druid_1_bear:OnInBattle()
	if IsValid(self:GetParent()) then
		self:GetParent():AddNewModifier(self:GetCaster(), nil, "modifier_building_ai", nil)
	end
end
function modifier_druid_1_bear:OnBattleEnd()
	local hParent = self:GetParent()
	hParent:RemoveModifierByName("modifier_building_ai")
	hParent:Heal(hParent:GetMaxHealth(), self:GetAbility())
end