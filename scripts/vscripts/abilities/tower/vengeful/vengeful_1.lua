--Abilities
if vengeful_1 == nil then
	vengeful_1 = class({}, nil, base_attack)
end
function vengeful_1:OnAttackLanded(params)
	local hCaster = self:GetCaster()
	if hCaster ~= params.attacker then return end
	params = GetAttackInfo(params.record, hCaster)
	if nil == params then return end
	local hTarget = params.target
	self:OnDamage(hTarget, params)

	local damage_pct = self:GetSpecialValueFor("damage_pct")
	local damage_limit = self:GetSpecialValueFor("damage_limit")
	local damage = math.min(hTarget:GetHealthDeficit() * damage_pct * 0.01, damage_limit)
	local damage_table = {
		ability = self,
		attacker = hCaster,
		victim = hTarget,
		damage = damage,
		damage_type = DAMAGE_TYPE_PHYSICAL
	}
	ApplyDamage(damage_table)
end