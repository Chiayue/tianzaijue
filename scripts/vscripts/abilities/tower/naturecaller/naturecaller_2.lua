LinkLuaModifier("modifier_naturecaller_2_rain", "abilities/tower/naturecaller/naturecaller_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if naturecaller_2 == nil then
	naturecaller_2 = class({})
end
function naturecaller_2:OnSpellStart()
	self.range = self:GetSpecialValueFor('range')
	self.recover_perseconds_pct = self:GetSpecialValueFor('recover_perseconds_pct')
	self.hCaster = self:GetCaster()
end
---------------------------------------------------------------------
---下雨光环
if modifier_naturecaller_2_rain == nil then
	modifier_naturecaller_2_rain = class({}, nil, eom_modifier)
end
function modifier_naturecaller_2_rain:IsHidden()
	return true
end
function modifier_naturecaller_2_rain:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.recover_perseconds_pct = self:GetAbilitySpecialValueFor('recover_perseconds_pct')
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/leshrac/leshrac_1.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticle, false, false, -1, false, false)
	end
end
function modifier_naturecaller_2_rain:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.recover_perseconds_pct = self:GetAbilitySpecialValueFor('recover_perseconds_pct')
	if IsServer() then
	end
end
function modifier_naturecaller_2_rain:OnIntervalThink()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if not IsValid(hParent) or not IsValid(hCaster) then
		self:StartIntervalThink(-1)
		self:Destroy()
		return
	end
	-- local hAbility = hCaster:FindAbilityByName('naturecaller_1')
	EachUnits(self:GetPlayerID(), function(hUnit)
		hUnit:Heal(self.recover_perseconds_pct * hCaster:GetValByKey(ATTRIBUTE_KIND.MagicalAttack, ATTRIBUTE_KEY.BASE) * 0.01, self:GetAbility())
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/naturecaller/naturecaller_2_heal.vpcf", PATTACH_ABSORIGIN_FOLLOW, hUnit)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end, UnitType.AllFirends)
end