LinkLuaModifier("modifier_courier_niunian", "abilities/courier/ssr/courier_niunian.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_niunian == nil then
	courier_niunian = class({})
end
function courier_niunian:GetIntrinsicModifierName()
	return "modifier_courier_niunian"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_niunian == nil then
	modifier_courier_niunian = class({}, nil, eom_modifier)
end
function modifier_courier_niunian:IsHidden()
	return true
end
function modifier_courier_niunian:OnCreated(params)
	self.price_reduce = self:GetAbilitySpecialValueFor('price_reduce')
	self.min_gold = self:GetAbilitySpecialValueFor('min_gold')
	self.max_gold = self:GetAbilitySpecialValueFor('max_gold')
	self.crysital_chance = self:GetAbilitySpecialValueFor('crysital_chance')
end
function modifier_courier_niunian:OnRefresh(params)
	self.price_reduce = self:GetAbilitySpecialValueFor('price_reduce')
	self.min_gold = self:GetAbilitySpecialValueFor('min_gold')
	self.max_gold = self:GetAbilitySpecialValueFor('max_gold')
	self.crysital_chance = self:GetAbilitySpecialValueFor('crysital_chance')
end
function modifier_courier_niunian:EDeclareFunctions()
	return {
		EMDF_BUY_CARD_DISCOUNT_PERCENTAGE,
		EMDF_EVENT_ON_PREPARATION,
	}
end
function modifier_courier_niunian:GetModifierCardBuyDiscont()
	return self.price_reduce
end
function modifier_courier_niunian:OnPreparation()
	local count = 0
	local iParticleID = ParticleManager:CreateParticle("particles/units/courier/courier_nian_coin.vpcf", PATTACH_CUSTOMORIGIN, nil)
	ParticleManager:SetParticleControlEnt(iParticleID, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_bag", self:GetParent():GetAbsOrigin(), false)
	self:GetParent():GameTimer(0, function()
		if count < 2 then
			PlayerData:DropGold(GetPlayerID(self:GetParent()), self:GetParent():GetAbsOrigin(), RandomInt(self.min_gold, self.max_gold))
			if RollPercentage(self.crysital_chance) then
				PlayerData:DropCrystal(GetPlayerID(self:GetParent()), self:GetParent():GetAbsOrigin(), RandomInt(self.min_gold, self.max_gold))
			end
			count = count + 0.1
			EmitSoundForPlayer("ui.comp_coins_tick", GetPlayerID(self:GetParent()))
			return 0.1
		else
			ParticleManager:DestroyParticle(iParticleID, false)
		end
	end)
end