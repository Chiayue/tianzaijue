LinkLuaModifier("modifier_art_fairy_magic_bean", "abilities/artifact/art_fairy_magic_bean.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_fairy_magic_bean == nil then
	art_fairy_magic_bean = class({}, nil, artifact_base)
end
function art_fairy_magic_bean:GetIntrinsicModifierName()
	return "modifier_art_fairy_magic_bean"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_fairy_magic_bean == nil then
	modifier_art_fairy_magic_bean = class({}, nil, eom_modifier)
end
function modifier_art_fairy_magic_bean:OnCreated(params)
	self.star_bonus = self:GetAbilitySpecialValueFor("star_bonus")
	if IsServer() then
		self.tBuiling = {}
	end
end
function modifier_art_fairy_magic_bean:OnRefresh(params)
	self.star_bonus = self:GetAbilitySpecialValueFor("star_bonus")
end
function modifier_art_fairy_magic_bean:OnDestroy()
	if IsServer() then
		if self.tBuiling[1] then
			self.tBuiling[1]:ModifyLevelBonus(nil, self)
			self.tBuiling[1] = nil
		end
	end
end
function modifier_art_fairy_magic_bean:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_IN_BATTLE,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_art_fairy_magic_bean:OnInBattle()
	if IsValid(self:GetAbility())
	and self:GetAbility():GetLevel() > 0
	then
		local hCaster = self:GetCaster()
		local iPlayerID = self:GetPlayerID()
		---@type Building
		local hMinLevelBuilding
		local iMinLevel
		---@param hBuilding Building
		BuildSystem:EachBuilding(iPlayerID, function(hBuilding)
			local iLevel = hBuilding:GetStar()
			if nil == iMinLevel or iLevel < iMinLevel then
				iMinLevel = iLevel
				hMinLevelBuilding = hBuilding
			end
		end)
		if hMinLevelBuilding ~= nil then
			hMinLevelBuilding:ModifyLevelBonus(self.star_bonus, self)
			self.tBuiling[1] = hMinLevelBuilding
		end
	end
end
function modifier_art_fairy_magic_bean:OnBattleEnd()
	if self.tBuiling[1] then
		self.tBuiling[1]:ModifyLevelBonus(nil, self)
		self.tBuiling[1] = nil
	end
end