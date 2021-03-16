LinkLuaModifier("modifier_naturecaller_1_root", "abilities/tower/naturecaller/naturecaller_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_naturecaller_1_tree", "abilities/tower/naturecaller/naturecaller_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tree_buff", "abilities/tower/naturecaller/naturecaller_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_naturecaller_summon_buff", "abilities/tower/naturecaller/naturecaller_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_naturecaller_summon_attribute", "abilities/tower/naturecaller/naturecaller_1.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_naturecaller_2_rain", "abilities/tower/naturecaller/naturecaller_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--自然呼唤者
if naturecaller_1 == nil then
	naturecaller_1 = class({}, nil, ability_base_ai)
end
function naturecaller_1:OnSpellStart()
	self.cast_range =	self:GetSpecialValueFor('cast_range')
	self.duration = self:GetSpecialValueFor('duration')

	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	if IsValid(hTarget) and not hTarget:HasModifier('modifier_naturecaller_1_root') then
		--给怪物上缠绕buff，和扣血buff
		hTarget:AddNewModifier(hCaster, self, 'modifier_naturecaller_1_root', { duration = self.duration })
		hTarget:AddBuff(hTarget, BUFF_TYPE.ROOT, self.duration)
		--召唤树人
		local hSummon = CreateUnitByName('naturecaller_summon', Vector(0, 0, 0), false, hCaster, hCaster, hCaster:GetTeamNumber())
		FindClearSpaceForUnit(hSummon, hTarget:GetAbsOrigin(), true)
		hSummon:FireSummonned(hCaster)
		--注册属性
		Attributes:Register(hSummon)
		--树人上buff
		hSummon:AddNewModifier(hCaster, self, 'modifier_naturecaller_summon_buff', { duration = 8 })
		--给树人属性强化
		hSummon:AddNewModifier(hCaster, self, 'modifier_naturecaller_summon_attribute', { iLevel = self:GetLevel() })

	end

end

---------------------------------------------------------------------
--Modifiers
--缠绕状态
if modifier_naturecaller_1_root == nil then
	modifier_naturecaller_1_root = class({}, nil, eom_modifier)
end
function modifier_naturecaller_1_root:OnCreated(params)
	self.damage_perseconds_pct = self:GetAbilitySpecialValueFor("damage_perseconds_pct")
	if IsClient() then
		local hParent = self:GetParent()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/dark_willow/dark_willow_chakram_immortal/dark_willow_chakram_immortal_bramble_root.vpcf", PATTACH_CENTER_FOLLOW, hParent)
		ParticleManager:SetParticleControl(iParticleID, 0, hParent:GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	else
		self:StartIntervalThink(1)
	end
end
function modifier_naturecaller_1_root:IsHidden()
	return true
end
function modifier_naturecaller_1_root:OnDestroy()
	return
end
function modifier_naturecaller_1_root:OnRefresh(params)
	self.damage_perseconds_pct = self:GetAbilitySpecialValueFor("damage_perseconds_pct")
end
function modifier_naturecaller_1_root:OnIntervalThink()
	if not self:GetParent() then
		self:Destroy()
	end
	if IsValid(self:GetParent()) and self:GetParent():IsAlive() then
		self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self.damage_perseconds_pct * 0.01 * self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack))
	end
end

---------------------------------------------------------------------
--树人带的buff,树人死后召唤树
if modifier_naturecaller_summon_buff == nil then
	modifier_naturecaller_summon_buff = class({}, nil, eom_modifier)
end

function modifier_naturecaller_summon_buff:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		self.hTree = CreateModifierThinker(self:GetCaster(), self:GetAbility(), "modifier_naturecaller_1_tree", nil, hParent:GetAbsOrigin(), self:GetCaster():GetTeamNumber(), true)
	end
end
function modifier_naturecaller_summon_buff:IsHidden()
	return true
end
function modifier_naturecaller_summon_buff:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
		MODIFIER_EVENT_ON_DEATH
	}
end
function modifier_naturecaller_summon_buff:OnDestroy()
	if IsServer() and self:GetParent() then
		self:GetParent():ForceKill(false)
		-- UTIL_Remove(self:GetParent())
	end
end
function modifier_naturecaller_summon_buff:OnDeath(params)
	if params.unit == self:GetParent() then
		self:GetParent():ForceKill(false)
	end
end
function modifier_naturecaller_summon_buff:OnBattleEnd()
	if IsServer() and self:GetParent() then
		self:GetParent():ForceKill(false)
		-- UTIL_Remove(self:GetParent())
	end
end
function modifier_naturecaller_summon_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
---------------------------------------------------------------------
---树的光环
if modifier_naturecaller_1_tree == nil then
	modifier_naturecaller_1_tree = class({}, nil, eom_modifier)
end
function modifier_naturecaller_1_tree:IsHidden()
	return true
end
function modifier_naturecaller_1_tree:IsDebuff()
	return false
end
function modifier_naturecaller_1_tree:IsPurgable()
	return false
end
function modifier_naturecaller_1_tree:IsPurgeException()
	return false
end
function modifier_naturecaller_1_tree:IsStunDebuff()
	return false
end
function modifier_naturecaller_1_tree:AllowIllusionDuplicate()
	return false
end
function modifier_naturecaller_1_tree:IsAura()
	return true
end
function modifier_naturecaller_1_tree:GetAuraRadius()
	return self.radius
end
function modifier_naturecaller_1_tree:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end
function modifier_naturecaller_1_tree:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC
end
function modifier_naturecaller_1_tree:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end
function modifier_naturecaller_1_tree:GetModifierAura()
	return 'modifier_tree_buff'
end
function modifier_naturecaller_1_tree:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("tree_affect_aura")
	local hCaster = self:GetCaster()
	if IsServer() then
		local hCaster = self:GetAbility():GetCaster()
		local hAbility = hCaster:FindAbilityByName('naturecaller_2')
		if hAbility and hAbility:GetLevel() > 0 then
			self:GetParent():AddNewModifier(hCaster, hAbility, "modifier_naturecaller_2_rain", { duration = self.duration })
		end
	else
		local iParticle = ParticleManager:CreateParticle("particles/units/heroes/naturecaller/naturecaller_1_aura.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticle, 7, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticle, false, false, -1, false, false)
		-- local iParticle = ParticleManager:CreateParticle("particles/units/heroes/naturecaller/naturecaller_1.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		-- ParticleManager:SetParticleControl(iParticle, 1, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticle, false, false, -1, false, false)
	end
end
function modifier_naturecaller_1_tree:OnRefresh(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	if IsServer() then
	end
end

function modifier_naturecaller_1_tree:OnDestroy(params)
	if IsServer() then
		if IsValid(self:GetParent()) then
			self:GetParent():RemoveSelf()
		end
	end
end
function modifier_naturecaller_1_tree:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_naturecaller_1_tree:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END,
	}
end
function modifier_naturecaller_1_tree:OnBattleEnd()
	if IsServer() then
		self:Destroy()
	end
end
------------------------------------
---树给队友buff
if modifier_tree_buff == nil then
	modifier_tree_buff = class({}, nil, eom_modifier)
end
function modifier_tree_buff:OnCreated(params)
	self.tree_attack_bonus = self:GetAbilitySpecialValueFor("tree_attack_bonus")
	self.tree_recover_perseconds = self:GetAbilitySpecialValueFor("tree_recover_perseconds")

	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticle = ParticleManager:CreateParticle("particles/econ/items/pangolier/pangolier_ti8_immortal/pangolier_ti8_immortal_shield_buff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticle, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticle, false, false, 1, false, false)
	end
end
function modifier_tree_buff:OnRefresh(params)
	self.tree_attack_bonus = self:GetAbilitySpecialValueFor("tree_attack_bonus")
	self.tree_recover_perseconds = self:GetAbilitySpecialValueFor("tree_recover_perseconds")
	if IsServer() then
	end
end
function modifier_tree_buff:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_tree_buff:OnIntervalThink()
	local hCaster = self:GetCaster()
	if hCaster then
		local hAbility = hCaster:FindAbilityByName('naturecaller_2')
		if hAbility and hAbility:GetLevel() > 0 then
			self:GetParent():Heal(self.tree_recover_perseconds, self)
		end
	end
end

function modifier_tree_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS] = self.tree_attack_bonus,
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.tree_attack_bonus,
	}
end
function modifier_tree_buff:GetMagicalAttackBonus()
	return self.tree_attack_bonus
end
function modifier_tree_buff:GetPhysicalAttackBonus()
	return self.tree_attack_bonus
end
function modifier_tree_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_tree_buff:OnTooltip()
	return self.tree_attack_bonus
end
------------------------------------
---树人的成长
if modifier_naturecaller_summon_attribute == nil then
	modifier_naturecaller_summon_attribute = class({}, nil, eom_modifier)
end
function modifier_naturecaller_summon_attribute:OnCreated(params)
	if IsServer() then
		self.iLevel = params.iLevel
		self:SetStackCount(self.iLevel)
	end
end
function modifier_naturecaller_summon_attribute:OnRefresh(params)
	if IsServer() then
		self.iLevel = params.iLevel
		self:SetStackCount(self.iLevel)
	end
end
function modifier_naturecaller_summon_attribute:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_naturecaller_summon_attribute:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE,
		EMDF_STATUS_HEALTH_BONUS_PERCENTAGE,
	}
end
function modifier_naturecaller_summon_attribute:GetPhysicalAttackBonusPercentage()
	return 80 * self:GetStackCount()
end
function modifier_naturecaller_summon_attribute:GetStatusHealthBonusPercentage()
	return 80 * self:GetStackCount()
end
-- function modifier_tree_buff:OnTooltip()-- 	return self.physical_armor_bonus-- end-- function modifier_tree_buff:OnTooltip2()-- 	return self.pura_damage_bonus-- en