LinkLuaModifier("modifier_art_coldest_wand", "abilities/artifact/art_coldest_wand.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_coldest_wand_buff", "abilities/artifact/art_coldest_wand.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_coldest_wand == nil then
	art_coldest_wand = class({}, nil, artifact_base)
end
function art_coldest_wand:GetModifierCooldownReduction_Constant()
	return self:GetSpecialValueFor("colddown_reduce")
end
-- function art_coldest_wand:GetIntrinsicModifierName()
-- 	return "modifier_art_coldest_wand"
-- end
---------------------------------------------------------------------
--Modifiers
if modifier_art_coldest_wand == nil then
	modifier_art_coldest_wand = class({}, nil, eom_modifier)
end
function modifier_art_coldest_wand:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		self.tModifiers = {}
		self:OnIntervalThink()
	end
end
function modifier_art_coldest_wand:OnRefresh(params)
	if IsServer() then
		self:OnIntervalThink()
	end
end
function modifier_art_coldest_wand:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_coldest_wand:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_SPAWNED, self.OnTowerSpawned }
	}
end
function modifier_art_coldest_wand:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility())
		and self:GetAbility():GetLevel() > 0 then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(self:GetParent())
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier("modifier_art_coldest_wand_buff") and hUnit:IsRangedAttacker() then
					table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_coldest_wand_buff", nil))
				end
			end, UnitType.Building)
		end
	end
end
function modifier_art_coldest_wand:OnInBattle()
	self:OnIntervalThink()
end
function modifier_art_coldest_wand:OnTowerSpawned(tEvent)
	local iPlayerID = tEvent.PlayerID
	---@type Building
	local hBuilding = tEvent.hBuilding
	local hUnit = hBuilding:GetUnitEntity()

	if iPlayerID == self:GetPlayerID()
	and IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0 then
		table.insert(self.tModifiers, hUnit:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_coldest_wand_buff", nil))
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_coldest_wand_buff == nil then
	modifier_art_coldest_wand_buff = class({}, nil, eom_modifier)
end
function modifier_art_coldest_wand_buff:OnCreated(params)
	self.colddown_reduce = self:GetAbilitySpecialValueFor('colddown_reduce')
	if IsServer() then
	end
end
function modifier_art_coldest_wand_buff:OnRefresh(params)
	self.colddown_reduce = self:GetAbilitySpecialValueFor('colddown_reduce')
	if IsServer() then
	end
end
function modifier_art_coldest_wand_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_coldest_wand_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_COOLDOWN_REDUCTION_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED
	}
end

function modifier_art_coldest_wand_buff:GetModifierCooldownReduction_Constant()
	return self.colddown_reduce
end
function modifier_art_coldest_wand_buff:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
	end
end