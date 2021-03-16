--扭曲深渊难度
--
---怪物属性修改
ENEMY_ATTRIBUTE_MODIFIER = function(hUnit)
	local iRound = Spawner:GetActualRound()
	local iPlayerCount = PlayerData:GetAlivePlayerCount()

	local t = {}
	-- 基础数值倍率
	local tBasePercentage = {}
	local LevelDifficulty = 2500
	local curve = 50
	-- 基础数值倍率
	local tBasePercentage = {}
	if hUnit:IsBoss() then
		-- BOSS
		-- 额外百分比
		local iBoss = 1
		if iRound ~= 0 then iBoss = iRound / 10
		else iBoss = 1 end
		tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = ({ 1, 1.5, 2, 3 })[iPlayerCount] * (LevelDifficulty / ({ 20, 10, 1, 0.1 })[iBoss])
		tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = LevelDifficulty * ({ 2, 4, 4, 8 })[iBoss]
		tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = LevelDifficulty * ({ 2, 4, 4, 8 })[iBoss]
		tBasePercentage[EMDF_PHYSICAL_ARMOR_BONUS] = LevelDifficulty
		tBasePercentage[EMDF_MAGICAL_ARMOR_BONUS] = LevelDifficulty
		--年兽BOSS
		if hUnit:GetUnitName() == 'nian_boss' then
			local nianPower = 2700
			tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = ({ 1, 3, 5, 7 })[iPlayerCount] * nianPower
			tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = nianPower / 7
			tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = nianPower / 7
			t[EMDF_PHYSICAL_ARMOR_BONUS] = (t[EMDF_PHYSICAL_ARMOR_BONUS] or 0) + 2000
			t[EMDF_MAGICAL_ARMOR_BONUS] = (t[EMDF_MAGICAL_ARMOR_BONUS] or 0) + 2000
		end
	elseif not hUnit:IsGoldWave() then
		-- 非宝箱怪
		-- 额外百分比
		tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = (LevelDifficulty / 2) + (curve * (2 ^ (0.25 * iRound)))
		tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = (LevelDifficulty / 4) + (curve * (2 ^ (0.25 * iRound)) / 2)
		tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = (LevelDifficulty / 4) + (curve * (2 ^ (0.25 * iRound)) / 2)
		tBasePercentage[EMDF_PHYSICAL_ARMOR_BONUS] = 0
		tBasePercentage[EMDF_MAGICAL_ARMOR_BONUS] = 0

	end
	for typeEMdf, fValPercentage in pairs(tBasePercentage) do
		local fBase = hUnit:GetValConstByKey(E_DECLARE_FUNCTION[typeEMdf].attribute_kind, ATTRIBUTE_KEY.BASE)
		t[typeEMdf] = fBase * fValPercentage * 0.01
	end

	-- 基础数值附加
	if hUnit:IsBoss() then
	elseif not hUnit:IsGoldWave() then
		t[EMDF_PHYSICAL_ARMOR_BONUS] = (t[EMDF_PHYSICAL_ARMOR_BONUS] or 0) + iRound * 50
		t[EMDF_MAGICAL_ARMOR_BONUS] = (t[EMDF_MAGICAL_ARMOR_BONUS] or 0) + iRound * 50
	end

	return t
end