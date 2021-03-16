---天使遗物
LinkLuaModifier("modifier_angel_relics_buff", "abilities/items/item_angel_relics.lua", LUA_MODIFIER_MOTION_NONE)


if nil == item_angel_relics then
	item_angel_relics = class({}, nil, base_ability_attribute)
end
function item_angel_relics:GetIntrinsicModifierName()
	return "modifier_" .. self:GetName()
end
function item_angel_relics:Judge(hTarget)
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("range")
	local ori_damage_pct = self:GetSpecialValueFor("ori_damage_pct") * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) or 0
	local around_damage_pct = self:GetSpecialValueFor("around_damage_pct")
	hCaster:DealDamage(hTarget, self, ori_damage_pct)
	if IsValid(hCaster) and IsValid(hTarget) then
		hTarget:AddNewModifier(hCaster, self, "modifier_angel_relics_buff", { duration = self:GetSpecialValueFor('stun_duration') })
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		local fDamage = around_damage_pct * 0.01 * hCaster:GetVal(ATTRIBUTE_KIND.MagicalAttack) or 0
		hCaster:DealDamage(tTargets, self, fDamage)
	end
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_item_angel_relics then
	modifier_item_angel_relics = class({}, nil, modifier_base_ability_attribute)
end

function modifier_item_angel_relics:IsHidden()
	return true
end
function modifier_item_angel_relics:OnCreated(params)
	self:UpdateValues()
end

function modifier_item_angel_relics:OnRefresh(params)
	self:UpdateValues()
end
function modifier_item_angel_relics:UpdateValues(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.stun_duration = self:GetAbilitySpecialValueFor("stun_duration")
	self.range = self:GetAbilitySpecialValueFor("range")

end
function modifier_item_angel_relics:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT
	}
end
function modifier_item_angel_relics:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_angel_relics:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	-- if RollPercentage(self.chance) then
	if RollPercentage(self.chance) then
		local hAbility = self:GetAbility()
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/fire/item_angle_relics.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", Vector(self.range, 0, 0), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(self.range, self.range, self.range))
		hAbility:Judge(hTarget)
	end
end

---------------------------------------------------------------------
--Modifiers
if nil == modifier_angel_relics_buff then
	modifier_angel_relics_buff = class({}, nil, eom_modifier)
end

function modifier_angel_relics_buff:IsHidden()
	return true
end
function modifier_angel_relics_buff:OnCreated(params)
	self:UpdateValues()
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	if IsClient() then
	end
end

function modifier_angel_relics_buff:OnRefresh(params)
	self:UpdateValues()
end
function modifier_angel_relics_buff:UpdateValues(params)
	self.range = self:GetAbilitySpecialValueFor("range")
end
function modifier_angel_relics_buff:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true
	}
end


AbilityClassHook('item_angel_relics', getfenv(1), 'abilities/items/item_angel_relics.lua', { KeyValues.ItemsKv })