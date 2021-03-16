LinkLuaModifier("modifier_courier_first_aid", "abilities/courier/sr/courier_first_aid.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_first_aid == nil then
	courier_first_aid = class({})
end
function courier_first_aid:GetIntrinsicModifierName()
	return "modifier_courier_first_aid"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_first_aid == nil then
	modifier_courier_first_aid = class({})
end
function modifier_courier_first_aid:IsHidden()
	return true
end
function modifier_courier_first_aid:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_courier_first_aid:OnRefresh(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.heal_pct = self:GetAbilitySpecialValueFor('heal_pct')
	if IsServer() then
		self:StartIntervalThink(self.interval)
	end
end
function modifier_courier_first_aid:OnIntervalThink()
	if GSManager:getStateType() == GS_Battle then
		local tTargets = {}
		EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
			if hUnit:IsAlive() then
				table.insert(tTargets, hUnit)
			end
		end, UnitType.Building + UnitType.Commander)
		table.sort(tTargets, function(a, b)
			return a:GetHealthPercent() < b:GetHealthPercent()
		end)
		if IsValid(tTargets[1]) then
			tTargets[1]:Heal(tTargets[1]:GetMaxHealth() * self.heal_pct * 0.01, self:GetAbility())
			tTargets[1]:Purge(false, true, false, true, true)
			local iParticleID = ParticleManager:CreateParticle("particles/generic_gameplay/generic_purge.vpcf", PATTACH_ABSORIGIN_FOLLOW, tTargets[1])
			ParticleManager:ReleaseParticleIndex(iParticleID)
		end
	end
end