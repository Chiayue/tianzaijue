LinkLuaModifier("modifier_satyr_spawn_a_1_debuff", "abilities/tower/satyr_spawn_a/satyr_spawn_a_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_satyr_spawn_a_1_effect", "abilities/tower/satyr_spawn_a/satyr_spawn_a_1.lua", LUA_MODIFIER_MOTION_NONE)

if satyr_spawn_a_1 == nil then
	satyr_spawn_a_1 = class({}, nil, ability_base_ai)
end
function satyr_spawn_a_1:GetAOERadius()
	return self:GetSpecialValueFor("radius")
end
function satyr_spawn_a_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local damage_magical_armor_pct = self:GetSpecialValueFor("damage_magical_armor_pct")

	local fDamage = hCaster:GetVal(ATTRIBUTE_KIND.MagicalArmor) * damage_magical_armor_pct * 0.01

	local damage_table = {
		ability = self,
		attacker = hCaster,
		-- victim = hTarget,
		damage = fDamage,
		damage_type = DAMAGE_TYPE_MAGICAL
	}

	local tEnemies = FindUnitsInRadius(
	hCaster:GetTeamNumber(),
	hCaster:GetAbsOrigin(),
	nil,
	radius,
	self:GetAbilityTargetTeam(),
	self:GetAbilityTargetType(),
	DOTA_UNIT_TARGET_FLAG_NONE,
	FIND_ANY_ORDER,
	false)

	for k, hTarget in pairs(tEnemies) do
		if IsValid(hTarget) and hTarget:IsAlive() then
			damage_table.victim = hTarget
			ApplyDamage(damage_table)
		end
	end

	-- 特效
	hCaster:AddNewModifier(hCaster, self, "modifier_satyr_spawn_a_1_effect", { duration = 1 })
end

------------------------------------------------------------------------------
if modifier_satyr_spawn_a_1_effect == nil then
	modifier_satyr_spawn_a_1_effect = class({}, nil, BaseModifier)
end
function modifier_satyr_spawn_a_1_effect:OnCreated(params)
	if IsClient() then
		local radius = self:GetAbilitySpecialValueFor("radius")
		local iParticle = ParticleManager:CreateParticle("particles/neutral_fx/neutral_prowler_shaman_stomp.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(radius, 1, radius))
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
function modifier_satyr_spawn_a_1_effect:OnRefresh(params)
	if IsClient() then
		local radius = self:GetAbilitySpecialValueFor("radius")
		local iParticle = ParticleManager:CreateParticle("particles/neutral_fx/neutral_prowler_shaman_stomp.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 1, Vector(radius, 1, radius))
		ParticleManager:ReleaseParticleIndex(iParticle)
	end
end
function modifier_satyr_spawn_a_1_effect:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_satyr_spawn_a_1_effect:IsHidden()
	return true
end