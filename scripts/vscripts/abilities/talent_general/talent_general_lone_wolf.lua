LinkLuaModifier("modifier_talent_general_lone_wolf_buff", "abilities/talent_general/talent_general_lone_wolf.lua", LUA_MODIFIER_MOTION_NONE)

--Abilities
if talent_general_lone_wolf == nil then
	talent_general_lone_wolf = class({})
end
function talent_general_lone_wolf:OnSpellStart()
	local iPlayerID = GetPlayerID(self:GetCaster())
	local hCaster = self:GetCaster()

	---@param tData EventData_TowerAbilityUpdate
	EventManager:register(ET_PLAYER.ON_TOWER_ABILITY_UPDATE, function(tData)
		if tData.PlayerID ~= iPlayerID then return end

		EachUnits(iPlayerID, function(hUnit)
			-- 是否有羁绊技能被解锁
			for i = 0, 7 do
				local hAblt = hUnit:GetAbilityByIndex(i)
				if hAblt and hAblt.bTagActive then
					local sTag = DotaTD:GetAbilityTag(hAblt:GetAbilityName())
					if "" ~= sTag and "base" ~= sTag then
						-- 有解锁，移除BUFF
						hUnit:RemoveModifierByName('modifier_talent_general_lone_wolf_buff')
						return
					end
				end
			end
			-- 未解锁任何羁绊技能，添加BUFF
			hUnit:AddNewModifier(hCaster, self, 'modifier_talent_general_lone_wolf_buff', nil)
		end, UnitType.Building)

	end, nil, nil, self:GetAbilityName() .. iPlayerID)
end


-- 单位身上的BUFF
if modifier_talent_general_lone_wolf_buff == nil then
	modifier_talent_general_lone_wolf_buff = class({}, nil, eom_modifier)
end
function modifier_talent_general_lone_wolf_buff:GetTexture()
	return GetAbilityTexture('talent_general_lone_wolf')
end
function modifier_talent_general_lone_wolf_buff:OnCreated(params)
	local iLevel = GetPlayerTalentLevel(self:GetPlayerID(), 'talent_general_lone_wolf')
	self.attack_bonus_pct = self:GetKVSpecialValueFor('talent_general_lone_wolf', 'attack_bonus_pct', iLevel)
end
function modifier_talent_general_lone_wolf_buff:OnRefresh(params)
	local iLevel = GetPlayerTalentLevel(self:GetPlayerID(), 'talent_general_lone_wolf')
	self.attack_bonus_pct = self:GetKVSpecialValueFor('talent_general_lone_wolf', 'attack_bonus_pct', iLevel)
end
function modifier_talent_general_lone_wolf_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
	}
end
function modifier_talent_general_lone_wolf_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_talent_general_lone_wolf_buff:OnTooltip()
	return self.attack_bonus_pct
end