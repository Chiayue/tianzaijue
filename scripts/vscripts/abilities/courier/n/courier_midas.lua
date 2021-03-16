LinkLuaModifier("modifier_courier_midas", "abilities/courier/n/courier_midas.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_midas == nil then
	courier_midas = class({})
end
function courier_midas:GetIntrinsicModifierName()
	return "modifier_courier_midas"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_midas == nil then
	modifier_courier_midas = class({}, nil, eom_modifier)
end
function modifier_courier_midas:IsHidden()
	return true
end
function modifier_courier_midas:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.min_gold = self:GetAbilitySpecialValueFor("min_gold")
	self.max_gold = self:GetAbilitySpecialValueFor("max_gold")
	if IsServer() then
	end
end
function modifier_courier_midas:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.min_gold = self:GetAbilitySpecialValueFor("min_gold")
	self.max_gold = self:GetAbilitySpecialValueFor("max_gold")
	if IsServer() then
	end
end
function modifier_courier_midas:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath }
	}
end
function modifier_courier_midas:OnDeath(tEvent)
	if RollPercentage(self.chance) then
		PlayerData:DropGold(tEvent.PlayerID, EntIndexToHScript(tEvent.entindex_killed):GetAbsOrigin(), RandomInt(self.min_gold, self.max_gold))
	end
end