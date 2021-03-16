--Abilities
if axe_2 == nil then
	axe_2 = class({}, nil, ability_base_ai)
end
function axe_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local vPosition = self:GetCursorPosition()
	local flDamage = (hCaster:GetVal(ATTRIBUTE_KIND.PhysicalArmor) * self:GetSpecialValueFor("armor_factor") + hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetSpecialValueFor("attack_factor")) * 0.01
	-- 特效
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill_b.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 4, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/axe/ti9_jungle_axe/ti9_jungle_axe_culling_blade_kill.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
	ParticleManager:SetParticleControl(iParticleID, 4, vPosition)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:DealDamage(hTarget, self, flDamage)
	hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetDuration())
	-- 范围
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, vPosition, self:GetSpecialValueFor("radius"), self)
	ArrayRemove(tTargets, hTarget)
	for _, hUnit in pairs(tTargets) do
		hCaster:DealDamage(hUnit, self, flDamage / #tTargets)
		hCaster:KnockBack(vPosition, hUnit, 0, 100, self:GetDuration(), true)
	end
	hCaster:EmitSound("Hero_Axe.Culling_Blade_Success")
end
function axe_2:GetIntrinsicModifierName()
	return "modifier_axe_2"
end