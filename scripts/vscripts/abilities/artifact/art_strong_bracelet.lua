LinkLuaModifier("modifier_art_strong_bracelet", "abilities/artifact/art_strong_bracelet.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_strong_bracelet == nil then
	art_strong_bracelet = class({}, nil, artifact_base)
end
function art_strong_bracelet:GetIntrinsicModifierName()
	return "modifier_art_strong_bracelet"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_strong_bracelet == nil then
	modifier_art_strong_bracelet = class({}, nil, eom_modifier)
end
function modifier_art_strong_bracelet:OnCreated(params)
	self.people_num = self:GetAbilitySpecialValueFor('people_num')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_strong_bracelet:OnRefresh(params)
	self.people_num = self:GetAbilitySpecialValueFor('people_num')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_strong_bracelet:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_strong_bracelet:DeclareFunctions()
	return {
	}
end
function modifier_art_strong_bracelet:OnIntervalThink()
	local iPlayerID = GetPlayerID(self:GetParent())
	local iCount = PlayerBuildings:GetPlayerCurBuildCount(iPlayerID, 'hero') or 0
	if 0 ~= iCount and iCount == self.people_num then
		EachUnits(iPlayerID, function(hUnit)
			if IsValid(hUnit) then
				for i = 0, hUnit:GetAbilityCount() - 1 do
					local hAbility = hUnit:GetAbilityByIndex(i)
					if IsValid(hAbility) then
						hAbility:SetLevel(hUnit:GetLevel())
					end
				end
			end
		end, UnitType.Building)
	end
end