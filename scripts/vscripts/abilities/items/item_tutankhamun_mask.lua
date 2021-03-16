LinkLuaModifier("modifier_item_tutankhamun_mask", "abilities/items/item_tutankhamun_mask.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_tutankhamun_mask == nil then
	item_tutankhamun_mask = class({}, nil, base_ability_attribute)
end
function item_tutankhamun_mask:GetIntrinsicModifierName()
	return "modifier_item_tutankhamun_mask"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_tutankhamun_mask == nil then
	modifier_item_tutankhamun_mask = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_tutankhamun_mask:IsHidden()
	return true
end
function modifier_item_tutankhamun_mask:OnCreated(params)
	self.health_regen_pct = self:GetAbilitySpecialValueFor("health_regen_pct")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
		self.tTargets = {}
	end
end
function modifier_item_tutankhamun_mask:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_tutankhamun_mask:OnDestroy()
	if IsServer() then
	end
end
function modifier_item_tutankhamun_mask:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent() },
		[MODIFIER_EVENT_ON_ABILITY_EXECUTED] = { self:GetParent() }
	}
end
function modifier_item_tutankhamun_mask:OnTakeDamage(params)
	local hParent = self:GetParent()
	if hParent == params.unit and TableFindKey(self.tTargets, params.attacker) == nil then
		table.insert(self.tTargets, params.attacker)
	end
end
function modifier_item_tutankhamun_mask:OnAbilityExecuted(params)
	local hParent = self:GetParent()
	if params.unit == self:GetParent() and #self.tTargets > 0 then
		for _, hUnit in pairs(self.tTargets) do
			if IsValid(hUnit) and hUnit:IsAlive() then
				local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_bane/bane_sap.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, hUnit, PATTACH_POINT_FOLLOW, "attach_hitloc", hUnit:GetAbsOrigin(), false)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				hParent:DealDamage(hUnit, self:GetAbility(), 0)
			end
		end
		hParent:EmitSound("Hero_Bane.BrainSap")
		self.tTargets = {}
	end
	-- 恢复
	-- if self:GetAbility():GetLevel() >= self.unlock_level then
	-- 	hParent:Heal(hParent:GetMaxHealth() * self.health_regen_pct * 0.01, self:GetAbility())
	-- end
end
AbilityClassHook('item_tutankhamun_mask', getfenv(1), 'abilities/items/item_tutankhamun_mask.lua', { KeyValues.ItemsKv })