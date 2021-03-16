LinkLuaModifier("modifier_void_runner_1_buff", "abilities/tower/void_runner/void_runner_1.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if void_runner_1 == nil then
	local funcSortFunction = function(a, b)
		return a:GetVal(ATTRIBUTE_KIND.StatusMana) > b:GetVal(ATTRIBUTE_KIND.StatusMana)
	end
	local funcUnitsCallback = function(self, tTargets)
		ArrayRemove(tTargets, Commander:GetCommander(GetPlayerID(self:GetCaster())))
	end
	void_runner_1 = class({ funcSortFunction = funcSortFunction, funcUnitsCallback = funcUnitsCallback }, nil, ability_base_ai)
end
function void_runner_1:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local hIllusion = CreateIllusion(hTarget, hTarget:GetAbsOrigin(), true, hCaster, hCaster, hCaster:GetTeamNumber(), self:GetDuration(), self:GetSpecialValueFor("damage_pct"), 100)
	if IsValid(hIllusion) then
		hIllusion:SetControllableByPlayer(-1, false)
		hIllusion:AddNewModifier(hCaster, self, "modifier_void_runner_1_buff", { duration = self:GetDuration() })
		hIllusion:AddNewModifier(hCaster, nil, "modifier_building_ai", nil)
		hIllusion:GiveMana(hIllusion:GetVal(ATTRIBUTE_KIND.StatusMana))
		hIllusion:SetAcquisitionRange(3000)
	end
	hCaster:AddNewModifier(hCaster, self, "modifier_void_runner_1_buff", { duration = self:GetDuration() })
end
---------------------------------------------------------------------
--Modifiers
if modifier_void_runner_1_buff == nil then
	modifier_void_runner_1_buff = class({}, nil, eom_modifier)
end
function modifier_void_runner_1_buff:OnCreated(params)
	self.mana_cost = self:GetAbilitySpecialValueFor("mana_cost")
	self.damage_per_mana = self:GetAbilitySpecialValueFor("damage_per_mana")
	if IsServer() then
		self.distance = self:GetAbility():GetCastRange(vec3_invalid, nil)
		self:StartIntervalThink(0.5)
	end
end
function modifier_void_runner_1_buff:EDeclareFunctions()
	return {
		[MODIFIER_EVENT_ON_ATTACK_LANDED] = { self:GetParent() },
	}
end
function modifier_void_runner_1_buff:OnAttackLanded(params)
	local hParent = self:GetParent()
	local hCaster = self:GetCaster()
	local flManaSpent = math.min(self.mana_cost * hParent:GetVal(ATTRIBUTE_KIND.StatusMana) * 0.01, hParent:GetMana())
	hParent:SpendMana(flManaSpent, self:GetAbility())
	local flDamage = flManaSpent * self.damage_per_mana * hParent:GetVal(ATTRIBUTE_KIND.MagicalAttack) * 0.01
	hParent:DealDamage(params.target, self:GetAbility(), flDamage)
	if hParent:GetMana() == 0 and hParent ~= hCaster then
		self:Destroy()
	end
end
function modifier_void_runner_1_buff:OnDestroy()
	if IsServer() then
		local hParent = self:GetParent()
		local hCaster = self:GetCaster()
		if IsValid(hCaster) and IsValid(hParent) then
			if self:GetCaster():HasModifier("modifier_void_runner_3") and self:GetCaster() ~= hParent then
				self:GetCaster():FindAbilityByName("void_runner_3"):OnSpellStart(hParent:GetAbsOrigin(), hParent:GetVal(ATTRIBUTE_KIND.StatusMana))
			end
			if hParent:IsIllusion() then
				hParent:ForceKill(false)
			end
		end
	end
end