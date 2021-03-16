LinkLuaModifier("modifier_axe_1", "abilities/tower/axe/axe_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if axe_1 == nil then
	axe_1 = class({})
end
function axe_1:GetIntrinsicModifierName()
	return "modifier_axe_1"
end
function axe_1:Trigger()
	local hCaster = self:GetCaster()
	local armor_factor = self:GetSpecialValueFor("armor_factor")
	local radius = self:GetSpecialValueFor("radius")

	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_3)

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_attack_blur_counterhelix.vpcf", PATTACH_ABSORIGIN, hCaster)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalArmor) * armor_factor * 0.01
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hCaster:GetAbsOrigin(), radius, self)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage)
		-- hUnit:AddBuff(hCaster, BUFF_TYPE.IGNITE, self.ignite_duration, false, {iCount = self.ignite_count})
	end
	hCaster:EmitSound("Hero_Axe.CounterHelix")
	-- 技能3
	if hCaster:HasModifier("modifier_axe_3") then
		hCaster:FindModifierByName("modifier_axe_3"):OnStack()
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_axe_1 == nil then
	modifier_axe_1 = class({}, nil, eom_modifier)
end
function modifier_axe_1:IsHidden()
	return true
end
function modifier_axe_1:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_axe_1:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_axe_1:OnDestroy()
	if IsServer() then
	end
end
function modifier_axe_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_axe_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end

	local hAbility = self:GetAbility()
	if type(hAbility.Trigger) == "function" then
		hAbility:Trigger()
	end
end
function modifier_axe_1:OnTakeDamage(params)
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() and PRD(hParent, self.chance, "axe_1") then
		if type(hAbility.Trigger) == "function" then
			hAbility:UseResources(false, false, true)
			hAbility:Trigger()
		end
	end
end