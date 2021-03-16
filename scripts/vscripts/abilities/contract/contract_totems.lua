LinkLuaModifier("modifier_contract_totems", "abilities/contract/contract_totems.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_contract_totems_buff", "abilities/contract/contract_totems.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if contract_totems == nil then
	contract_totems = class({})
end
function contract_totems:GetIntrinsicModifierName()
	return "modifier_contract_totems"
end
---------------------------------------------------------------------
--Modifiers
if modifier_contract_totems == nil then
	modifier_contract_totems = class({}, nil, eom_modifier)
end
function modifier_contract_totems:OnCreated(params)
	self.dmg_pct = self:GetAbilitySpecialValueFor("dmg_pct")

	self:SetHasCustomTransmitterData(true)
	self.iPhysicalAttack = 0
	self.iMagicalAttack = 0
	if IsServer() then
		self.tUnit = {}
		EachUnits(GetPlayerID(self:GetParent()), function(hUnit)
			table.insert(self.tUnit, hUnit)
			hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_contract_totems_buff", nil)
		end, UnitType.AllEnemies)
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_ambient_ti_5.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_attack1", self:GetParent():GetAbsOrigin(), false)
		ParticleManager:SetParticleControlEnt(iParticleID, 2, self:GetParent(), PATTACH_ABSORIGIN_FOLLOW, "", self:GetParent():GetAbsOrigin(), false)
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_contract_totems:OnRefresh(params)
	self.dmg_pct = self:GetAbilitySpecialValueFor("dmg_pct")
	if IsServer() then
	end
end
function modifier_contract_totems:OnDestroy()
	if IsServer() then
		for _, hUnit in ipairs(self.tUnit) do
			if IsValid(hUnit) and hUnit:HasModifier("modifier_contract_totems_buff") then
				hUnit:RemoveModifierByName("modifier_contract_totems_buff")
			end
		end
	end
end
function modifier_contract_totems:EDeclareFunctions()
	return {
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_SPAWNED, self.OnSpawned },
		[EMDF_EVENT_CUSTOM] = { ET_ENEMY.ON_DEATH, self.OnDeath },
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_MAGICAL_ATTACK_BONUS,
		[MODIFIER_EVENT_ON_ATTACK] = {self:GetParent()}
	}
end
function modifier_contract_totems:OnAttack(params)
	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/pugna/pugna_ward_ti5/pugna_ward_attack_medium_ti_5.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, params.attacker, PATTACH_POINT_FOLLOW, "attach_hitloc", params.attacker:GetAbsOrigin(), false)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, params.target, PATTACH_POINT_FOLLOW, "attach_hitloc", params.target:GetAbsOrigin(), false)
	ParticleManager:ReleaseParticleIndex(iParticleID)
end
function modifier_contract_totems:GetPhysicalAttackBonus()
	return self.iPhysicalAttack
end
function modifier_contract_totems:GetMagicalAttackBonus()
	return self.iMagicalAttack
end
function modifier_contract_totems:AddCustomTransmitterData()
	return {
		iPhysicalAttack = self.iPhysicalAttack,
		iMagicalAttack = self.iMagicalAttack
	}
end
function modifier_contract_totems:HandleCustomTransmitterData(tData)
	self.iPhysicalAttack = tData.iPhysicalAttack
	self.iMagicalAttack = tData.iMagicalAttack
end
function modifier_contract_totems:OnDeath(params)
	local hParent = self:GetParent()
	if params.PlayerID == GetPlayerID(hParent) then
		local hTarget = EntIndexToHScript(params.entindex_killed)
		self.iPhysicalAttack = self.iPhysicalAttack + hTarget:GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.dmg_pct * 0.01
		self.iMagicalAttack = self.iMagicalAttack + hTarget:GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.dmg_pct * 0.01
		self:ForceRefresh()
	end
end
function modifier_contract_totems:OnSpawned(params)
	if params.PlayerID == GetPlayerID(self:GetParent()) then
		table.insert(self.tUnit, params.hUnit)
		params.hUnit:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_contract_totems_buff", nil)
	end
end
---------------------------------------------------------------------
if modifier_contract_totems_buff == nil then
	modifier_contract_totems_buff = class({}, nil, eom_modifier)
end
function modifier_contract_totems_buff:OnCreated(params)
	self.bonus_atkspeed = self:GetAbilitySpecialValueFor("bonus_atkspeed")
	self.bonus_atk = self:GetAbilitySpecialValueFor("bonus_atk")
	self.bonus_helath = self:GetAbilitySpecialValueFor("bonus_helath")
	self.bonus_armor = self:GetAbilitySpecialValueFor("bonus_armor")

	if IsServer() then
	end
end
function modifier_contract_totems_buff:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_contract_totems_buff:OnDestroy()
	if IsServer() then
	end
end
function modifier_contract_totems_buff:EDeclareFunctions()
	return {
		[EMDF_ATTACKT_SPEED_BONUS_PERCENTAGE] = self.bonus_atkspeed,
		[EMDF_STATUS_HEALTH_BONUS_PERCENTAGE] = self.bonus_helath,
		[EMDF_MOVEMENT_SPEED_BONUS_PERCENTAGE] = self.bonus_atkspeed,
		[EMDF_MAGICAL_ARMOR_BONUS_PERCENTAGE] = self.bonus_armor,
		[EMDF_PHYSICAL_ARMOR_BONUS_PERCENTAGE] = self.bonus_armor,
	}
end