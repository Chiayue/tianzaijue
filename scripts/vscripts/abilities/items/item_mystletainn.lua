LinkLuaModifier("modifier_item_mystletainn", "abilities/items/item_mystletainn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mystletainn_buff", "abilities/items/item_mystletainn.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_mystletainn_crit", "abilities/items/item_mystletainn.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_mystletainn == nil then
	item_mystletainn = class({})
end
function item_mystletainn:GetIntrinsicModifierName()
	return "modifier_item_mystletainn"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_mystletainn == nil then
	modifier_item_mystletainn = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_mystletainn:OnCreated(params)
	self.health_absorb = self:GetAbilitySpecialValueFor("health_absorb")
	self.attack_per_health = self:GetAbilitySpecialValueFor("attack_per_health")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.critical_per_attack = self:GetAbilitySpecialValueFor("critical_per_attack")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end
function modifier_item_mystletainn:IsHidden()
	return true
end
function modifier_item_mystletainn:OnRefresh(params)
	self.health_absorb = self:GetAbilitySpecialValueFor("health_absorb")
	self.attack_per_health = self:GetAbilitySpecialValueFor("attack_per_health")
	self.duration = self:GetAbilitySpecialValueFor("duration")
	self.critical_per_attack = self:GetAbilitySpecialValueFor("critical_per_attack")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
	end
end
function modifier_item_mystletainn:OnIntervalThink()
	local hParent = self:GetParent()
	if GSManager:getStateType() == GS_Battle and
	hParent:GetHealthPercent() > self.health_absorb then
		local iHealthCost = hParent:GetMaxHealth() * self.health_absorb * 0.01 * 0.1
		-- hParent:ModifyHealth(hParent:GetHealth() - iHealthCost, self:GetAbility(), false, 0)
		-- hParent:SetHealth(hParent:GetHealth() - iHealthCost)
		local tDamage = {
			ability = self,
			attacker = hParent,
			victim = hParent,
			damage = iHealthCost,
			damage_type = DAMAGE_TYPE_PURE
		}
		ApplyDamage(tDamage)
		hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_mystletainn_buff", { duration = self.duration, iStackCount = math.ceil(self.attack_per_health * iHealthCost) })
		-- self:IncrementStackCount(self.attack_per_health * iHealthCost)
		if self:GetAbility():GetLevel() >= self.unlock_level then
			self:IncrementStackCount()
			if self:GetStackCount() >= self.critical_per_attack * 10 then
				self:SetStackCount(0)
				hParent:AddNewModifier(hParent, self:GetAbility(), "modifier_item_mystletainn_crit", nil)
			end
		end
	end
end
function modifier_item_mystletainn:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_TOOLTIP
	}
end
function modifier_item_mystletainn:OnTooltip()
	return self.attack_per_health * self:GetParent():GetMaxHealth() * self.health_absorb * 0.01
end
---------------------------------------------------------------------
if modifier_item_mystletainn_buff == nil then
	modifier_item_mystletainn_buff = class({}, nil, eom_modifier)
end
function modifier_item_mystletainn_buff:IsHidden()
	-- return true
end
function modifier_item_mystletainn_buff:OnCreated(params)
	if IsServer() then
		self.tData = {
			{
				flDieTime = self:GetDieTime(),
				iStackCount = params.iStackCount
			}
		}
		self:IncrementStackCount(params.iStackCount)
		self:StartIntervalThink(0)
	end
end
function modifier_item_mystletainn_buff:OnRefresh(params)
	if IsServer() then
		table.insert(self.tData, {
			flDieTime = self:GetDieTime(),
			iStackCount = params.iStackCount
		})
		self:IncrementStackCount(params.iStackCount)
	end
end
function modifier_item_mystletainn_buff:OnIntervalThink()
	local flTime = GameRules:GetGameTime()
	for i = #self.tData, 1, -1 do
		if self.tData[i].flDieTime < flTime then
			self:DecrementStackCount(self.tData[i].iStackCount)
			table.remove(self.tData, i)
		end
	end
end
function modifier_item_mystletainn_buff:EDeclareFunctions()
	return {
		EMDF_PHYSICAL_ATTACK_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
	-- EMDF_EVENT_ON_ATTACK_RECORD_DESTROY
	}
end
function modifier_item_mystletainn_buff:GetPhysicalAttackBonus()
	return self:GetStackCount()
end
function modifier_item_mystletainn_buff:OnBattleEnd()
	self:Destroy()
end
-- function modifier_item_mystletainn_buff:OnCustomAttackRecordDestroy()
-- 	self:Destroy()
-- end
---------------------------------------------------------------------
if modifier_item_mystletainn_crit == nil then
	modifier_item_mystletainn_crit = class({}, nil, eom_modifier)
end
function modifier_item_mystletainn_crit:IsHidden()
	return true
end
function modifier_item_mystletainn_crit:OnCreated(params)
	self.critical_mult = self:GetAbilitySpecialValueFor("critical_mult")
end
function modifier_item_mystletainn_crit:EDeclareFunctions()
	return {
		EMDF_ATTACK_CRIT_BONUS,
		EMDF_EVENT_ON_BATTLEING_END,
		EMDF_EVENT_ON_ATTACK_RECORD_CREATE,
		EMDF_EVENT_ON_ATTACK_RECORD_DESTROY
	}
end
function modifier_item_mystletainn_crit:GetAttackCritBonus()
	return self.critical_mult * 100, 100
end
function modifier_item_mystletainn_crit:OnBattleEnd()
	self:Destroy()
end
function modifier_item_mystletainn_crit:OnCustomAttackRecordCreate(tAttackInfo)
	self.record = tAttackInfo.record
end
function modifier_item_mystletainn_crit:OnCustomAttackRecordDestroy(tAttackInfo)
	if tAttackInfo.record == self.record then
		self:Destroy()
	end
end