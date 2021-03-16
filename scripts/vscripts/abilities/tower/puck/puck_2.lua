LinkLuaModifier("modifier_puck_2", "abilities/tower/puck/puck_2.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_puck_2_buff", "abilities/tower/puck/puck_2.lua", LUA_MODIFIER_MOTION_NONE)

if puck_2 == nil then
	puck_2 = class({})
end
function puck_2:OnAbility1Hit(hTarget)
	local hCaster = self:GetCaster()
	if IsValid(hCaster) and self:GetLevel() > 0 then
		if IsValid(hTarget) and hTarget:IsAlive() and hTarget.GetMana and hTarget:GetMana() > 0 then
			local hit_absorb_mana = self:GetSpecialValueFor("hit_absorb_mana")
			local fMana = math.min(hTarget:GetMana(), hit_absorb_mana)
			hCaster:GiveMana(fMana)
			hTarget:ReduceMana(fMana)
		end
	end
end
function puck_2:GetIntrinsicModifierName()
	return "modifier_puck_2"
end

------------------------------------------------------------------------------
if modifier_puck_2 == nil then
	modifier_puck_2 = class({}, nil, BaseModifier)
end
function modifier_puck_2:OnCreated(params)
	if IsServer() then
		self.tModifiers = {}
		self:StartIntervalThink(1)
	end
end
function modifier_puck_2:OnRefresh(params)
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_puck_2:OnDestroy(params)
	if IsServer() then
		for k, h in pairs(self.tModifiers) do
			if IsValid(h) then
				h:Destroy()
			end
		end
	end
end
function modifier_puck_2:OnIntervalThink()
	if IsServer() then
		local hParent = self:GetParent()
		if self:GetAbility():GetLevel() > 0 and IsValid(hParent) then
			local iPlayerID = GetPlayerID(hParent)
			if - 1 ~= iPlayerID then
				EachUnits(iPlayerID, function(hUnit)
					self.tModifiers[hUnit:entindex()] = hUnit:AddNewModifier(hParent, self:GetAbility(), "modifier_puck_2_buff", {})
				end, UnitType.AllFirends)
			end
		end
	end
end
function modifier_puck_2:IsHidden()
	return true
end

------------------------------------------------------------------------------
if modifier_puck_2_buff == nil then
	modifier_puck_2_buff = class({}, nil, eom_modifier)
end
function modifier_puck_2_buff:OnCreated(params)
	self.bonus_maximum_mana = self:GetAbilitySpecialValueFor("bonus_maximum_mana")
end
function modifier_puck_2_buff:OnRefresh(params)
	self.bonus_maximum_mana = self:GetAbilitySpecialValueFor("bonus_maximum_mana")
end
function modifier_puck_2_buff:EDeclareFunctions()
	return {
		[EMDF_STATUS_MANA_BONUS] = self:GetStatusManaBonus(),
	}
end
function modifier_puck_2_buff:GetStatusManaBonus()
	local hParent = self:GetParent()
	if hParent == self:GetCaster() then
		return self.bonus_maximum_mana * 2
	else
		return self.bonus_maximum_mana
	end
end
function modifier_puck_2_buff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_puck_2_buff:OnTooltip()
	local hParent = self:GetParent()
	if hParent == self:GetCaster() then
		return self.bonus_maximum_mana * 2
	else
		return self.bonus_maximum_mana
	end
end