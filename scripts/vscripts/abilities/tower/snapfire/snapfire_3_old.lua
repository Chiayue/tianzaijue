if snapfire_3 == nil then
	snapfire_3 = class({})
end
function snapfire_3:Spawn()
	local hCaster = self:GetCaster()
	hCaster.GetBonusBullet = function (hCaster)
		return self:GetBonusBullet()
	end
end
function snapfire_3:GetBonusBullet()
	local bonus_bullet = self:GetSpecialValueFor("bonus_bullet")
	if self:GetCaster():HasModifier("modifier_snapfire_2_crit") then
		bonus_bullet = bonus_bullet * self:GetSpecialValueFor("bonus_bullet_factor")
	end
	return bonus_bullet
end