LinkLuaModifier("modifier_item_book_of_betrayal", "abilities/items/item_book_of_betrayal.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_book_of_betrayal_buff", "abilities/items/item_book_of_betrayal.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_book_of_betrayal == nil then
	item_book_of_betrayal = class({})
end
function item_book_of_betrayal:GetIntrinsicModifierName()
	return "modifier_item_book_of_betrayal"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_book_of_betrayal == nil then
	modifier_item_book_of_betrayal = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_book_of_betrayal:OnCreated(params)
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then
		self.tCharm = {}
	end
end
function modifier_item_book_of_betrayal:OnRefresh(params)
	self.max_count = self:GetAbilitySpecialValueFor("max_count")
	self.trigger_pct = self:GetAbilitySpecialValueFor("trigger_pct")
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	if IsServer() then

	end
end
function modifier_item_book_of_betrayal:OnDestroy()
	if IsServer() then
		for i, hUnit in ipairs(self.tCharm) do
			if IsValid(hUnit) then
				hUnit:ForceKill(false)
			end
		end
	end
end
function modifier_item_book_of_betrayal:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_ATTACK_HIT,
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_item_book_of_betrayal:OnAttackHit(hTarget, tAttackInfo, ExtraData, vLocation)
	if tAttackInfo.attacker ~= self:GetParent() then return end
	if not IsValid(hTarget) then return end
	if IsAttackMiss(tAttackInfo) then return end

	if hTarget:IsBoss() or
	hTarget:IsAncient() or
	hTarget:IsGoldWave() or
	hTarget:GetUnitLabel() == "elite" or
	Spawner:IsMobsRound() then
		return
	elseif hTarget:GetHealthPercent() <= self.trigger_pct and #self.tCharm < self.max_count then
		Spawner:Charm(self:GetParent(), hTarget, self:GetAbility())
		if self:GetAbility():GetLevel() >= self.unlock_level then
			hTarget:AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_item_book_of_betrayal_buff", nil)
		end
		table.insert(self.tCharm, hTarget)
		hTarget:EmitSound("Hero_Chen.HolyPersuasionEnemy")
	end
end
function modifier_item_book_of_betrayal:OnBattleEnd()
	for i, hUnit in ipairs(self.tCharm) do
		if IsValid(hUnit) then
			hUnit:ForceKill(false)
		end
	end
	self.tCharm = {}
end
---------------------------------------------------------------------
if modifier_item_book_of_betrayal_buff == nil then
	modifier_item_book_of_betrayal_buff = class({}, nil, eom_modifier)
end
function modifier_item_book_of_betrayal_buff:OnCreated(params)
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	self.fPhyAtk = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.bonus_damage_pct * 0.01
	self.fMgcAtk = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.bonus_damage_pct * 0.01
end
function modifier_item_book_of_betrayal_buff:OnRefresh(params)
	self.bonus_damage_pct = self:GetAbilitySpecialValueFor("bonus_damage_pct")
	self.fPhyAtk = self:GetCaster():GetVal(ATTRIBUTE_KIND.PhysicalAttack) * self.bonus_damage_pct * 0.01
	self.fMgcAtk = self:GetCaster():GetVal(ATTRIBUTE_KIND.MagicalAttack) * self.bonus_damage_pct * 0.01
end
function modifier_item_book_of_betrayal_buff:EDeclareFunctions()
	return {
		[EMDF_PHYSICAL_ATTACK_BONUS] = self.fPhyAtk,
		[EMDF_MAGICAL_ATTACK_BONUS] = self.fMgcAtk,
	}
end