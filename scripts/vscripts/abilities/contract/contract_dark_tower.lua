LinkLuaModifier("modifier_contract_dark_tower", "abilities/contract/contract_dark_tower.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_dark_tower == nil then
	contract_dark_tower = class({})
end
function contract_dark_tower:GetIntrinsicModifierName()
	return "modifier_contract_dark_tower"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_dark_tower == nil then
	modifier_contract_dark_tower = class({}, nil, eom_modifier)
end
function modifier_contract_dark_tower:IsHidden()
	return true
end
function modifier_contract_dark_tower:OnCreated(params)
	self.hp_pct = self:GetAbilitySpecialValueFor("hp_pct")
	-- if IsServer() then
	-- 	self:StartIntervalThink(1)
	-- 	self.hWearable = SpawnEntityFromTableSynchronous("prop_dynamic", { model = "models/heroes/shadow_fiend/pedestal_sf.vmdl", origin = (GetGroundPosition((self:GetParent():GetAbsOrigin()), self:GetParent())) })
	-- 	-- self.hWearable:SetAbsOrigin(GetGroundPosition((self:GetParent():GetAbsOrigin()), self:GetParent()))
	-- 	-- self.hWearable:FollowEntity(self:GetParent(), false)
	-- 	self.hWearable:SetModelScale(self:GetParent():GetModelScale() * 2)
	-- end
end
function modifier_contract_dark_tower:OnIntervalThink()
	-- self.hWearable:SetAbsOrigin(GetGroundPosition((self:GetParent():GetAbsOrigin()), self:GetParent()) + Vector(0, 0, 50))
	local tTargets = {}
	EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
		if hUnit:IsAlive() then
			table.insert(tTargets, hUnit)
		end
	end, UnitType.Building)
	table.sort(tTargets, function(a, b)
		return a:GetHealth() > b:GetHealth()
	end)
	if IsValid(tTargets[1]) then
		self:GetParent():SetForceAttackTarget(tTargets[1])
	else
		local hCommander = Commander:GetCommander(GetPlayerID(self:GetParent()))
		if hCommander:IsAlive() then
			self:GetParent():SetForceAttackTarget(hCommander)
		end
	end
end
function modifier_contract_dark_tower:OnDestroy()
	if IsServer() then
		-- UTIL_Remove(self.hWearable)
	end
end
function modifier_contract_dark_tower:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_contract_dark_tower:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	tAttackInfo.attacker:DealDamage(hTarget, self:GetAbility(), hTarget:GetHealth() * self.hp_pct * 0.01)
end