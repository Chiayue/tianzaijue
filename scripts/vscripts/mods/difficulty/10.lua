--第九章难度
--
---怪物属性修改
ENEMY_ATTRIBUTE_MODIFIER = function(hUnit)
	local iRound = Spawner:GetActualRound()
	local iPlayerCount = PlayerData:GetAlivePlayerCount()

	local t = {}

	-- 基础数值倍率
	local tBasePercentage = {}
	if hUnit:IsBoss() then
		-- BOSS
		-- 额外百分比
		local iBoss = 1
		if iRound ~= 0 then iBoss = math.floor(iRound / 10)
		else iBoss = 1 end
		tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = ({ 0, 150, 200, 350 })[iPlayerCount] + (2400 / ({ 18, 18, 9, 6 })[iBoss])
		tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount] + (400 / ({ 1, 1, 1, 1 })[iBoss])
		tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount] + (400 / ({ 1, 1, 1, 1 })[iBoss])
		tBasePercentage[EMDF_PHYSICAL_ARMOR_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount] + 400
		tBasePercentage[EMDF_MAGICAL_ARMOR_BONUS] = ({ 0, 0, 0, 0 })[iPlayerCount] + 400
		--年兽BOSS
		if hUnit:GetUnitName() == 'nian_boss' then
			local nianPower = 2250
			tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = ({ 1, 3, 5, 7 })[iPlayerCount] * nianPower
			tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = nianPower / 10
			tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = nianPower / 10
			t[EMDF_PHYSICAL_ARMOR_BONUS] = (t[EMDF_PHYSICAL_ARMOR_BONUS] or 0) + 2000
			t[EMDF_MAGICAL_ARMOR_BONUS] = (t[EMDF_MAGICAL_ARMOR_BONUS] or 0) + 2000
		end

	elseif not hUnit:IsGoldWave() then
		-- 非宝箱怪
		-- 额外百分比
		tBasePercentage[EMDF_STATUS_HEALTH_BONUS] = 0 + 400
		tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = 0 + 200
		tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = 0 + 200
		if hUnit:GetUnitLabel() == "elite" then
			tBasePercentage[EMDF_PHYSICAL_ATTACK_BONUS] = 0 + 400
			tBasePercentage[EMDF_MAGICAL_ATTACK_BONUS] = 0 + 400
		end
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