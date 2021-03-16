LinkLuaModifier( "modifier_art_ginseng_fruit", "abilities/artifact/art_ginseng_fruit.lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_art_ginseng_fruit_buff", "abilities/artifact/art_ginseng_fruit.lua", LUA_MODIFIER_MOTION_NONE )
--Abilities
if art_ginseng_fruit == nil then
	art_ginseng_fruit = class({}, nil, artifact_base)
end
function art_ginseng_fruit:GetIntrinsicModifierName()
	return "modifier_art_ginseng_fruit"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_ginseng_fruit == nil then
	modifier_art_ginseng_fruit = class({}, nil, eom_modifier)
end
function modifier_art_ginseng_fruit:IsHidden()
	return true
end
function modifier_art_ginseng_fruit:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_ginseng_fruit:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_ginseng_fruit:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_ginseng_fruit:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = self:GetPlayerID()
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier('modifier_art_ginseng_fruit_buff') then
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_ginseng_fruit_buff", nil)
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_ginseng_fruit:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
	}
end
function modifier_art_ginseng_fruit:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_ginseng_fruit:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_ginseng_fruit_buff", nil)
	end
end
------------------------------------------------------------------------------
if modifier_art_ginseng_fruit_buff == nil then
	modifier_art_ginseng_fruit_buff = class({}, nil, eom_modifier)
end
function modifier_art_ginseng_fruit_buff:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_art_ginseng_fruit_buff:OnCreated(params)
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	self.armor_per_count = self:GetAbilitySpecialValueFor("armor_per_count")
	self.hp_regen_per_count = self:GetAbilitySpecialValueFor("hp_regen_per_count")
	self.mp_regen_per_count = self:GetAbilitySpecialValueFor("mp_regen_per_count")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self.tData = {}
	else
		self.iParticleID = nil
	end
end
function modifier_art_ginseng_fruit_buff:EDeclareFunctions()
	return {
		EMDF_MAGICAL_ARMOR_BONUS,
		EMDF_PHYSICAL_ARMOR_BONUS,
		EMDF_HEALTH_REGEN_BONUS,
		EMDF_MANA_REGEN_BONUS,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent()}
	}
end
function modifier_art_ginseng_fruit_buff:OnStackCountChanged(iStackCount)
	if IsClient() then
		if self:GetStackCount() > 0 and self.iParticleID == nil then
			self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/treant_protector/ti7_shoulder/treant_ti7_livingarmor.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControlEnt(self.iParticleID, 1, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
		elseif self:GetStackCount() == 0 and self.iParticleID ~= nil then
			ParticleManager:DestroyParticle(self.iParticleID, false)
			self.iParticleID = nil
		end
	end
end
function modifier_art_ginseng_fruit_buff:OnIntervalThink()
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i] <= flTime then
			self:DecrementStackCount()
			table.remove(self.tData, i)
		end
	end
	if #self.tData == 0 then
		self:StartIntervalThink(-1)
	end
end
function modifier_art_ginseng_fruit_buff:OnTakeDamage(params)
	if self:GetStackCount() < self.max_count then
		self:IncrementStackCount()
	else
		table.remove(self.tData, 1)
	end
	table.insert(self.tData, GameRules:GetGameTime() + self.duration)
	if #self.tData == 1 then
		self:StartIntervalThink(0)
	end
end
function modifier_art_ginseng_fruit_buff:GetMagicalArmorBonus()
	return self:GetStackCount() * self.armor_per_count
end
function modifier_art_ginseng_fruit_buff:GetPhysicalArmorBonus()
	return self:GetStackCount() * self.armor_per_count
end
function modifier_art_ginseng_fruit_buff:GetHealthRegenBonus()
	return self:GetStackCount() * self.hp_regen_per_count * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
end
function modifier_art_ginseng_fruit_buff:GetManaRegenBonus()
	return self:GetStackCount() * self.mp_regen_per_count * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusMana) * 0.01
end