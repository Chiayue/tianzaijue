LinkLuaModifier("modifier_item_ancient_astrolabe", "abilities/items/item_ancient_astrolabe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ancient_astrolabe_buff", "abilities/items/item_ancient_astrolabe.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_ancient_astrolabe_debuff", "abilities/items/item_ancient_astrolabe.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_ancient_astrolabe == nil then
	item_ancient_astrolabe = class({}, nil, base_ability_attribute)
end
function item_ancient_astrolabe:GetIntrinsicModifierName()
	return "modifier_item_ancient_astrolabe"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_ancient_astrolabe == nil then
	modifier_item_ancient_astrolabe = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_ancient_astrolabe:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.radius = self:GetAbilitySpecialValueFor('radius')
	self.health_damage_pct = self:GetAbilitySpecialValueFor('health_damage_pct')
	self.duration = self:GetAbilitySpecialValueFor('duration')
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	self.min_health_pct = self:GetAbilitySpecialValueFor('min_health_pct')
	self.damage_reduce_max_pct = self:GetAbilitySpecialValueFor('damage_reduce_max_pct')
	if IsServer() then
		if GSManager:getStateType() == GS_Battle then
			self:StartIntervalThink(self.interval)
		end
	end
end
function modifier_item_ancient_astrolabe:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_ancient_astrolabe:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_ancient_astrolabe:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_INCOMING_PERCENTAGE,
	}
end
function modifier_item_ancient_astrolabe:GetIncomingPercentage()
	-- return RemapVal(self:GetParent():GetHealthPercent(), self.min_health_pct, 100, self.damage_reduce_max_pct, 0)
	return RemapVal(self:GetParent():GetHealthPercent(), self.min_health_pct, 100, -self.damage_reduce_max_pct, 0)
end
function modifier_item_ancient_astrolabe:OnInBattle()
	self:StartIntervalThink(self.interval)
end
function modifier_item_ancient_astrolabe:OnBattleEnd()
	self:StartIntervalThink(-1)
end
function modifier_item_ancient_astrolabe:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hParent:IsAlive() then
		local flDamage = hParent:GetVal(ATTRIBUTE_KIND.StatusHealth) * self.health_damage_pct * 0.01
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		for _, hUnit in ipairs(tTargets) do
			hParent:DealDamage(hUnit, hAbility, flDamage)
			hUnit:AddNewModifier(hParent, hAbility, "modifier_item_ancient_astrolabe_debuff", { duration = self.duration })
		end
		hParent:Purge(false, true, false, true, true)
		hParent:DealDamage(hParent, hAbility, flDamage, nil, DOTA_DAMAGE_FLAG_NON_LETHAL)
		hParent:AddNewModifier(hParent, hAbility, "modifier_item_ancient_astrolabe_buff", { duration = self.duration })
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames_hit.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:ReleaseParticleIndex(iParticleID)
		hParent:EmitSound("Hero_Oracle.PurifyingFlames.Damage")
	end
end
---------------------------------------------------------------------
if modifier_item_ancient_astrolabe_buff == nil then
	modifier_item_ancient_astrolabe_buff = class({}, nil, ModifierPositiveBuff)
end
function modifier_item_ancient_astrolabe_buff:OnCreated(params)
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	local hParent = self:GetParent()
	if IsServer() then
		self.tData = {}

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
			hAbility = self:GetAbility(),
		})
		self:IncrementStackCount()

		self.flInterval = 0.2
		self:StartIntervalThink(self.flInterval)
		self.flHealPerSec = self.heal_pct * hParent:GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01 / self:GetDuration()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/oracle/oracle_ti10_immortal/oracle_ti10_immortal_purifyingflames.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_ancient_astrolabe_buff:OnRefresh(params)
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	local hParent = self:GetParent()
	if IsServer() then
		self.flHealPerSec = self.heal_pct * hParent:GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01 / self:GetDuration()

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()
	end
end
function modifier_item_ancient_astrolabe_buff:OnIntervalThink()
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then
		self:Destroy()
		return
	end
	local hParent = self:GetParent()
	hParent:Heal(self.flHealPerSec * self.flInterval * self:GetStackCount(), self:GetAbility())
	local fGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].fDieTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end
---------------------------------------------------------------------
if modifier_item_ancient_astrolabe_debuff == nil then
	modifier_item_ancient_astrolabe_debuff = class({}, nil, ModifierDebuff)
end
function modifier_item_ancient_astrolabe_debuff:OnCreated(params)
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		self.tData = {}

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()

		self.flInterval = 0.2
		self:StartIntervalThink(self.flInterval)
		self.flHealPerSec = self.heal_pct * hCaster:GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01 / self:GetDuration()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/items/item_ancient_astrolabe/item_ancient_astrolabe.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_item_ancient_astrolabe_debuff:OnRefresh(params)
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsServer() then
		self.flHealPerSec = self.heal_pct * hCaster:GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01 / self:GetDuration()

		table.insert(self.tData, {
			fDieTime = self:GetDieTime(),
		})
		self:IncrementStackCount()
	end
end
function modifier_item_ancient_astrolabe_debuff:OnIntervalThink()
	local hCaster = self:GetCaster()
	if not IsValid(hCaster) then
		self:Destroy()
		return
	end
	local hParent = self:GetParent()
	hCaster:DealDamage(hParent, self:GetAbility(), self.flHealPerSec * self.flInterval * self:GetStackCount())
	local fGameTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if fGameTime >= self.tData[i].fDieTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
end