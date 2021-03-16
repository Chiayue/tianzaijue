LinkLuaModifier("modifier_enemy_healthrecovery", "abilities/special_abilities/enemy_healthrecovery.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_healthrecovery_buff", "abilities/special_abilities/enemy_healthrecovery.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_healthrecovery == nil then
	enemy_healthrecovery = class({})
end
function enemy_healthrecovery:GetIntrinsicModifierName()
	return "modifier_enemy_healthrecovery"
end
function enemy_healthrecovery:OnSpellStart()
	local hCaster = self:GetCaster()
	if IsValid(hCaster) and not hCaster:HasModifier("modifier_enemy_healthrecovery_buff") then
		hCaster:AddNewModifier(hCaster, self, "modifier_enemy_healthrecovery_buff", { duration = self:GetChannelTime() })
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_healthrecovery_buff == nil then
	modifier_enemy_healthrecovery_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_healthrecovery_buff:OnCreated(params)
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/units/boss/kingkong/kingkong_4.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_enemy_healthrecovery_buff:OnRefresh(params)
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_enemy_healthrecovery_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_healthrecovery_buff:OnIntervalThink()
	if IsServer() then
		self:GetParent():Heal(self.heal_pct * self:GetParent():GetMaxHealth() * 0.01, self)
	end
end
function modifier_enemy_healthrecovery_buff:CheckState()
	return {
		[MODIFIER_STATE_ROOTED] = true,
	}
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_healthrecovery == nil then
	modifier_enemy_healthrecovery = class({}, nil, eom_modifier)
end
function modifier_enemy_healthrecovery:OnCreated(params)
	self.health_triggle = self:GetAbilitySpecialValueFor("health_triggle")
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.bHeal = true
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_healthrecovery:OnRefresh(params)
	self.health_triggle = self:GetAbilitySpecialValueFor("health_triggle")
	self.heal_pct = self:GetAbilitySpecialValueFor("heal_pct")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_enemy_healthrecovery:OnDestroy()
	if IsServer() then
	end
end
-- function modifier_enemy_healthrecovery:EDeclareFunctions()
-- 	-- return {
-- 	-- 	[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
-- 	-- }
-- end
function modifier_enemy_healthrecovery:OnIntervalThink()
	if IsServer() and IsValid(self:GetParent()) then
		local hParent = self:GetParent()
		local fHealth = hParent:GetHealth()
		local fMaxHealth = hParent:GetMaxHealth()
		if fHealth * 100 / fMaxHealth <= self.health_triggle and self.bHeal then
			self.bHeal = false
			-- self:GetParent():RemoveModifierByName("modifier_enemy_ai")
			ExecuteOrderFromTable({
				UnitIndex = self:GetParent():entindex(),
				OrderType = DOTA_UNIT_ORDER_CAST_NO_TARGET,
				AbilityIndex = self:GetAbility():entindex(),
			})
		end
	end
end
function modifier_enemy_healthrecovery:IsHidden()
	return true
end