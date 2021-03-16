LinkLuaModifier("modifier_bounty_hunter_3_debuff", "abilities/tower/bounty_hunter/bounty_hunter_3.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if bounty_hunter_3 == nil then
	bounty_hunter_3 = class({ iBehavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET, iOrderType = FIND_CLOSEST }, nil, ability_base_ai)
end
function bounty_hunter_3:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	-- 标记特效
	local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hTarget:AddNewModifier(hCaster, self, "modifier_bounty_hunter_3_debuff", { duration = self:GetDuration() })
	-- 音效
	hCaster:EmitSound("Hero_BountyHunter.Target")
end
---------------------------------------------------------------------
--Modifiers
if modifier_bounty_hunter_3_debuff == nil then
	modifier_bounty_hunter_3_debuff = class({}, nil, eom_modifier)
end
function modifier_bounty_hunter_3_debuff:IsDebuff()
	return true
end
function modifier_bounty_hunter_3_debuff:OnCreated(params)
	self.armor_reduce_pct = self:GetAbilitySpecialValueFor("armor_reduce_pct")
	self.bounty = self:GetAbilitySpecialValueFor("bounty")
	if IsServer() then
		self.flHealthRecorder = self:GetParent():GetHealth()	-- 记录上次血量
		self.flDamageRecorder = 0	-- 记录伤害值
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_shield.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bounty_hunter/bounty_hunter_track_trail.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_bounty_hunter_3_debuff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = -self.armor_reduce_pct,
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = -self.armor_reduce_pct,
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_bounty_hunter_3_debuff:GetMagicalArmorBonusPercentage()
	return -self.armor_reduce_pct
end
function modifier_bounty_hunter_3_debuff:GetPhysicalArmorBonusPercentage()
	return -self.armor_reduce_pct
end
function modifier_bounty_hunter_3_debuff:OnTakeDamage(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	if hParent:IsGoldWave() then
		return
	end
	local damage = math.min(self.flHealthRecorder, params.damage)

	self.flDamageRecorder = self.flDamageRecorder + damage
	self.flHealthRecorder = hParent:GetHealth()
	if self.flDamageRecorder >= 0.01 * hParent:GetMaxHealth() then
		local iBounty = math.ceil(self.bounty * (self.flDamageRecorder / hParent:GetMaxHealth()))
		self.flDamageRecorder = 0
		if IsValid(hCaster) then
			-- PlayerData:ModifyGold(GetPlayerID(hCaster), iBounty
			PlayerData:DropGold(GetPlayerID(hCaster), self:GetParent():GetAbsOrigin(), iBounty)
		end
	end
end