LinkLuaModifier("modifier_alchemist_1_buff", "abilities/tower/alchemist/alchemist_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if alchemist_3 == nil then
	alchemist_3 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET }, nil, ability_base_ai)
end
function alchemist_3:GetManaCost(iLevel)
	if IsServer() then
		return 0
	else
		return self:GetCaster():GetMana()
	end
end
function alchemist_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local count = hCaster:GetMana() / self:GetSpecialValueFor("mana_cost")
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		if count > 0 and hUnit:IsAlive() and hUnit ~= hCaster then
			count = count - 1
			self:CreateTrackingProjectile("particles/units/heroes/hero_alchemist/alchemist_unstable_concoction_projectile.vpcf", 1200, hCaster, hUnit, DOTA_PROJECTILE_ATTACHMENT_ATTACK_3, hCaster:GetAbsOrigin(), false)
		end
	end, UnitType.AllFirends)
	self:UseResources(true, false, false)
end
function alchemist_3:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	local hAbility = hCaster:FindAbilityByName("alchemist_1")
	if hTarget then
		hTarget:AddNewModifier(hCaster, hAbility, "modifier_alchemist_1_buff", { duration = self:GetDuration() })
	end
end