LinkLuaModifier("modifier_lanaya_2_attack", "abilities/tower/lanaya/lanaya_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_lanaya_2_self_buff", "abilities/tower/lanaya/lanaya_2.lua", LUA_MODIFIER_MOTION_NONE)

if lanaya_2 == nil then
	lanaya_2 = class({})
end
function lanaya_2:OnCritHit(hIllusion)
	local hCaster = self:GetCaster()

	if not IsValid(hIllusion) or not hIllusion:IsAlive() then return end
	if self:GetLevel() <= 0 then return end
	if not IsValid(hCaster) or not hCaster:IsAlive() then return end
	if hCaster:IsIllusion() then return end
	if not self:ShouldUseResources() then return end

	local pathway_width = self:GetSpecialValueFor("pathway_width")

	self:UseResources(true, true, true)

	local vCaster = hCaster:GetAbsOrigin()
	local vIllusion = hIllusion:GetAbsOrigin()
	local qCaster = hCaster:GetAngles()
	local qIllusion = hIllusion:GetAngles()

	local hModifier = hCaster:AddNewModifier(hCaster, self, "modifier_lanaya_2_attack", nil)

	local tTargets = FindUnitsInLine(hCaster:GetTeamNumber(), vCaster, vIllusion, nil, pathway_width,
	DOTA_UNIT_TARGET_TEAM_ENEMY,
	DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES)
	for _, hTarget in pairs(tTargets) do
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step_impact.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hCaster:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN+ATTACK_STATE_IGNOREINVIS+ATTACK_STATE_NOT_USEPROJECTILE+ATTACK_STATE_NEVERMISS+ATTACK_STATE_NO_EXTENDATTACK+ATTACK_STATE_SKIPCOUNTING)
	end

	if IsValid(hModifier) then
		hModifier:Destroy()
	end

	--位移
	local iParticleID = ParticleManager:CreateParticle('particles/units/heroes/lanaya/lanaya_2_step_2.vpcf', PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControl(iParticleID, 0, vCaster)
	ParticleManager:SetParticleControl(iParticleID, 1, vIllusion)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	hCaster:SetAbsOrigin(vIllusion)
	hCaster:SetAngles(qIllusion[1], qIllusion[2], qIllusion[3])

	hIllusion:SetAbsOrigin(vCaster)
	hIllusion:SetAngles(qCaster[1], qCaster[2], qCaster[3])

	FindClearSpaceForUnit(hCaster, vIllusion, true)
	FindClearSpaceForUnit(hIllusion, vCaster, true)

	hCaster:AddNewModifier(hCaster, self, "modifier_lanaya_2_self_buff", nil)

	hCaster:EmitSound("Hero_TemplarAssassin.Refraction")
end
-------------------------------------------------------------------
if modifier_lanaya_2_attack == nil then
	modifier_lanaya_2_attack = class({}, nil, eom_modifier)
end
function modifier_lanaya_2_attack:IsHidden()
	return true
end
function modifier_lanaya_2_attack:IsDebuff()
	return false
end
function modifier_lanaya_2_attack:IsPurgable()
	return false
end
function modifier_lanaya_2_attack:IsPurgeException()
	return false
end
function modifier_lanaya_2_attack:IsStunDebuff()
	return false
end
function modifier_lanaya_2_attack:AllowIllusionDuplicate()
	return false
end
function modifier_lanaya_2_attack:OnCreated(params)
	self.pathway_damage = self:GetAbilitySpecialValueFor("pathway_damage")
end
function modifier_lanaya_2_attack:OnRefresh(params)
	self.pathway_damage = self:GetAbilitySpecialValueFor("pathway_damage")
end
function modifier_lanaya_2_attack:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end
function modifier_lanaya_2_attack:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	local hParent = self:GetParent()

	local tPhysicalDamageInfo = tAttackInfo.tDamageInfo[DAMAGE_TYPE_PHYSICAL]
	for _iDamageType, tDamageInfo in pairs(tAttackInfo.tDamageInfo) do
		if _iDamageType ~= DAMAGE_TYPE_PHYSICAL then
			tDamageInfo.damage = tDamageInfo.damage + tPhysicalDamageInfo.damage * self.pathway_damage*0.01
		end
	end
end
--------------------------------------------------------------
if modifier_lanaya_2_self_buff == nil then
	modifier_lanaya_2_self_buff = class({}, nil, eom_modifier)
end
function modifier_lanaya_2_self_buff:IsHidden()
	return false
end
function modifier_lanaya_2_self_buff:IsDebuff()
	return false
end
function modifier_lanaya_2_self_buff:IsPurgable()
	return false
end
function modifier_lanaya_2_self_buff:IsPurgeException()
	return false
end
function modifier_lanaya_2_self_buff:IsStunDebuff()
	return false
end
function modifier_lanaya_2_self_buff:AllowIllusionDuplicate()
	return false
end
function modifier_lanaya_2_self_buff:OnCreated(params)
	local hParent = self:GetParent()
	self.instances = self:GetAbilitySpecialValueFor("instances")
	if IsServer() then
		self:SetStackCount(self.instances)
	else
		local iParticleID = ParticleManager:CreateParticle('particles/econ/items/lanaya/ta_ti9_immortal_shoulders/ta_ti9_refraction.vpcf', PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControlEnt(iParticleID, 5, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), true)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_lanaya_2_self_buff:OnRefresh(params)
	self.instances = self:GetAbilitySpecialValueFor("instances")
	if IsServer() then
		self:SetStackCount(self.instances)
	end
end
function modifier_lanaya_2_self_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE,
	}
end
function modifier_lanaya_2_self_buff:GetModifierAvoidDamage(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if IsValid(params.attacker) and params.damage >= 0 and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS then
		local iParticleID = ParticleManager:CreateParticle(ParticleManager:GetParticleReplacement("particles/units/heroes/hero_templar_assassin/templar_assassin_refract_hit.vpcf", hCaster), PATTACH_CUSTOMORIGIN, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT, "attach_hitloc", hParent:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 1, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 1, (hParent:GetAbsOrigin() - params.attacker:GetAbsOrigin()):Normalized())
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_ABSORIGIN_FOLLOW, nil, hParent:GetAbsOrigin(), false)
		ParticleManager:ReleaseParticleIndex(iParticleID)

		hParent:EmitSound("Hero_TemplarAssassin.Refraction.Absorb")

		self:DecrementStackCount()
		if self:GetStackCount() <= 0 then
			self:Destroy()
		end
		return 1
	end
end
function modifier_lanaya_2_self_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_lanaya_2_self_buff:OnBattleEnd()
	self:Destroy()
end
