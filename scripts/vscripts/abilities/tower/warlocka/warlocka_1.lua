LinkLuaModifier("modifier_warlockA_fatal_bonds", "abilities/tower/warlockA/warlockA_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if warlockA_1 == nil then
	warlockA_1 = class({}, nil, ability_base_ai)
end
function warlockA_1:FatalBonds(hTarget, tHashtable)
	local hCaster = self:GetCaster()
	local bond_count = self:GetSpecialValueFor("bond_count")
	local search_aoe = self:GetSpecialValueFor("search_aoe")
	local duration = self:GetSpecialValueFor("duration")

	table.insert(tHashtable, hTarget)

	hTarget:AddNewModifier(hCaster, self, "modifier_warlockA_fatal_bonds", {duration=duration, hashtable_index=GetHashtableIndex(tHashtable)})

	if #tHashtable < bond_count then
		local iTeamFilter = self:GetAbilityTargetTeam()
		local iTypeFilter = self:GetAbilityTargetType()
		local iFlagsFilter = self:GetAbilityTargetFlags() + DOTA_UNIT_TARGET_FLAG_NO_INVIS
		local iOrder = FIND_CLOSEST
		local tTargets = FindUnitsInRadius(hCaster:GetTeamNumber(), hTarget:GetAbsOrigin(), nil, search_aoe, iTeamFilter, iTypeFilter, iFlagsFilter, iOrder, false)
		for _, _hTarget in pairs(tTargets) do
			if TableFindKey(tHashtable, _hTarget) == nil then
				local iParticleID = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_pulse_flame.vpcf", PATTACH_CUSTOMORIGIN, nil)
				ParticleManager:SetParticleControlEnt(iParticleID, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
				ParticleManager:SetParticleControlEnt(iParticleID, 1, _hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", _hTarget:GetAbsOrigin(), true)
				ParticleManager:ReleaseParticleIndex(iParticleID)
				self:FatalBonds(_hTarget, tHashtable)
				break
			end
		end
	end
end
function warlockA_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()

	local iParticleID = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_cast.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, hCaster, PATTACH_POINT_FOLLOW, "attach_attack1", hCaster:GetAbsOrigin(), true)
	ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
	ParticleManager:ReleaseParticleIndex(iParticleID)

	self:FatalBonds(hTarget, CreateHashtable())

	hCaster:EmitSound("Hero_Warlock.FatalBonds")
end

---------------------------------------------------------------------
--Modifiers
if modifier_warlockA_fatal_bonds == nil then
	modifier_warlockA_fatal_bonds = class({}, nil, eom_modifier)
end
function modifier_warlockA_fatal_bonds:IsHidden()
	return false
end
function modifier_warlockA_fatal_bonds:IsDebuff()
	return true
end
function modifier_warlockA_fatal_bonds:IsPurgable()
	return true
end
function modifier_warlockA_fatal_bonds:IsPurgeException()
	return true
end
function modifier_warlockA_fatal_bonds:IsStunDebuff()
	return false
end
function modifier_warlockA_fatal_bonds:AllowIllusionDuplicate()
	return false
end
function modifier_warlockA_fatal_bonds:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE
end
function modifier_warlockA_fatal_bonds:ShouldUseOverheadOffset()
	return true
end
function modifier_warlockA_fatal_bonds:CheckPrimary()
	local hParent = self:GetParent()
	if IsServer() then
		if self.tHashtable[1] == hParent then
			if self.iParticleID == nil then
				self.iParticleID = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti9/warlock_ti9_shadow_word_debuff.vpcf", PATTACH_ABSORIGIN_FOLLOW, hParent)
				self:AddParticle(self.iParticleID, false, false, -1, false, false)
			end
		else
			if self.iParticleID ~= nil then
				ParticleManager:DestroyParticle(self.iParticleID, false)
				self.iParticleID = nil
			end
		end
	end
end
function modifier_warlockA_fatal_bonds:OnCreated(params)
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self.damage_giving = self:GetAbilitySpecialValueFor("damage_giving")

	if IsServer() then
		self.tHashtable = GetHashtableByIndex(params.hashtable_index)
		if self.tHashtable == nil then
			self:Destroy()
			return
		end
		self:CheckPrimary()
	else
		local iParticleID = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_icon.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
		self:AddParticle(iParticleID, false, false, -1, false, true)
	end
end
function modifier_warlockA_fatal_bonds:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		ArrayRemove(self.tHashtable, hParent)
		if #self.tHashtable == 0 then
			RemoveHashtable(self.tHashtable)
		else
			for _, hTarget in pairs(self.tHashtable) do
				local tModifiers = hTarget:FindAllModifiersByName("modifier_warlockA_fatal_bonds")
				for k, hModifier in pairs(tModifiers) do
					hModifier:CheckPrimary()
				end
			end
		end
	end
end
function modifier_warlockA_fatal_bonds:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_TAKEDAMAGE] = {nil, self:GetParent()}
	}
end
function modifier_warlockA_fatal_bonds:OnTakeDamage(params)
	local hAbility = self:GetAbility()
	local hCaster = self:GetCaster()
	local hParent = self:GetParent()
	self:CheckPrimary()
	if params.unit == hParent and self.iParticleID ~= nil and params.original_damage > 0 and bit.band(params.damage_flags, DOTA_DAMAGE_FLAG_FATAL_BOND) ~= DOTA_DAMAGE_FLAG_FATAL_BOND then
		local hSource = IsValid(hCaster) and hCaster or params.attacker
		local hSourceAbility = IsValid(hAbility) and hAbility or params.inflictor
		local fDamage = params.original_damage * self.damage_giving*0.01
		for i = #self.tHashtable, 1, -1 do
			local hTarget = self.tHashtable[i]
			if IsValid(hTarget) then
				if hTarget ~= hParent then
					local iParticleID = ParticleManager:CreateParticle("particles/econ/items/warlock/warlock_ti10_head/warlock_ti_10_fatal_bonds_pulse.vpcf", PATTACH_CUSTOMORIGIN, nil)
					ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), true)
					ParticleManager:SetParticleControlEnt(iParticleID, 1, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true)
					ParticleManager:ReleaseParticleIndex(iParticleID)

					EmitSoundOnLocationWithCaster(hTarget:GetAbsOrigin(), "Hero_Warlock.FatalBondsDamage", hSource)

					hSource:DealDamage(hTarget, hSourceAbility, fDamage, params.damage_type, params.damage_flags+DOTA_DAMAGE_FLAG_FATAL_BOND)
				end
			else
				table.remove(self.tHashtable, i)
			end
		end
	end
end
function modifier_warlockA_fatal_bonds:DeclareFunctions()
	return{
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_warlockA_fatal_bonds:OnTooltip()
	return self.damage_giving
end