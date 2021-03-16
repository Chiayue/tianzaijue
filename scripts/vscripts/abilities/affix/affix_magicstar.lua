LinkLuaModifier("modifier_affix_magicstar", "abilities/consumable/affix_magicstar.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_affix_magicstar_buff", "abilities/consumable/affix_magicstar.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if affix_magicstar == nil then
	affix_magicstar = class({})
end
function affix_magicstar:GetIntrinsicModifierName()
	return "modifier_affix_magicstar"
end
---------------------------------------------------------------------
--Modifiers
if modifier_affix_magicstar == nil then
	modifier_affix_magicstar = class({}, nil, eom_modifier)
end
function modifier_affix_magicstar:OnCreated(params)
	if IsServer() then
		local hCaster = self:GetCaster()
		self.tModifiers = {}
		self:StartIntervalThink(1)
	end
end
function modifier_affix_magicstar:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_affix_magicstar:OnDestroy()
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_affix_magicstar:OnIntervalThink()
	if IsServer() then
		if IsValid(self:GetAbility()) then
			local hCaster = self:GetCaster()
			local iPlayerID = GetPlayerID(self:GetParent())
			EachUnits(iPlayerID, function(hUnit)
				if not hUnit:HasModifier("modifier_affix_magicstar_buff") then
					table.insert(self.tModifiers, hUnit:AddNewModifier(hCaster, self:GetAbility(), "modifier_affix_magicstar_buff", nil))
				end
			end, UnitType.Building)
		end
	end
end
function modifier_affix_magicstar:EDeclareFunctions()
	return {
	}
end

---------------------------------------------------------------------
--Modifiers
if modifier_affix_magicstar_buff == nil then
	modifier_affix_magicstar_buff = class({}, nil, eom_modifier)
end
function modifier_affix_magicstar_buff:OnCreated(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.radius = self:GetAbilitySpecialValueFor('radius')
	self.attack_pct = self:GetAbilitySpecialValueFor('attack_pct')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_affix_magicstar_buff:OnRefresh(params)
	self.interval = self:GetAbilitySpecialValueFor('interval')
	self.radius = self:GetAbilitySpecialValueFor('radius')
	self.attack_pct = self:GetAbilitySpecialValueFor('attack_pct')
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_affix_magicstar_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_affix_magicstar_buff:EDeclareFunctions()
	return {

	}
end
function modifier_affix_magicstar_buff:OnIntervalThink()
	local iPlayerID = GetPlayerID(self:GetParent())
	if iPlayerID ~= nil then
		local targets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), Vector(0, 0, 0), nil, -1, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 0, 0, false)
		for i = #targets, 1, -1 do
			local tDamage = {
				ability = self:GetAbility(),
				attacker = self:GetParent(),
				victim = targets[i],
				damage = (self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack) + self:GetParent():GetVal(ATTRIBUTE_KIND.MagicalAttack)) * self.attack_pct * 0.01,
				damage_type = DAMAGE_TYPE_PURE
			}
			ApplyDamage(tDamage)
		end
	end
end

function modifier_affix_magicstar_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_affix_magicstar_buff:OnTooltip()
	return self.chance
end