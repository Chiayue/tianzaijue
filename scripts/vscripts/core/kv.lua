if KeyValues == nil then
	KeyValues = class({})
end

if IsServer() then
	KeyValues.NpcEnemyKv = LoadKeyValues("scripts/npc/kv/npc_enemy.kv")
	KeyValues.BaseCardPoolKv = LoadKeyValues("scripts/npc/kv/base_card_pool.kv")
	KeyValues.WaveKv = LoadKeyValues("scripts/npc/kv/round.kv")
	KeyValues.RoundEnemyKv = LoadKeyValues("scripts/npc/kv/round_enemy.kv")
	KeyValues.ReservoirsKv = LoadKeyValues("scripts/npc/kv/reservoirs.kv")
	KeyValues.DrawKv = LoadKeyValues("scripts/npc/kv/draw.kv")
	KeyValues.ItemPoolKv = LoadKeyValues("scripts/npc/kv/item_pool.kv")
	KeyValues.HeroesUpgradesKv = LoadKeyValues("scripts/npc/kv/npc_heroes_upgrades.kv")
	KeyValues.SpellCardsKv = LoadKeyValues("scripts/npc/abilities/spell.kv")
	KeyValues.SpecialAbilities = LoadKeyValues("scripts/npc/abilities/special_abilities.kv")
	KeyValues.ArtifactKv = LoadKeyValues("scripts/npc/abilities/artifact.kv")
	KeyValues.ArtifactPoolKv = LoadKeyValues("scripts/npc/kv/artifact_pool.kv")
	KeyValues.SpellKv = LoadKeyValues("scripts/npc/abilities/spell.kv")
	KeyValues.SpellCardPoolKv = LoadKeyValues("scripts/npc/kv/spellcard_pool.kv")
	KeyValues.BossKv = LoadKeyValues("scripts/npc/kv/npc_boss.kv")
	KeyValues.CommanderKv = LoadKeyValues("scripts/npc/kv/commander.kv")
	KeyValues.CmdAbilitiesKv = LoadKeyValues("scripts/npc/abilities/cmdabilities.kv")
	KeyValues.ConsumableKv = LoadKeyValues("scripts/npc/abilities/consumable.kv")
	KeyValues.AffixKv = LoadKeyValues("scripts/npc/abilities/affix.kv")
	KeyValues.CourierKv = LoadKeyValues("scripts/npc/kv/courier.kv")
	KeyValues.BoxInfoKv = LoadKeyValues("scripts/npc/kv/info_box.kv")
	KeyValues.ContractKv = LoadKeyValues("scripts/npc/kv/contract.kv")
	KeyValues.HeroCardPoolKv = LoadKeyValues("scripts/npc/kv/herocard_pool.kv")

	KeyValues.UnitsKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	KeyValues.AbilitiesKv = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	KeyValues.ItemsKv = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	KeyValues.HerolistKv = LoadKeyValues("scripts/npc/herolist.txt")
	KeyValues.HeroGroup = LoadKeyValues("scripts/npc/kv/hero_group.kv")
	KeyValues.CourierTitleKv = LoadKeyValues("scripts/npc/kv/courier_title.kv")

	-- KeyValues.AssetModifiersKv = LoadKeyValues("scripts/npc/asset_modifiers.kv")
else
	KeyValues.AbilitiesKv = LoadKeyValues("scripts/npc/npc_abilities_custom.txt")
	KeyValues.ItemsKv = LoadKeyValues("scripts/npc/npc_items_custom.txt")
	KeyValues.UnitsKv = LoadKeyValues("scripts/npc/npc_units_custom.txt")
	KeyValues.BossKv = LoadKeyValues("scripts/npc/kv/npc_boss.kv")
end

KeyValues.CardsKv = {}
for sUnitName, v in pairs(KeyValues.UnitsKv) do
	if v.UnitLabel == 'HERO' then
		local Rarity = string.lower(v.Rarity)
		if not KeyValues.CardsKv[Rarity] then KeyValues.CardsKv[Rarity] = {} end
		KeyValues.CardsKv[Rarity][sUnitName] = sUnitName
	end
end

--加载KV中多重Val
---@return table {值1,值2,...}
function LoadKvMultiVal(sVal)
	local t = {}
	if sVal then
		local tList = string.split(sVal, " | ")
		if tList then
			local tRandom = {}
			for _, v in pairs(tList) do
				local tList2 = string.split(v, "#")
				if tList2[2] and 0 < tonumber(tList2[2]) then
					--随机权重项
					tRandom[tList2[1]] = tonumber(tList2[2])
				else
					--必选项
					table.insert(t, tList2[1])
				end
			end
			if 0 < TableCount(tRandom) then
				local pool = WeightPool(tRandom)
				table.insert(t, pool:Random())
			end
		end
	end
	return t
end
--解析KV中多重Val
---@return table {值1=权重,值2=权重,...}
function DecodeKvMultiVal(sVal)
	local t = {}
	if sVal then
		local tList = string.split(sVal, " | ")
		if tList then
			for _, v in pairs(tList) do
				local tList2 = string.split(v, "#")
				if tList2[2] and 0 < tonumber(tList2[2]) then
					t[tList2[1]] = tonumber(tList2[2])
				else
					t[tList2[1]] = 100
				end
			end
		end
	end
	return t
end


if IsServer() and IsInToolsMode() then
	require("lib/generate_json")
	-- KvToTs("AbilitiesKv", KeyValues.AbilitiesKv)
	-- KvToTs("ItemsKv", KeyValues.ItemsKv)
	-- KvToTs("UnitsKv", KeyValues.UnitsKv)
	-- KvToTs("WaveKv", KeyValues.WaveKv)
	-- KvToTs("NpcEnemyKv", KeyValues.NpcEnemyKv)
	-- KvToTs("CardsKv", KeyValues.CardsKv)
	-- KvToTs("ArtifactKv", KeyValues.ArtifactKv)
	-- KvToTs("SpecialAbilities", KeyValues.SpecialAbilities)
end