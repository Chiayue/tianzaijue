LinkLuaModifier("modifier_void_runner_2", "abilities/tower/void_runner/void_runner_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_void_runner_2_buff", "abilities/tower/void_runner/void_runner_2.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_runner_2 == nil then
	void_runner_2 = class({})
end
function void_runner_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	hTarget:AddNewModifier(hCaster, self, "modifier_void_runner_2_buff", { duration = self:GetDuration() })
	hCaster:AddNewModifier(hCaster, self, "modifier_void_runner_2_buff", { duration = self:GetDuration() })
	hCaster:EmitSound("Hero_Dark_Seer.Ion_Shield_Start")
end
function void_runner_2:GetIntrinsicModifierName()
	return "modifier_void_runner_2"
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_runner_2 == nil then
	modifier_void_runner_2 = class({}, nil, ModifierHidden)
end
function modifier_void_runner_2:OnCreated(params)
	if IsServer() then
		self:StartIntervalThink(0.5)
	end
end
function modifier_void_runner_2:OnIntervalThink()
	if IsServer() then
		if self:GetParent():IsIllusion() then
			self:StartIntervalThink(-1)
			return
		end
		local hParent = self:GetParent()
		local hAbility = self:GetAbility()
		if hAbility:IsAbilityReady() then
			local tTargets = {}
			EachUnits(GetPlayerID(hParent), function(hUnit)
				if hUnit:IsAlive() and hUnit ~= hParent then
					table.insert(tTargets, hUnit)
				end
			end, UnitType.AllFirends)
			local hUnit = #tTargets == 0 and hParent or RandomValue(tTargets)
			hParent:PassiveCast(hAbility, DOTA_UNIT_ORDER_CAST_TARGET, { hTarget = hUnit })
		end
	end
end
---------------------------------------------------------------------
if modifier_void_runner_2_buff == nil then
	modifier_void_runner_2_buff = class({}, nil, eom_modifier)
end
function modifier_void_runner_2_buff:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.mana_regen_pct = self:GetAbilitySpecialValueFor("mana_regen_pct")
	if IsServer() then
		self:StartIntervalThink(1)
		self:GetParent():EmitSound("Hero_Dark_Seer.Ion_Shield_lp")
	else
		local hParent = self:GetParent()
		local flRadius = hParent:GetModelRadius()
		local iParticleID = ParticleManager:CreateParticle("particles/units/heroes/hero_dark_seer/dark_seer_ion_shell.vpcf", PATTACH_CUSTOMORIGIN, nil)
		ParticleManager:SetParticleControlEnt(iParticleID, 0, hParent, PATTACH_POINT_FOLLOW, "attach_hitloc", hParent:GetAbsOrigin(), false)
		ParticleManager:SetParticleControl(iParticleID, 1, Vector(flRadius, flRadius, flRadius))
		self:AddParticle(iParticleID, false, false, -1, false, false)
	end
end
function modifier_void_runner_2_buff:OnDestroy()
	if IsServer() then
		self:GetParent():EmitSound("Hero_Dark_Seer.Ion_Shield_end")
		self:GetParent():StopSound("Hero_Dark_Seer.Ion_Shield_lp")
	end
end
function modifier_void_runner_2_buff:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if not IsValid(hParent) or not IsValid(hAbility) or not IsValid(self:GetCaster()) then
		self:Destroy()
		return
	end
	local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
	if IsValid(tTargets) then
		self:GetCaster():DealDamage(tTargets, hAbility)
	end
end
function modifier_void_runner_2_buff:EDeclareFunctions()
	return {
		[EMDF_MANA_REGEN_PERCENTAGE] = self.mana_regen_pct
	}
end
function modifier_void_runner_2_buff:GetManaRegenPercentage()
	return self.mana_regen_pct
end
function modifier_void_runner_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_void_runner_2_buff:OnTooltip()
	return self.mana_regen_pct
end