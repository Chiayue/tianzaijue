LinkLuaModifier("modifier_item_light_fingertips", "abilities/items/item_light_fingertips.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_light_fingertips_attack", "abilities/items/item_light_fingertips.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--闪电指套
if item_light_fingertips == nil then
	item_light_fingertips = class({}, nil, base_ability_attribute)
end
function item_light_fingertips:GetIntrinsicModifierName()
	return "modifier_item_light_fingertips"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_light_fingertips == nil then
	modifier_item_light_fingertips = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_light_fingertips:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_light_fingertips:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	if IsServer() then
	end
end
function modifier_item_light_fingertips:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_light_fingertips:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK] = { self:GetParent() },
	}
end

function modifier_item_light_fingertips:OnAttack(params)
	if params.attacker ~= self:GetParent() or params.target == nil or params.target:GetClassname() == "dota_item_drop" then
		return
	end
	if params.attacker:AttackFilter(params.record, ATTACK_STATE_NO_EXTENDATTACK, ATTACK_STATE_SKIPCOUNTING) then
		return
	end

	if RollPercentage(self.chance) then
		if params.target and not self:GetParent():HasModifier("modifier_item_light_fingertips_attack") then
			self:GetParent():AddNewModifier(params.target, self:GetAbility(), "modifier_item_light_fingertips_attack", {})
			-- params.attacker:Attack(params.target, ATTACK_STATE_SKIPCOOLDOWN + ATTACK_STATE_NO_EXTENDATTACK)
		end
	end
end

---------------------------------------------------------------------
--Modifiers
if modifier_item_light_fingertips_attack == nil then
	modifier_item_light_fingertips_attack = class({}, nil, eom_modifier)
end
function modifier_item_light_fingertips_attack:OnCreated(params)
	self.icount = 1
	if IsServer() then
	end
end
function modifier_item_light_fingertips_attack:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS] = 1500,
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() }
	}
end
function modifier_item_light_fingertips_attack:OnAttackLanded(params)
	-- if self.icount ~= 1 then
	self:Destroy()
	-- end
	-- self.icount = 1 + self.icount
end
AbilityClassHook('item_light_fingertips', getfenv(1), 'abilities/items/item_light_fingertips.lua', { KeyValues.ItemsKv })