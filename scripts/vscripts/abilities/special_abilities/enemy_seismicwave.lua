LinkLuaModifier("modifier_enemy_seismicwave", "abilities/special_abilities/enemy_seismicwave.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_seismicwave_buff", "abilities/special_abilities/enemy_seismicwave.lua", LUA_MODIFIER_MOTION_NONE)
--践踏
if enemy_seismicwave == nil then
	enemy_seismicwave = class({})
end
function enemy_seismicwave:GetIntrinsicModifierName()
	return "modifier_enemy_seismicwave"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_seismicwave == nil then
	modifier_enemy_seismicwave = class({}, nil, eom_modifier)
end
function modifier_enemy_seismicwave:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
	end
end
function modifier_enemy_seismicwave:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
	end
end
function modifier_enemy_seismicwave:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_seismicwave:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end

function modifier_enemy_seismicwave:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end
	if IsServer() and RollPercentage(self.chance) then
		local hParent = self:GetParent()
		local hability = self:GetAbility()
		local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), hParent:GetAbsOrigin(), nil, self.range, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_FOW_VISIBLE + DOTA_UNIT_TARGET_FLAG_NO_INVIS, FIND_CLOSEST, false)
		-- local fDamage = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack) or self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
		local phyDamage = self:GetParent():GetVal(ATTRIBUTE_KIND.PhysicalAttack)
		local magDamage = self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)
		local fDamage = (phyDamage > 0 and phyDamage) or magDamage

		for _, hTarget in ipairs(targets) do
			local tDamage = {
				ability = hAbility,
				attacker = hParent,
				victim = hTarget,
				damage = fDamage * self.damage_factor,
				damage_type = DAMAGE_TYPE_MAGICAL
			}
			hTarget:AddBuff(hParent, BUFF_TYPE.STUN, self.duration)
			ApplyDamage(tDamage)
		end
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_enemy_seismicwave_buff", { duration = self.duration or 0 })
		hParent:EmitSound("Hero_Brewmaster.ThunderClap")
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_seismicwave_buff == nil then
	modifier_enemy_seismicwave_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_seismicwave_buff:OnCreated(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	local hParent = self:GetParent()
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/enemy/enemy_seismicwave.vpcf", PATTACH_ABSORIGIN, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.range, 0, 0))

	end
end
function modifier_enemy_seismicwave_buff:OnRefresh(params)
	self.range = self:GetAbilitySpecialValueFor("range")
	self.damage_factor = self:GetAbilitySpecialValueFor("damage_factor")
	if IsServer() then
	end
end
function modifier_enemy_seismicwave_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_seismicwave_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
	}
end