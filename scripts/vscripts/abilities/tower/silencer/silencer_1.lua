LinkLuaModifier("modifier_silencer_1", "abilities/tower/silencer/silencer_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_1_effect", "abilities/tower/silencer/silencer_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_1_effect_buff", "abilities/tower/silencer/silencer_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_silencer_1_effect_debuff", "abilities/tower/silencer/silencer_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if silencer_1 == nil then
	silencer_1 = class({})
end
function silencer_1:GetIntrinsicModifierName()
	return "modifier_silencer_1"
end
function silencer_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local health_regen_pct = self:GetSpecialValueFor("health_regen_pct")

	hCaster:AddNewModifier(hCaster, self, "modifier_silencer_1_effect", { duration = LOCAL_PARTICLE_MODIFIER_DURATION })

	local iCount = 0

	-- 自身负面BUFF
	local tModifiers = hCaster:FindAllModifiers()
	for _, hModifier in pairs(tModifiers) do
		if IsValid(hModifier)
		and hModifier.IsPurgable
		and hModifier:IsPurgable() == true
		and hModifier:IsDebuff() == true then
			hCaster:AddNewModifier(hCaster, self, "modifier_silencer_1_effect_buff", { duration = LOCAL_PARTICLE_MODIFIER_DURATION })
			hModifier:Destroy()
			iCount = iCount + 1
		end
	end

	-- 敌人的正面BUFF
	local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _, hTarget in pairs(tTargets) do
		if IsValid(hTarget) then
			local tModifiers = hTarget:FindAllModifiers()
			for _, hModifier in pairs(tModifiers) do
				if IsValid(hModifier)
				and hModifier.IsPurgable
				and hModifier:IsPurgable() == true
				and hModifier:IsDebuff() == false then
					hTarget:AddNewModifier(hCaster, self, "modifier_silencer_1_effect_debuff", { duration = LOCAL_PARTICLE_MODIFIER_DURATION })
					hModifier:Destroy()
					iCount = iCount + 1
				end
			end
		end
	end

	local flAmount = hCaster:GetHealth() * math.min(100, iCount * health_regen_pct) * 0.01
	hCaster:Heal(flAmount, self)

	local hAbility = hCaster:FindAbilityByName("silencer_3")
	if IsValid(hAbility) and hAbility.Trigger then
		hAbility:Trigger()
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_silencer_1 == nil then
	modifier_silencer_1 = class({}, nil, BaseModifier)
end
function modifier_silencer_1:IsHidden()
	return true
end
function modifier_silencer_1:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_silencer_1:OnIntervalThink()
	if self:GetParent():IsAbilityReady(self:GetAbility()) then
		ExecuteOrderFromTable({
			UnitIndex = self:GetParent():entindex(),
			OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
			AbilityIndex = self:GetAbility():entindex()
		})
	end
end

------------------------------------------------------------------------------
if modifier_silencer_1_effect == nil then
	modifier_silencer_1_effect = class({}, nil, BaseModifier)
end
function modifier_silencer_1_effect:IsHidden()
	return true
end
function modifier_silencer_1_effect:OnCreated(params)
	if IsClient() then
		local radius = self:GetAbilitySpecialValueFor("radius")
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_curse_aoe.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(radius, radius, radius))
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
------------------------------------------------------------------------------
if modifier_silencer_1_effect_buff == nil then
	modifier_silencer_1_effect_buff = class({}, nil, BaseModifier)
end
function modifier_silencer_1_effect_buff:IsHidden()
	return true
end
function modifier_silencer_1_effect_buff:OnCreated(params)
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_silencer/silencer_loadout.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
------------------------------------------------------------------------------
if modifier_silencer_1_effect_debuff == nil then
	modifier_silencer_1_effect_debuff = class({}, nil, BaseModifier)
end
function modifier_silencer_1_effect_debuff:IsHidden()
	return true
end
function modifier_silencer_1_effect_debuff:OnCreated(params)
	if IsClient() then
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/silencer/silencer_1.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end