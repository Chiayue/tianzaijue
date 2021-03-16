--Abilities
if cmd_fur_2 == nil then
	cmd_fur_2 = class({}, nil, ability_base_ai)
end
function cmd_fur_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local count = self:GetSpecialValueFor("count")
	local damage_pct = self:GetSpecialValueFor("damage_pct")
	local tTargets = {}
	EachUnits(GetPlayerID(hCaster), function (hUnit)
		if count > 0 then
			hUnit:AddBuff(hCaster, BUFF_TYPE.ROOT, self:GetDuration(), false, {damage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * damage_pct * 0.01})
			count = count - 1
		end
	end, UnitType.AllEnemies)
end