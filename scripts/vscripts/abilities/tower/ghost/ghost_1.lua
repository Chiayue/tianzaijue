LinkLuaModifier("modifier_ghost_1_debuff", "abilities/tower/ghost/ghost_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if ghost_1 == nil then
	ghost_1 = class({ iSearchBehavior = AI_SEARCH_BEHAVIOR_MOST_AOE_TARGET }, nil, ability_base_ai)
end
function ghost_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function ghost_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local vPosition = self:GetCursorPosition()
	local flRadius = self:GetSpecialValueFor("radius")
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, flRadius, self)
	for _, hUnit in pairs(tTargets) do
		hUnit:AddBuff(hCaster, BUFF_TYPE.CURSE.COLD, self:GetDuration(), true)
		hUnit:AddNewModifier(hCaster, self, "modifier_ghost_1_debuff", { duration = self:GetDuration() })
	end
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_apparition_chilling_touch.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vPosition)
	ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, flRadius, 0))
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Ancient_Apparition.ColdFeetCast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_ghost_1_debuff == nil then
	modifier_ghost_1_debuff = class({}, nil, eom_modifier)
end
function modifier_ghost_1_debuff:IsDebuff()
	return true
end
function modifier_ghost_1_debuff:OnCreated(params)
	self.magical2magical = self:GetAbilitySpecialValueFor("magical2magical")
	self.flInterval = self:GetAbilitySpecialValueFor("flInterval")
	self.flTime = 0
	self:SetStackCount(self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical2magical * 0.01)
	self:StartIntervalThink(self.flInterval)
	self.bBuffEnable = true
end
function modifier_ghost_1_debuff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_ghost_1_debuff:OnIntervalThink()
	self.bBuffEnable = true
end
function modifier_ghost_1_debuff:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if hTarget ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetCaster()
	local flDamage = 0
	if self.bBuffEnable then
		if self:GetCaster():HasModifier("modifier_ghost_2") then
			local hAbility = self:GetCaster():FindAbilityByName("ghost_2")
			flDamage = hAbility:GetBonusDamage(hTarget, hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.magical2magical * 0.01)
			hAbility:OnSpellStart(hTarget)
		end
		self:GetCaster():DealDamage(hTarget, self:GetAbility(), flDamage)
		self.bBuffEnable = false
	end
end
function modifier_ghost_1_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_ghost_1_debuff:OnTooltip()
	return self:GetStackCount()
end