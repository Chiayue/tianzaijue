LinkLuaModifier("modifier_art_blood_sacrifice", "abilities/artifact/art_blood_sacrifice.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_blood_sacrifice_buff", "abilities/artifact/art_blood_sacrifice.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_blood_sacrifice == nil then
	art_blood_sacrifice = class({}, nil, artifact_base)
end
function art_blood_sacrifice:GetIntrinsicModifierName()
	return "modifier_art_blood_sacrifice"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_blood_sacrifice == nil then
	modifier_art_blood_sacrifice = class({}, nil, eom_modifier)
end
function modifier_art_blood_sacrifice:OnCreated(params)
	self.health_reduce = self:GetAbilitySpecialValueFor("health_reduce")
	self.health_limit = self:GetAbilitySpecialValueFor("health_limit")
	self.gold_bonus_ratio = self:GetAbilitySpecialValueFor("gold_bonus_ratio")

end
function modifier_art_blood_sacrifice:OnRefresh(params)
	self.health_reduce = self:GetAbilitySpecialValueFor("health_reduce")
	self.health_limit = self:GetAbilitySpecialValueFor("health_limit")
	if IsServer() then
	end
end
function modifier_art_blood_sacrifice:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	-- MODIFIER_PROPERTY_ATTACKSPEED_BASE_OVERRIDE
	}
end
function modifier_art_blood_sacrifice:OnInBattle()
	local iPlayerID = self:GetPlayerID()
	--获取金币
	local hParent = self:GetParent()
	if self:GetAbility():GetLevel() > 0 and hParent:GetPlayerID() == iPlayerID and hParent:GetHealth() >= self.health_limit then
		local iAdd = hParent:GetMaxHealth() - hParent:GetHealth()
		PlayerData:ModifyGold(iPlayerID, iAdd * self.gold_bonus_ratio)
	end

end
function modifier_art_blood_sacrifice:OnBattleEnd()
	local iPlayerID = self:GetPlayerID()
	--扣除血量
	local hParent = self:GetParent()
	if hParent:GetHealth() >= self.health_limit then
		if 0 < self.health_reduce then
			local tInfo = {
				PlayerID = iPlayerID,
				attacker = self:GetParent(),
				damage = self.health_reduce,
			}
			EventManager:fireEvent(ET_PLAYER.ON_DAMAGE, tInfo)
		end
	end
end