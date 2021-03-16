LinkLuaModifier("modifier_golemA_3", "abilities/tower/golemA/golemA_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_golemA_3_buff", "abilities/tower/golemA/golemA_3.lua", LUA_MODIFIER_MOTION_NONE)

if golemA_3 == nil then
	golemA_3 = class({})
end
function golemA_3:GetIntrinsicModifierName()
	return "modifier_golemA_3"
end

------------------------------------------------------------------------------
if modifier_golemA_3 == nil then
	modifier_golemA_3 = class({}, nil, eom_modifier)
end
function modifier_golemA_3:OnCreated(params)
	if IsServer() then
	end
end
function modifier_golemA_3:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_golemA_3:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_golemA_3:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_DEATH] = {nil, self:GetParent() }
	}
end
function modifier_golemA_3:CheckState()
	return {
	}
end
function modifier_golemA_3:OnDeath(params)
	if GSManager:getStateType() == GS_Battle then
		local hParent = self:GetParent()
		local boom_radius = self:GetAbilitySpecialValueFor("boom_radius")
		local health_pct = self:GetAbilitySpecialValueFor("health_pct")
		local boom_damage_maxhealth_pct = self:GetAbilitySpecialValueFor("boom_damage_maxhealth_pct")
		local phy_atk_pct = self:GetAbilitySpecialValueFor("phy_atk_pct")
		local hAbility = self:GetAbility()
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), boom_radius, hAbility)
		local flDamage = hParent:GetMaxHealth() * boom_damage_maxhealth_pct * 0.01 + hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * phy_atk_pct * 0.01
		if params.unit == hParent and self:GetAbility():IsActivated() then
			hParent:DealDamage(tTargets, hAbility, flDamage)
			local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earth_spirit/earthspirit_petrify_shockwave.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
			ParticleManager:SetParticleControl(iParticle, 1, Vector(boom_radius, 0, 0))
			ParticleManager:ReleaseParticleIndex(iParticle)
			for i = 1, 2 do
				local hGolem = hParent:Summon(hParent:GetUnitName())
				hGolem:LevelUp(true, hParent:GetLevel() - 1)
				hGolem:AddNewModifier(hGolem, nil, "modifier_star_indicator", nil)
				hGolem:ModifyMaxHealth(-hGolem:GetMaxHealth() * (1 - health_pct * 0.01))
				hGolem:AddNewModifier(hParent, self:GetAbility(), "modifier_golemA_3_buff", nil)
				hGolem:SetModifierStackCount("modifier_golemA_3_buff", hParent, math.floor(hParent:GetVal(ATTRIBUTE_KIND.PhysicalAttack) / hParent:GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE)))
				hGolem:AddNewModifier(hParent, nil, "modifier_building_ai", nil)
				hGolem:SetHullRadius(12)
				hGolem:SetForwardVector(hParent:GetForwardVector())
				for i = 0, 2 do
					local _hAbility = hGolem:GetAbilityByIndex(i)
					_hAbility:SetLevel(hParent:GetAbilityByIndex(i):GetLevel())
					if _hAbility:GetAbilityName() == hAbility:GetAbilityName() then
						_hAbility:SetActivated(false)
					end
				end
				hParent:KnockBack(hParent:GetAbsOrigin() + RandomVector(100), hGolem, 300, 150, 1, true)
				hGolem:AddBuff(hParent, BUFF_TYPE.INVINCIBLE, 1)
			end
		end
	end
end
---------------------------------------------------------------------
if modifier_golemA_3_buff == nil then
	modifier_golemA_3_buff = class({}, nil, eom_modifier)
end
function modifier_golemA_3_buff:OnCreated(params)
	if IsServer() then
		self:GetParent():SetModelScale(0.7)
	end
end
function modifier_golemA_3_buff:IsHidden()
	return true
end
function modifier_golemA_3_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_PHYSICAL_ATTACK_BONUS,
	}
end
function modifier_golemA_3_buff:OnBattleEnd()
	self:Destroy()
end
function modifier_golemA_3_buff:OnDestroy()
	if IsServer() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_golemA_3_buff:GetPhysicalAttackBonus()
	return self:GetParent():GetValByKey(ATTRIBUTE_KIND.PhysicalAttack, ATTRIBUTE_KEY.BASE) * self:GetStackCount()
end