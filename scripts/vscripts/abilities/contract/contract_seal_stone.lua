LinkLuaModifier("modifier_contract_seal_stone", "abilities/contract/contract_seal_stone.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_seal_stone == nil then
	contract_seal_stone = class({}, nil, ability_base_ai)
end
function contract_seal_stone:Precache(context)
	PrecacheResource("particle", "particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf", context)
end
function contract_seal_stone:OnSpellStart()
	local hCaster = self:GetCaster()
	local hero_count = self:GetSpecialValueFor("hero_count")
	local duration = self:GetDuration()

	local tTargets = {}
	EachUnits(GetPlayerID(hCaster), function(hUnit)
		if hUnit:IsAlive() then
			table.insert(tTargets, hUnit)
		end
	end, UnitType.Building)
	for i = 1, hero_count do
		local hUnit = RandomValue(tTargets)
		if IsValid(hUnit) then
			ArrayRemove(tTargets, hUnit)
			hUnit:AddNewModifier(hCaster, self, "modifier_contract_seal_stone", { duration = duration })
		end
	end
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/silencer/silencer_ti6/silencer_last_word_status_cast_ti6.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hCaster, PATTACH_POINT, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 2, hCaster, PATTACH_POINT, "attach_attack1", hCaster:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
	hCaster:EmitSound("Hero_Silencer.LastWord.Cast")
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_seal_stone == nil then
	modifier_contract_seal_stone = class({}, nil, eom_modifier)
end
function modifier_contract_seal_stone:OnCreated(params)
	self.hp_pct = self:GetAbilitySpecialValueFor("hp_pct")
	if IsServer() then
		self:StartIntervalThink(1)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/bane/bane_fall20_immortal/bane_fall20_immortal_grip.vpcf", PATTACH_ABSORIGIN, self:GetParent())
		ParticleManager:SetParticleControl(iParticleID, 0, self:GetParent():GetAbsOrigin())
		ParticleManager:SetParticleControl(iParticleID, 1, self:GetParent():GetAbsOrigin())
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_contract_seal_stone:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_contract_seal_stone:OnIntervalThink()
	self:GetCaster():DealDamage(self:GetParent(), self:GetAbility(), self:GetParent():GetVal(ATTRIBUTE_KIND.StatusHealth) * self.hp_pct * 0.01)
end
function modifier_contract_seal_stone:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION
	}
end
function modifier_contract_seal_stone:GetOverrideAnimation()
	return ACT_DOTA_FLAIL
end
function modifier_contract_seal_stone:CheckState()
	return {
		[MODIFIER_STATE_STUNNED] = true,
	}
end