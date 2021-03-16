LinkLuaModifier("modifier_sniper_1", "abilities/tower/sniper/sniper_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if sniper_1 == nil then
	sniper_1 = class({})
end
function sniper_1:GetIntrinsicModifierName()
	return 'modifier_sniper_1'
end
---------------------------------------------------------------------
--Modifiers
if modifier_sniper_1 == nil then
	modifier_sniper_1 = class({}, nil, eom_modifier)
end
function modifier_sniper_1:OnCreated(params)
	if IsServer() then
		self:OnRefresh(params)
	end
end
function modifier_sniper_1:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	if IsServer() then
	end
end
function modifier_sniper_1:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_sniper_1:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	local hCaster = self:GetParent()

	if not hTarget:IsPositionInRange(hCaster:GetAbsOrigin(), self.distance) then
		if PRD(hCaster, self.chance, "sniper_1") then
			local iParticleID = ParticleManager:CreateParticle("particles/econ/items/sniper/sniper_immortal_cape/sniper_immortal_cape_headshot_slow.vpcf", PATTACH_OVERHEAD_FOLLOW, hTarget)
			ParticleManager:ReleaseParticleIndex(iParticleID)
			for _, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
				tDamageInfo.damage = tDamageInfo.damage * (1 + self.bonus_damage*0.01)
			end
		end
	end
end