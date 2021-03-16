LinkLuaModifier("modifier_art_dark_guard", "abilities/artifact/art_dark_guard.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if art_dark_guard == nil then
	art_dark_guard = class({}, nil, artifact_base)
end
function art_dark_guard:GetIntrinsicModifierName()
	return "modifier_art_dark_guard"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_dark_guard == nil then
	modifier_art_dark_guard = class({}, nil, eom_modifier)
end
function modifier_art_dark_guard:IsHidden()
	return true
end
function modifier_art_dark_guard:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_art_dark_guard:OnBattleEnd()
	local iPlayerID = GetPlayerID(self:GetParent())
	-- local tCardWeight = {}
	-- local hPool = Draw:GetCardPool(iPlayerID, "pool_n")
	-- if hPool then
	-- 	for sCardName, iCount in pairs(hPool.tList) do
	-- 		tCardWeight[sCardName] = iCount
	-- 	end
	-- end
	-- local hCardPool = WeightPool(tCardWeight)
	-- local sCardName = hCardPool:Random()
	local sCardName = Draw:DrawReservoir("portal", iPlayerID, {})
	if not HeroCardData:AddCardByName(iPlayerID, sCardName) then
		local hHero = PlayerData:GetHero(iPlayerID)
		local tCardData = HeroCardData:DefaultCardData(sCardName, iPlayerID)
		local iGold = HeroCardData:GetSellCardGold(iPlayerID, tCardData)
		PlayerData:ModifyGold(iPlayerID, iGold, false)

		local particleID = ParticleManager:CreateParticle("particles/items_fx/item_sheepstick.vpcf", PATTACH_WORLDORIGIN, nil)
		ParticleManager:SetParticleControl(particleID, 0, hHero:GetAbsOrigin())
		ParticleManager:ReleaseParticleIndex(particleID)

		EmitSoundOnLocationWithCaster(hHero:GetAbsOrigin(), "DOTA_Item.Sheepstick.Activate", hHero)
	else
		Draw:ModifyCardCountInPlayerPool(iPlayerID, sCardName, -1)
	end
end