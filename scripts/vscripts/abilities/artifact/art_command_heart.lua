LinkLuaModifier("modifier_art_command_heart", "abilities/artifact/art_command_heart.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_command_heart == nil then
	art_command_heart = class({}, nil, artifact_base)
end
function art_command_heart:GetIntrinsicModifierName()
	return "modifier_art_command_heart"
end
function art_command_heart:OnSpellStart()
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_command_heart == nil then
	modifier_art_command_heart = class({}, nil, eom_modifier)
end
function modifier_art_command_heart:OnCreated(params)
	self.iPlayerID = GetPlayerID(self:GetParent())
	self.upgrade_decpct = self:GetAbilitySpecialValueFor('cost_pct')
	---@param tData EventData_PlayerDrawCard
	if IsServer() then
		self.tList = {
			EventManager:register(ET_PLAYER.ON_HERO_CARD_BUY_IN_DRAW, function(tData)
				if type(tData.sCardName) == 'string' and tData.PlayerID == GetPlayerID(self:GetParent()) then
					if DotaTD:GetCardRarity(tData.sCardName) == 'ssr' then
						self:IncrementStackCount()
						PlayerData:RefreshPlayerData()
					end
				end
			end, nil, nil),
			EventManager:register(ET_PLAYER.ON_COMMANDER_LEVELUP, function(tData)
				if tData.PlayerID == self.iPlayerID then
					self:SetStackCount(0)
					PlayerData:RefreshPlayerData()
				end
			end, nil, nil),
		}
	end
end
function modifier_art_command_heart:OnRefresh(params)
	self.upgrade_decpct = self:GetAbilitySpecialValueFor('cost_pct')
	if IsServer() then
	end
end
function modifier_art_command_heart:OnDestroy()
	if IsServer() then
		for k, id in pairs(self.tList) do
			EventManager:unregisterByID(id)
		end
	end
end
function modifier_art_command_heart:EDeclareFunctions()
	return {
		EMDF_CMD_UPGRADE_DISCOUNT_PERCENTAGE
	}
end
function modifier_art_command_heart:GetModifierCmdUpgradeDiscont()
	if IsServer() then
		if self:GetStackCount() ~= 0 then
			return self.upgrade_decpct * self:GetStackCount()
		else
			return 0
		end
	end
end