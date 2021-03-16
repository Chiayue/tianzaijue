LinkLuaModifier("modifier_dark_willow_2", "abilities/tower/dark_willow/dark_willow_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_willow_2_buff", "abilities/tower/dark_willow/dark_willow_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if dark_willow_2 == nil then
	dark_willow_2 = class({})
end
function dark_willow_2:OnSpellStart()
	local hCaster = self:GetCaster()
	hCaster:StartGesture(ACT_DOTA_CAST_ABILITY_2)
	hCaster:AddNewModifier(hCaster, self, "modifier_dark_willow_2_buff", { duration = self:GetDuration() })
end
function dark_willow_2:GetIntrinsicModifierName()
	return "modifier_dark_willow_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_dark_willow_2 == nil then
	modifier_dark_willow_2 = class({}, nil, ModifierHidden)
end
---------------------------------------------------------------------
if modifier_dark_willow_2_buff == nil then
	modifier_dark_willow_2_buff = class({}, nil, eom_modifier)
end
function modifier_dark_willow_2_buff:OnCreated(params)
	self.attackspeed = self:GetAbilitySpecialValueFor("attackspeed")
	self.attackrange = self:GetAbilitySpecialValueFor("attackrange")
	self.bonus_damage = self:GetAbilitySpecialValueFor("bonus_damage")
	if IsServer() then
		self:GetParent():EmitSound("Hero_DarkWillow.Shadow_Realm")
	else
		local iParticleID = ParticleManager:CreateParticle("particles/status_fx/status_effect_dark_willow_shadow_realm.vpcf", PATTACH_INVALID, self:GetParent())
		self:AddParticle(iParticleID, false, true, -1, false, false)
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_willow/dark_willow_shadow_realm.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_dark_willow_2_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_dark_willow_2_buff:OnDestroy()
	if IsServer() then
		self:GetParent():StopSound("Hero_DarkWillow.Shadow_Realm")
	end
end
function modifier_dark_willow_2_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = self.attackspeed,
		[EMDF_ATTACK_RANGE_BONUS] = self.attackrange,
		EMDF_ATTACKT_PROJECTILE,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_dark_willow_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TRANSLATE_ATTACK_SOUND
	}
end
function modifier_dark_willow_2_buff:CheckState()
	return {
		[MODIFIER_STATE_ATTACK_IMMUNE] = true,
		[MODIFIER_STATE_UNTARGETABLE] = true,
	}
end
function modifier_dark_willow_2_buff:GetAttackSpeedBonus()
	return self.attackspeed
end
function modifier_dark_willow_2_buff:GetAttackRangeBonus()
	return self.attackrange
end
function modifier_dark_willow_2_buff:GetAttackProjectile()
	return "particles/units/heroes/hero_dark_willow/dark_willow_shadow_attack.vpcf"
end
function modifier_dark_willow_2_buff:GetAttackSound()
	return "Hero_DarkWillow.Shadow_Realm.Attack"
end
function modifier_dark_willow_2_buff:OnAttackLanded(params)
	params.attacker:DealDamage(params.target, self:GetAbility(), self.bonus_damage * 0.01 * self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack))
	SendOverheadEventMessage(nil, OVERHEAD_ALERT_BONUS_SPELL_DAMAGE, params.target, self.bonus_damage, params.attacker)
end