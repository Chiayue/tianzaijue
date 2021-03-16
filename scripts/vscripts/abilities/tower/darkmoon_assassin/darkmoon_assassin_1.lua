LinkLuaModifier("modifier_darkmoon_assassin_1_hide", "abilities/tower/darkmoon_assassin/darkmoon_assassin_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_darkmoon_assassin_1_buff", "abilities/tower/darkmoon_assassin/darkmoon_assassin_1.lua", LUA_MODIFIER_MOTION_NONE)

if darkmoon_assassin_1 == nil then
	darkmoon_assassin_1 = class({ iOrderType = FIND_FARTHEST }, nil, ability_base_ai)
end
function darkmoon_assassin_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local dagger_speed = self:GetSpecialValueFor("dagger_speed")

	local tInfo =	{
		Ability = self,
		EffectName = "particles/units/heroes/darkmoon_assassin/darkmoon_assassin_stifling_dagger_arcana_1.vpcf",
		iSourceAttachment = hCaster:ScriptLookupAttachment("attach_attack2"),
		iMoveSpeed = dagger_speed,
		Target = hTarget,
		Source = hCaster,
	}
	ProjectileManager:CreateTrackingProjectile(tInfo)
	-- 隐藏
	hCaster:AddNewModifier(hCaster, self, "modifier_darkmoon_assassin_1_hide", nil)
	-- sound
	hCaster:EmitSound("Hero_PhantomAssassin.Dagger.Cast")
	-- 二技能
	local hAbility = hCaster:FindAbilityByName("darkmoon_assassin_2")
	if hAbility:GetLevel() > 0 and hAbility:IsCooldownReady() and hAbility:IsOwnersManaEnough() then
		hAbility:UseResources(true, false, true)
		hAbility:OnSpellStart()
	end
end
function darkmoon_assassin_1:OnProjectileHit_ExtraData(hTarget, vLocation)
	local hCaster = self:GetCaster()
	FindClearSpaceForUnit(hCaster, vLocation - CalculateDirection(hCaster, vLocation) * (hCaster:GetHullRadius() + (hTarget and hTarget:GetHullRadius() or 0)), true)
	hCaster:RemoveModifierByName("modifier_darkmoon_assassin_1_hide")
	hCaster:AddNewModifier(hCaster, self, "modifier_darkmoon_assassin_1_buff", { duration = self:GetDuration() })
	if hTarget ~= nil then
		-- particle
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/phantom_assassin/phantom_assassin_arcana_elder_smith/phantom_assassin_crit_impact_dagger_arcana.vpcf", PATTACH_CUSTOMORIGIN, hTarget)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
		ParticleManager:SetParticleControl(iParticleID, 1, hTarget:GetAbsOrigin())
		ParticleManager:SetParticleControlForward(iParticleID, 1, (hCaster:GetAbsOrigin() - vLocation):Normalized())
		ParticleManager:ReleaseParticleIndex(iParticleID)
		-- sound
		EmitSoundOnLocationWithCaster(vLocation, "Hero_PhantomAssassin.Dagger.Target", hCaster)
		-- 现身
		hCaster:SetForwardVector(CalculateDirection(hTarget, hCaster))
		hCaster:SetAttackTarget(hTarget)
		hCaster:EmitSound("Hero_PhantomAssassin.Strike.End")
		-- damage
		hCaster:Attack(hTarget, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NOT_USEPROJECTILE)
		local flDamage = hCaster:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self:GetSpecialValueFor("pure_factor") * 0.01
		local hAbility = hCaster:FindAbilityByName("darkmoon_assassin_3")
		if IsValid(hAbility) and hAbility:GetLevel() > 0 then
			flDamage = hAbility:GetCritValue(flDamage)
		end
		hCaster:DealDamage(hTarget, self, flDamage)
	end
end
---------------------------------------------------------------------
if modifier_darkmoon_assassin_1_hide == nil then
	modifier_darkmoon_assassin_1_hide = class({}, nil, ModifierHidden)
end
function modifier_darkmoon_assassin_1_hide:OnCreated(params)
	if IsServer() then
		self:GetParent():AddNoDraw()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_start.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_darkmoon_assassin_1_hide:OnDestroy()
	if IsServer() then
		self:GetParent():RemoveNoDraw()
		self:GetParent():StartGesture(ACT_DOTA_SPAWN)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phantom_assassin/phantom_assassin_phantom_strike_end.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		-- ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_darkmoon_assassin_1_hide:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
		[MODIFIER_STATE_OUT_OF_GAME] = true,
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_UNSELECTABLE] = true,
		[MODIFIER_STATE_NOT_ON_MINIMAP] = true,
		[MODIFIER_STATE_INVULNERABLE] = true,
	}
end
---------------------------------------------------------------------
if modifier_darkmoon_assassin_1_buff == nil then
	modifier_darkmoon_assassin_1_buff = class({}, nil, eom_modifier)
end
function modifier_darkmoon_assassin_1_buff:OnCreated(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor("crit_damage_pct")
	self.attackspeed_pct = self:GetAbilitySpecialValueFor("attackspeed_pct")
end
function modifier_darkmoon_assassin_1_buff:OnRefresh(params)
	self.crit_chance = self:GetAbilitySpecialValueFor("crit_chance")
	self.crit_damage_pct = self:GetAbilitySpecialValueFor("crit_damage_pct")
	self.attackspeed_pct = self:GetAbilitySpecialValueFor("attackspeed_pct")
end
function modifier_darkmoon_assassin_1_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.attackspeed_pct,
		EMDF_ATTACK_CRIT_BONUS,
	}
end
function modifier_darkmoon_assassin_1_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_darkmoon_assassin_1_buff:OnTooltip()
	return self.attackspeed_pct
end
function modifier_darkmoon_assassin_1_buff:GetAttackSpeedPercentage(params)
	return self.attackspeed_pct
end
function modifier_darkmoon_assassin_1_buff:GetAttackCritBonus(params)
	return	self.crit_damage_pct, self.crit_chance
end