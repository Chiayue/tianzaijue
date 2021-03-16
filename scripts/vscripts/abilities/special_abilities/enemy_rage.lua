LinkLuaModifier("modifier_enemy_rage", "abilities/special_abilities/enemy_rage.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_rage_buff", "abilities/special_abilities/enemy_rage.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_rage == nil then
	enemy_rage = class({})
end
function enemy_rage:GetIntrinsicModifierName()
	return "modifier_enemy_rage"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_rage == nil then
	modifier_enemy_rage = class({})
end
function modifier_enemy_rage:OnCreated(params)
	self.health_trigger_pct = self:GetAbilitySpecialValueFor("health_trigger_pct")
	self.movespeed_bonus = self:GetAbilitySpecialValueFor("movespeed_bonus")
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_enemy_rage:OnRefresh(params)
	self.health_trigger_pct = self:GetAbilitySpecialValueFor("health_trigger_pct")
	self.movespeed_bonus = self:GetAbilitySpecialValueFor("movespeed_bonus")
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsServer() then
	end
end
function modifier_enemy_rage:OnDestroy()
	if IsServer() then
	end
end
function modifier_enemy_rage:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if IsServer() then
		if hAbility and hParent then
			local hHealth = hParent:GetHealth()
			local hMaxHealth = hParent:GetMaxHealth()
			local healthPct = hHealth * 100 / hMaxHealth
			if math.floor(healthPct) <= self.health_trigger_pct and not self:GetParent():HasModifier("modifier_enemy_rage_buff") then
				hParent:AddNewModifier(hParent, hAbility, "modifier_enemy_rage_buff", {})
			end
		end
	end
end
function modifier_enemy_rage:DeclareFunctions()
	return {
	}
end

---------------------------------------------------------------------
--Modifiers
if modifier_enemy_rage_buff == nil then
	modifier_enemy_rage_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_rage_buff:OnCreated(params)
	self.health_trigger_pct = self:GetAbilitySpecialValueFor("health_trigger_pct")
	self.movespeed_bonus = self:GetAbilitySpecialValueFor("movespeed_bonus")
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsServer() then
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/lifestealer/lifestealer_immortal_backbone/lifestealer_immortal_backbone_rage.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		-- ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		-- ParticleManager:SetParticleControlEnt(iParticleID, 3, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 2, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 3, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_enemy_rage_buff:OnCreated(params)
	self.health_trigger_pct = self:GetAbilitySpecialValueFor("health_trigger_pct")
	self.movespeed_bonus = self:GetAbilitySpecialValueFor("movespeed_bonus")
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsServer() then
	end
end
function modifier_enemy_rage_buff:OnDestroy()
	self.health_trigger_pct = self:GetAbilitySpecialValueFor("health_trigger_pct")
	self.movespeed_bonus = self:GetAbilitySpecialValueFor("movespeed_bonus")
	self.armor_bonus_pct = self:GetAbilitySpecialValueFor("armor_bonus_pct")
	self.attack_bonus_pct = self:GetAbilitySpecialValueFor("attack_bonus_pct")
	if IsServer() then
	end
end

function modifier_enemy_rage_buff:EDeclareFunctions()
	return {
		[EMDF_MAGICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
		[EMDF_PHYSICAL_ATTACK_BONUS_PERCENTAGE] = self.attack_bonus_pct,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = self.movespeed_bonus,
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = self.armor_bonus_pct,
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = self.armor_bonus_pct,
	}
end