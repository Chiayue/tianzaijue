LinkLuaModifier("modifier_grimstrokeA_2_chain", "abilities/tower/grimstrokeA/grimstrokeA_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_grimstrokeA_2_chain_link", "abilities/tower/grimstrokeA/grimstrokeA_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if grimstrokeA_2 == nil then
	grimstrokeA_2 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, iOrderType = FIND_CLOSEST }, nil, ability_base_ai)
end
function grimstrokeA_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_grimstrokeA_2_chain", { duration = self:GetDuration() })
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_proc.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack2", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_attack2", hTarget:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Grimstroke.SoulChain.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_grimstrokeA_2_chain == nil then
	modifier_grimstrokeA_2_chain = class({}, nil, ModifierDebuff)
end
function modifier_grimstrokeA_2_chain:OnCreated(params)
	self.distance = self:GetAbilitySpecialValueFor("distance")
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
		self:StartIntervalThink(0)
	else
		-- 特效
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_grimstrokeA_2_chain:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_grimstrokeA_2_chain:OnTakeDamage(params)
	if IsServer() and
	params.unit == self:GetParent() and
	bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and
	bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and
	IsValid(self.hTarget) and
	self.hTarget:IsAlive() then
		params.attacker:DealDamage(self.hTarget, self:GetAbility(), params.original_damage * self.damage_pct * 0.01, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION + DOTA_DAMAGE_FLAG_IGNORES_BASE_PHYSICAL_ARMOR)
	end
end
function modifier_grimstrokeA_2_chain:OnIntervalThink()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local tTargets = FindUnitsInRadiusWithAbility(hCaster, hParent:GetAbsOrigin(), self.distance, self:GetAbility(), FIND_CLOSEST)
	ArrayRemove(tTargets, hParent)
	table.insert(tTargets, hParent)
	if IsValid(tTargets[1]) then
		hParent:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetRemainingTime())
		tTargets[1]:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetRemainingTime())
		tTargets[1]:AddNewModifier(hParent, self:GetAbility(), "modifier_grimstrokeA_2_chain_link", { duration = self:GetRemainingTime() })
		self.hTarget = tTargets[1]
		self:StartIntervalThink(-1)
		return
	end
end
---------------------------------------------------------------------
if modifier_grimstrokeA_2_chain_link == nil then
	modifier_grimstrokeA_2_chain_link = class({}, nil, ModifierDebuff)
end
function modifier_grimstrokeA_2_chain_link:OnCreated(params)
	self.damage_pct = self:GetAbilitySpecialValueFor("damage_pct")
	if IsServer() then
	else
		-- 特效
		local hCaster = self:GetCaster()
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain.vpcf", PATTACH_ABSORIGIN_FOLLOW, hCaster)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_hitloc", hCaster:GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 1, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_grimstroke/grimstroke_soulchain_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
	AddModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_grimstrokeA_2_chain_link:OnDestroy()
	RemoveModifierEvents(MODIFIER_EVENT_ON_TAKEDAMAGE, self, nil, self:GetParent())
end
function modifier_grimstrokeA_2_chain_link:OnTakeDamage(params)
	if IsServer() and
	params.unit == self:GetParent() and
	bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_REFLECTION) ~= DOTA_DAMAGE_FLAG_REFLECTION and
	bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_HPLOSS) ~= DOTA_DAMAGE_FLAG_HPLOSS and
	IsValid(self:GetCaster()) and
	self:GetCaster():IsAlive() then
		params.attacker:DealDamage(self:GetCaster(), self:GetAbility(), params.damage * self.damage_pct * 0.01, params.damage_type, params.damage_flags + DOTA_DAMAGE_FLAG_REFLECTION)
	end
end