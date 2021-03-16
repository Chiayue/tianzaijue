LinkLuaModifier("modifier_art_taboo_stone", "abilities/artifact/art_taboo_stone.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_taboo_stone_buff", "abilities/artifact/art_taboo_stone.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
-- 献祭之石
if art_taboo_stone == nil then
	art_taboo_stone = class({}, nil, artifact_base)
end
function art_taboo_stone:GetIntrinsicModifierName()
	return "modifier_art_taboo_stone"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_taboo_stone == nil then
	modifier_art_taboo_stone = class({}, nil, eom_modifier)
end
function modifier_art_taboo_stone:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:StartIntervalThink(1)
	end
end
function modifier_art_taboo_stone:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_taboo_stone:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_art_taboo_stone:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(self:GetParent())
			local iMax = PlayerBuildings:GetPlayerMaxBuildCount(iPlayerID, 'hero')
			local iCount = PlayerBuildings:GetPlayerCurBuildCount(iPlayerID, 'hero')
			if iMax > iCount then
				EachUnits(iPlayerID, function(hUnit)
					if iMax > iCount then
						if not hUnit:HasModifier("modifier_art_taboo_stone_buff") then
							table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_art_taboo_stone_buff", nil))
						end
					elseif iMax == iCount then
						if hUnit:HasModifier("modifier_art_taboo_stone_buff") then
							hUnit:RemoveModifierByName('modifier_art_taboo_stone_buff')
						end
					end
				end, UnitType.Building)
			end
		end
	end
end
-- damage_bonus_pct
--------------------------------------------------------------------
--Modifiers
if modifier_art_taboo_stone_buff == nil then
	modifier_art_taboo_stone_buff = class({}, nil, eom_modifier)
end
function modifier_art_taboo_stone_buff:OnCreated(params)
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor('damage_bonus_pct')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_art_taboo_stone_buff:OnRefresh(params)
	self.damage_bonus_pct = self:GetAbilitySpecialValueFor('damage_bonus_pct')
	if IsServer() then

	end
end
function modifier_art_taboo_stone_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_taboo_stone_buff:OnIntervalThink()
	local iPlayerID = GetPlayerID(self:GetParent())
	local iMax = PlayerBuildings:GetPlayerMaxBuildCount(iPlayerID, 'hero') or 0
	local iCount = PlayerBuildings:GetPlayerCurBuildCount(iPlayerID, 'hero') or 0
	self:SetStackCount(iMax - iCount)
end
function modifier_art_taboo_stone_buff:EDeclareFunctions()
	return {
		EMDF_OUTGOING_PERCENTAGE
	}
end
function modifier_art_taboo_stone_buff:GetOutgoingPercentage()
	return	self.damage_bonus_pct * (self:GetStackCount())
end
function modifier_art_taboo_stone_buff:DeclareFunctions()
	return		{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_art_taboo_stone_buff:OnTooltip()
	return self.damage_bonus_pct * (self:GetStackCount())
end