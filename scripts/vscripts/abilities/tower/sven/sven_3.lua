LinkLuaModifier("modifier_sven_3_buff", "abilities/tower/sven/sven_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sven_3 == nil then
	sven_3 = class({}, nil, ability_base_ai)
end
function sven_3:OnSpellStart()
	local hCaster = self:GetCaster()
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_sven_3_buff", { duration = self:GetDuration() })
	end, UnitType.AllFirends)

	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_head", hCaster:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:EmitSound("Hero_Sven.WarCry")
end
---------------------------------------------------------------------
--Modifiers
if modifier_sven_3_buff == nil then
	modifier_sven_3_buff = class({}, nil, eom_modifier)
end
function modifier_sven_3_buff:OnCreated(params)
	self.armor_health_pct = self:GetAbilitySpecialValueFor("armor_health_pct")
	self.pure_damage = self:GetAbilitySpecialValueFor("pure_damage")
	if IsServer() then
		self:SetStackCount(math.ceil(self.armor_health_pct * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01))
	else
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_warcry_buff_shield.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(0, 0, 0), false)
		ParticleManager:SetParticleControl(iParticle, 1, Vector(80, 80, 80))
		self:AddParticle(iParticle, false, false, 1, false, false)
	end
end
function modifier_sven_3_buff:OnRefresh(params)
	self.armor_health_pct = self:GetAbilitySpecialValueFor("armor_health_pct")
	self.pure_damage = self:GetAbilitySpecialValueFor("pure_damage")
	if IsServer() then
		self:SetStackCount(math.ceil(self.armor_health_pct * self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01))
	end
end
function modifier_sven_3_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_sven_3_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_sven_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_PROPERTY_TOOLTIP2
	}
end
function modifier_sven_3_buff:OnTooltip()
	return self.pure_damage * self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01
end
function modifier_sven_3_buff:OnTooltip2()
	return self.armor_health_pct * self:GetCaster():GetVal(ATTRIBUTE_KIND.StatusHealth) * 0.01
end
function modifier_sven_3_buff:GetModifierTotal_ConstantBlock(params)
	if params.damage ~= params.damage then return end
	if self:GetStackCount() < params.damage then
		self:Destroy()
		return self:GetStackCount()
	end
	self:SetStackCount(self:GetStackCount() - math.ceil(params.damage))
	return params.damage
end
function modifier_sven_3_buff:OnAttackLanded(params)
	if IsValid(self:GetAbility()) and IsValid(params.attacker) then
		if IsValid(params.target) then
			params.attacker:DealDamage(params.target, self:GetAbility(), self.pure_damage * self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * 0.01, DAMAGE_TYPE_PURE)
		end
	end
end