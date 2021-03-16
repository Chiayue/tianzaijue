LinkLuaModifier("modifier_courier_crystal", "abilities/courier/r/courier_crystal.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_crystal == nil then
	courier_crystal = class({})
end
function courier_crystal:GetIntrinsicModifierName()
	return "modifier_courier_crystal"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_crystal == nil then
	modifier_courier_crystal = class({}, nil, eom_modifier)
end
function modifier_courier_crystal:IsHidden()
	return true
end
function modifier_courier_crystal:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.min_crystal = self:GetAbilitySpecialValueFor("min_crystal")
	self.max_crystal = self:GetAbilitySpecialValueFor("max_crystal")
	if IsServer() then
	end
end
function modifier_courier_crystal:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.min_crystal = self:GetAbilitySpecialValueFor("min_crystal")
	self.max_crystal = self:GetAbilitySpecialValueFor("max_crystal")
	if IsServer() then
	end
end
function modifier_courier_crystal:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath }
	}
end
function modifier_courier_crystal:OnDeath(tEvent)
	if RollPercentage(self.chance) then
		PlayerData:DropCrystal(tEvent.PlayerID, EntIndexToHScript(tEvent.entindex_killed):GetAbsOrigin(), RandomInt(self.min_crystal, self.max_crystal))
	end
end