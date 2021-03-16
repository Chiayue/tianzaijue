LinkLuaModifier("modifier_cmd_troll_2", "abilities/commander/cmd_troll/cmd_troll_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_troll_2_buff", "abilities/commander/cmd_troll/cmd_troll_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_cmd_troll_2_debuff", "abilities/commander/cmd_troll/cmd_troll_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if cmd_troll_2 == nil then
	cmd_troll_2 = class({})
end
function cmd_troll_2:GetIntrinsicModifierName()
	return "modifier_cmd_troll_2"
end
function cmd_troll_2:OnProjectileHit(hTarget, vLocation)
	local hCaster = self:GetCaster()
	local duration = self:GetSpecialValueFor('duration')
	local damage_factor = self:GetSpecialValueFor('damage_factor')
	if IsValid(hTarget) then
		if hTarget:GetTeamNumber() == self:GetCaster():GetTeamNumber() then
			-- 增益buff
			hCaster:AddNewModifier(hTarget, self, 'modifier_cmd_troll_2_buff', { duration = duration })
		else
			-- 减益buff
			local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack)
			local tDamage = {
				ability = self,
				attacker = hCaster,
				victim = hTarget,
				damage = flDamage * damage_factor * 0.01,
				damage_type = DAMAGE_TYPE_PHYSICAL
			}
			ApplyDamage(tDamage)
		end
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_cmd_troll_2 == nil then
	modifier_cmd_troll_2 = class({}, nil, eom_modifier)
end
function modifier_cmd_troll_2:IsHidden()
	return true
end
function modifier_cmd_troll_2:OnCreated(params)
	self.atktimes = 0
	self:UpdateValues()
end
function modifier_cmd_troll_2:OnRefresh(params)
	self:UpdateValues()
end
function modifier_cmd_troll_2:UpdateValues()
	self.attack_count = self:GetAbilitySpecialValueFor('attack_count')
	self.axe_count = self:GetAbilitySpecialValueFor('axe_count')
	self.duration = self:GetAbilitySpecialValueFor('duration')
end
function modifier_cmd_troll_2:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent(), nil },
	}
end
function modifier_cmd_troll_2:OnAttackLanded(params)
	if not IsValid(params.target) or params.target:GetClassname() == "dota_item_drop" then return end
	if params.attacker == self:GetParent() then
		self.atktimes =	self.atktimes + 1
		if self.atktimes >=	self.attack_count then
			-- 旋风飞斧
			local vDirection = params.target:GetAbsOrigin() - self:GetParent():GetAbsOrigin()
			vDirection.z = 0
			self:WhirlingAxe(self.duration, vDirection:Normalized())
			self:GetParent():EmitSound("Hero_TrollWarlord.WhirlingAxes.Melee")
			self:GetParent():StartGesture(ACT_DOTA_CAST_ABILITY_3)
			self.atktimes = 0
		end
	end

end
function modifier_cmd_troll_2:OnDestroy()
	-- 	if IsServer() then
	-- 	end
	-- end
end
function modifier_cmd_troll_2:WhirlingAxe(duration, direction)
	local hParent = self:GetParent()
	local vDir = direction or hCaster:GetForwardVector()
	local radius = 400
	local speed = 1600

	local flAngle = (self.axe_count - 1) * 20
	local tDirection = {}
	for i = 1, self.axe_count do
		table.insert(tDirection, RotatePosition(Vector(0, 0, 0), QAngle(0, -flAngle * 0.5 + (i - 1) * 20, 0), vDir))
	end
	for _, vDirection in ipairs(tDirection) do
		local info = {
			Ability = self:GetAbility(),
			Source = hParent,
			EffectName = "particles/units/heroes/hero_troll_warlord/troll_warlord_whirling_axe_ranged.vpcf",
			vSpawnOrigin = hParent:GetAbsOrigin(),
			vVelocity = vDirection:Normalized() * speed,
			fDistance = 2000,
			fStartRadius = 0,
			fEndRadius = 100,
			-- iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
			iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_BOTH,
			iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			iUnitTargetFlags = DOTA_UNIT_TARGET_FLAG_NONE,
			bProvidesVision = true
		}
		ProjectileManager:CreateLinearProjectile(info)
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_troll_2_buff == nil then
	modifier_cmd_troll_2_buff = class({}, nil, eom_modifier)
end
function modifier_cmd_troll_2_buff:OnCreated(params)
	self.atkspd_bonus = self:GetAbilitySpecialValueFor('atkspd_bonus')
	local hParent = self:GetParent()
	if IsClient() then
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_cmd_troll_2_buff:OnRefresh(params)
	self.atkspd_bonus = self:GetAbilitySpecialValueFor('atkspd_bonus')
end
function modifier_cmd_troll_2_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.atkspd_bonus
	}
end
function modifier_cmd_troll_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP,
	}
end
function modifier_cmd_troll_2_buff:OnTooltip()
	return self.atkspd_bonus
end
function modifier_cmd_troll_2_buff:GetAttackSpeedBonus()
	return	self.atkspd_bonus
end

---------------------------------------------------------------------
--Modifiers
if modifier_cmd_troll_2_debuff == nil then
	modifier_cmd_troll_2_debuff = class({}, nil, eom_modifier)
end
function modifier_cmd_troll_2_debuff:OnCreated(params)
	self.atkspd_pnish = self:GetAbilitySpecialValueFor('atkspd_pnish')
end
function modifier_cmd_troll_2_debuff:OnRefresh(params)
	self.atkspd_pnish = self:GetAbilitySpecialValueFor('atkspd_pnish')
end
function modifier_cmd_troll_2_debuff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = -self.atkspd_pnish
	}
end
function modifier_cmd_troll_2_debuff:GetAttackSpeedBonus()
	return	- self.atkspd_pnish
end