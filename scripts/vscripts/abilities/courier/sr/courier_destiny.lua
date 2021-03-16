LinkLuaModifier("modifier_courier_destiny", "abilities/courier/sr/courier_destiny.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_destiny == nil then
	courier_destiny = class({})
end
function courier_destiny:GetIntrinsicModifierName()
	return "modifier_courier_destiny"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_destiny == nil then
	modifier_courier_destiny = class({}, nil, eom_modifier)
end
function modifier_courier_destiny:OnCreated(params)

end
function modifier_courier_destiny:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_GAME.GAME_BEGIN, self.OnGameBegin }
	}
end
function modifier_courier_destiny:OnGameBegin()
	Artifact:Add(GetPlayerID(self:GetParent()), "art_destiny_hand")
end