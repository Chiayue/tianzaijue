LinkLuaModifier("modifier_art_prophet_sheepskin", "abilities/artifact/art_prophet_sheepskin.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_prophet_sheepskin == nil then
	art_prophet_sheepskin = class({}, nil, artifact_base)
end
function art_prophet_sheepskin:GetIntrinsicModifierName()
	return "modifier_art_prophet_sheepskin"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_prophet_sheepskin == nil then
	modifier_art_prophet_sheepskin = class({}, nil, eom_modifier)
	-- 本身，静待变量，继承
end
function modifier_art_prophet_sheepskin:OnCreated(params)
	if IsServer() then
		self.max_item_lvlup_bonus = self:GetAbilitySpecialValueFor("max_item_lvlup_bonus")
		self.max_item_leldown_punish = self:GetAbilitySpecialValueFor("max_item_leldown_punish")
	end
end
function modifier_art_prophet_sheepskin:OnRefresh(params)
	if IsServer() then
		self.max_item_lvlup_bonus = self:GetAbilitySpecialValueFor("max_item_lvlup_bonus")
		self.max_item_leldown_punish = self:GetAbilitySpecialValueFor("max_item_leldown_punish")
	end
end
function modifier_art_prophet_sheepskin:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_prophet_sheepskin:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_ITEM_LVLUPDATE, self.OnPlayerItemLevelUpdate },
	}
end


function modifier_art_prophet_sheepskin:OnPlayerItemLevelUpdate(params)
	local iPlayerID = self:GetPlayerID()
	if params.PlayerID == iPlayerID then
		local randomInt = RandomInt(1, 2)
		if randomInt == 1 then
			params.level = -1
		else
			params.level = 2
		end
	end
end