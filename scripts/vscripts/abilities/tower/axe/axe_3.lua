LinkLuaModifier("modifier_axe_3", "abilities/tower/axe/axe_3.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_axe_3_buff", "abilities/tower/axe/axe_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if axe_3 == nil then
	axe_3 = class({})
end
function axe_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local flRadius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), flRadius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.TAUNT, self:GetDuration())
	end
	-- 加护甲
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		hUnit:AddNewModifier(hCaster, self, "modifier_axe_3_buff", { duration = self:GetDuration() })
	end, UnitType.AllFirends)
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/axe_ti9_immortal/axe_ti9_call.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, 1, 1))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Axe.Berserkers_Call")
end
function axe_3:GetIntrinsicModifierName()
	return "modifier_axe_3"
end
---------------------------------------------------------------------
--Modifiers
if modifier_axe_3 == nil then
	modifier_axe_3 = class({}, nil, eom_modifier)
end
function modifier_axe_3:IsHidden()
	return self:GetStackCount() == 0
end
function modifier_axe_3:OnCreated(params)
	self.armor_per_stack = self:GetAbilitySpecialValueFor("armor_per_stack")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
	end
end
function modifier_axe_3:OnStack()
	if IsServer() then
		if self:GetStackCount() < self.max_stack then
			self:IncrementStackCount()
		end
		if self:GetStackCount() >= self.max_stack then
			self:SetStackCount(0)
			self:GetParent():PassiveCast(self:GetAbility(), DOTA_ABILITY_BEHAVIOR_NO_TARGET, { bIgnoreBackswing = true })
		end
	end
end
function modifier_axe_3:OnDestroy()
	if IsServer() then
	end
end
function modifier_axe_3:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ARMOR_BONUS
	}
end
function modifier_axe_3:GetPhysicalArmorBonus()
	return self.armor_per_stack * self:GetStackCount()
end
---------------------------------------------------------------------
if modifier_axe_3_buff == nil then
	modifier_axe_3_buff = class({}, nil, eom_modifier)
end
function modifier_axe_3_buff:OnCreated(params)
	self.armor_per_stack = self:GetAbilitySpecialValueFor("armor_per_stack")
	self.max_stack = self:GetAbilitySpecialValueFor("max_stack")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/axe_cinder/axe_cinder_battle_hunger.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_axe_3_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ARMOR_BONUS] = self.armor_per_stack * self.max_stack,
		[EMDF_MAGICAL_ARMOR_BONUS] = self.armor_per_stack * self.max_stack
	}
end
function modifier_axe_3_buff:GetPhysicalArmorBonus()
	return self.armor_per_stack * self.max_stack
end
function modifier_axe_3_buff:GetMagicalArmorBonus()
	return self.armor_per_stack * self.max_stack
end
function modifier_axe_3_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_axe_3_buff:OnTooltip()
	return self.armor_per_stack * self.max_stack
end