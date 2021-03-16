LinkLuaModifier("modifier_art_alone_wolf", "abilities/artifact/art_alone_wolf.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_alone_wolf == nil then
	art_alone_wolf = class({}, nil, artifact_base)
end
function art_alone_wolf:GetIntrinsicModifierName()
	return "modifier_art_alone_wolf"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_alone_wolf == nil then
	modifier_art_alone_wolf = class({}, nil, eom_modifier)
end
function modifier_art_alone_wolf:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	if IsServer() then
	end
end
function modifier_art_alone_wolf:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor('chance')
	if IsServer() then
	end
end
function modifier_art_alone_wolf:OnDestroy()
	if IsServer() then
	end
end
function modifier_art_alone_wolf:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_PLAYER.ON_TOWER_LEVELUP, self.LeveUp, EVENT_LEVEL_MEDIUM }
	}
end
function modifier_art_alone_wolf:LeveUp(tData)
	DeepPrintTable(tData)
	local hUnit = EntIndexToHScript(tData.entIndex)
	if IsValid(hUnit) then
		for i = 0, hUnit:GetAbilityCount() - 1 do
			local hAbility = hUnit:GetAbilityByIndex(i)
			if IsValid(hAbility) then
				if RollPercentage(100) and hAbility:GetLevel() == 0 then
					Timer(0, function()
						hAbility:SetLevel(hUnit:GetLevel())

					end)
					return
				end
			end
		end
	end
end