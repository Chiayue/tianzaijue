LinkLuaModifier("modifier_enemy_reborn", "abilities/special_abilities/enemy_reborn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_enemy_reborn_buff", "abilities/special_abilities/enemy_reborn.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if enemy_reborn == nil then
	enemy_reborn = class({})
end
function enemy_reborn:GetIntrinsicModifierName()
	return "modifier_enemy_reborn"
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_reborn == nil then
	modifier_enemy_reborn = class({}, nil, eom_modifier)
end
function modifier_enemy_reborn:OnCreated(params)
	self.unlock_times = self:GetAbilitySpecialValueFor("unlock_times")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
		self:SetStackCount(0)
		-- self:GetParent():SetModel("models/heroes/phoenix/phoenix_egg.vmdl")
	end
end
function modifier_enemy_reborn:OnRefresh(params)
	self.unlock_times = self:GetAbilitySpecialValueFor("unlock_times")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	if IsServer() then
	end
end
function modifier_enemy_reborn:OnDestroy()
	if IsServer() then
	end
end

function modifier_enemy_reborn:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_AVOID_DAMAGE
	}
end
function modifier_enemy_reborn:GetModifierAvoidDamage(params)
	if params.damage >= self:GetParent():GetHealth() and self:GetStackCount() == 0 then
		self:IncrementStackCount()
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_enemy_reborn_buff", { duration =	self.duration })
		return 1
	end
end
---------------------------------------------------------------------
--Modifiers
if modifier_enemy_reborn_buff == nil then
	modifier_enemy_reborn_buff = class({}, nil, eom_modifier)
end
function modifier_enemy_reborn_buff:OnCreated(params)
	self.unlock_times = self:GetAbilitySpecialValueFor("unlock_times")
	if IsServer() then
		self:SetStackCount(	self.unlock_times)
		self:GetParent():SetHealth(self.unlock_times + 1)
		-- self:GetParent():SetModel("models/heroes/phoenix/phoenix_egg.vmdl")
	end
end
function modifier_enemy_reborn_buff:OnRefresh(params)
	self.unlock_times = self:GetAbilitySpecialValueFor("unlock_times")
	if IsServer() then
	end
end
function modifier_enemy_reborn_buff:OnDestroy()
	if IsServer() then
		if self:GetStackCount() > 0 then
			local iParticleIDD = ParticleManager:CreateParticle("particles/econ/items/monkey_king/arcana/death/monkey_king_spring_arcana_death.vpcf", PATTACH_ABSORIGIN, self:GetParent())

			ParticleManager:SetParticleControl(iParticleIDD, 0, self:GetParent():GetAbsOrigin())
			ParticleManager:SetParticleControl(iParticleIDD, 1, Vector(250, 250, 250))
			ParticleManager:SetParticleControl(iParticleIDD, 2, Vector(250, 250, 250))
			self:GetCaster():Heal(self:GetCaster():GetMaxHealth(), self)
		else
			local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_supernova_death.vpcf", PATTACH_CUSTOMORIGIN, nil)
			ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		end
	end
end
function modifier_enemy_reborn_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_enemy_reborn_buff:OnTooltip()
	return self:GetStackCount()
end
function modifier_enemy_reborn_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() }
	}
end
function modifier_enemy_reborn_buff:GetModifierModelChange()
	return "models/heroes/phoenix/phoenix_egg.vmdl"
end
function modifier_enemy_reborn_buff:CheckState()
	return {
		[MODIFIER_STATE_NO_HEALTH_BAR] = true,
		[MODIFIER_STATE_SILENCED] = true,
		[MODIFIER_STATE_ROOTED] = true,
		[MODIFIER_STATE_STUNNED] = true,
	-- [MODIFIER_STATE_INVULNERABLE] = true,
	}
end
function modifier_enemy_reborn_buff:GetModifierIncomingDamage_Percentage(params)

	if IsServer() then

		if params.damage > 0 and params.attacker ~= self:GetParent() then
			if IsServer() and self:GetStackCount() > 0 then

				self:DecrementStackCount()
				return -100
			else
				-- return -100
				self:Destroy()
			end
		end

	end
end