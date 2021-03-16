LinkLuaModifier("modifier_art_lycoris_radiata", "abilities/artifact/art_lycoris_radiata.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_lycoris_radiata == nil then
	art_lycoris_radiata = class({}, nil, artifact_base)
end
function art_lycoris_radiata:GetIntrinsicModifierName()
	return "modifier_art_lycoris_radiata"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_lycoris_radiata == nil then
	modifier_art_lycoris_radiata = class({}, nil, eom_modifier)
end
function modifier_art_lycoris_radiata:IsHidden()
	return true
end
function modifier_art_lycoris_radiata:OnCreated(params)
	if IsServer() then
		self.tAbility = {}
	end
end
function modifier_art_lycoris_radiata:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_art_lycoris_radiata:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_lycoris_radiata:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_PREPARATION_END,
		EMDF_EVENT_ON_BATTLEING_END,
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_DEATH, self.OnTowerDeath }
	}
end
function modifier_art_lycoris_radiata:OnPreparationEnd()
	local iPlayerID = GetPlayerID(self:GetParent())
	local tTargets = {}
	local tAbility = {}
	EachUnits(iPlayerID, function(hUnit)
		if IsValid(hUnit) and hUnit:IsAlive() then
			table.insert(tTargets, hUnit)
		end
	end, UnitType.Building)
	for i = 1, #tTargets do
		local hUnit = tTargets[i]
		for j = 1, 2 do
			local hAbility = hUnit:GetAbilityByIndex(j)
			if IsValid(hAbility) and hAbility:GetLevel() == 0 then
				table.insert(tAbility, hAbility)
			end
		end
	end
	local hAbility = RandomValue(tAbility)
	if IsValid(hAbility) then
		hAbility:SetLevel(hAbility:GetCaster():GetLevel())
		table.insert(self.tAbility, hAbility)
		local iParticleID = ParticleManager:CreateParticle("particles/artifact/art_lycoris_radiata/art_lycoris_radiata.vpcf", PATTACH_ABSORIGIN_FOLLOW, hAbility:GetCaster())
		ParticleManager:ReleaseParticleIndex(iParticleID)
	end
end
function modifier_art_lycoris_radiata:OnBattleEnd()
	for _, hAbility in pairs(self.tAbility) do
		if IsValid(hAbility) then
			hAbility:SetLevel(0)
		end
	end
	self.tAbility = {}
end
function modifier_art_lycoris_radiata:OnTowerDeath(tEvent)
	if IsServer() then
		local hBuilding = tEvent.hBuilding
		local hUnit = hBuilding:GetUnitEntity()
		self:OnPreparationEnd()
	end
end