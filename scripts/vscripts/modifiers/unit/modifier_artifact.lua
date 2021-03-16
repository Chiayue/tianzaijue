if modifier_artifact == nil then
	modifier_artifact = class({}, nil, eom_modifier)
end

local public = modifier_artifact

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:AddCustomTransmitterData()
	return self.tArtifacts
end
function public:HandleCustomTransmitterData(tData)
	self.tArtifacts = tData
end
function public:OnCreated(params)
	self:SetHasCustomTransmitterData(true)
	if IsServer() then
		self.tArtifacts = {}
		self:StartIntervalThink(0)
	end
end
function public:OnRefresh(params)
end
function public:OnDestroy()
	if IsServer() then
	end
end
function public:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		local hHero = PlayerData:GetHero(GetPlayerID(hParent))
		if not IsValid(hHero) or not hHero:IsAlive() then
			self:Destroy()
			return
		end
		local bSame = true
		local tArtifacts = {}
		for i = 0, hHero:GetAbilityCount() - 1, 1 do
			local hAbility = hHero:GetAbilityByIndex(i)
			if IsValid(hAbility) then
				if type(hAbility.IsArtifact) == "function" and hAbility:IsArtifact() == true then
					local iAbilityEntIndex = hAbility:entindex()
					if TableFindKey(self.tArtifacts, iAbilityEntIndex) == nil then
						bSame = false
					end
					table.insert(tArtifacts, iAbilityEntIndex)
				end
			end
		end
		self.tArtifacts = tArtifacts
		if not bSame then
			self:ForceRefresh()
		end
	end
end
function public:CheckState()
	local tCheckState = {}
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.CheckState) == "function" then
			local v = hAbility:CheckState(self:GetParent())
			for _k, _v in pairs(v) do
				tCheckState[_k] = _v
			end
		end
	end
	return tCheckState
end
function public:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
	}
end
function public:GetModifierAvoidDamage(params)
	local value
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetModifierAvoidDamage) == "function" then
			local v = hAbility:GetModifierAvoidDamage(self:GetParent(), params)
			if type(v) == "number" then
				return value
			end
		end
	end
	return value
end
function public:EDeclareFunctions()
	return {
		EMDF_ATTACK_RANGE_OVERRIDE,
		EMDF_MANA_REGEN_BONUS,
		EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE,
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_INCOMING_PERCENTAGE,
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned },
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_DEATH, self.OnTowerDeath },
	}
end
-- 属性
function public:GetAttackRangeOverride()
	local value = 0
	local bHasValue = false
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetAttackRangeOverride) == "function" then
			local v = hAbility:GetAttackRangeOverride(self:GetParent())
			if type(v) == "number" then
				bHasValue = true
				value = math.max(value, v)
			end
		end
	end
	if bHasValue then
		return value
	end
end
function public:GetManaRegenBonus()
	local value = 0
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetManaRegenBonus) == "function" then
			local v = hAbility:GetManaRegenBonus(self:GetParent())
			if type(v) == "number" then
				value = value + v
			end
		end
	end
	return value
end
function public:GetAttackSpeedPercentage()
	local value = 0
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetAttackSpeedPercentage) == "function" then
			local v = hAbility:GetAttackSpeedPercentage(self:GetParent())
			if type(v) == "number" then
				value = value + v
			end
		end
	end
	return value
end
function public:GetPhysicalAttackBonusPercentage()
	local value = 0
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetPhysicalAttackBonusPercentage) == "function" then
			local v = hAbility:GetPhysicalAttackBonusPercentage(self:GetParent())
			if type(v) == "number" then
				value = value + v
			end
		end
	end
	return value
end
function public:GetMagicalAttackBonusPercentage()
	local value = 0
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetMagicalAttackBonusPercentage) == "function" then
			local v = hAbility:GetMagicalAttackBonusPercentage(self:GetParent())
			if type(v) == "number" then
				value = value + v
			end
		end
	end
	return value
end
function public:GetIncomingPercentage()
	local value = 0
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetIncomingPercentage) == "function" then
			local v = hAbility:GetIncomingPercentage(self:GetParent())
			if type(v) == "number" then
				value = value + v
			end
		end
	end
	return value
end
function public:GetModifierCooldownReduction_Constant()
	local value = 0
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.GetModifierCooldownReduction_Constant) == "function" then
			local v = hAbility:GetModifierCooldownReduction_Constant(self:GetParent())
			if type(v) == "number" then
				value = value + v
			end
		end
	end
	return value
end
-- 事件
function public:OnInBattle()
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.OnInBattle) == "function" then
			hAbility:OnInBattle(self:GetParent())
		end
	end
end
function public:OnBattleEnd()
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.OnBattleEnd) == "function" then
			hAbility:OnBattleEnd(self:GetParent())
		end
	end
end
function public:OnTowerSpawned(tEvent)
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.OnTowerSpawned) == "function" then
			hAbility:OnTowerSpawned(self:GetParent(), tEvent)
		end
	end
end
function public:OnTowerDeath(tEvent)
	for k, iAbilityEntIndex in pairs(self.tArtifacts) do
		local hAbility = EntIndexToHScript(iAbilityEntIndex)
		if IsValid(hAbility) and type(hAbility.OnTowerDeath) == "function" then
			hAbility:OnTowerDeath(self:GetParent(), tEvent)
		end
	end
end