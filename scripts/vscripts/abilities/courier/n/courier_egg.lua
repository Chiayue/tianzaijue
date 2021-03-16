LinkLuaModifier("modifier_courier_egg", "abilities/courier/n/courier_egg.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if courier_egg == nil then
	courier_egg = class({})
end
function courier_egg:GetIntrinsicModifierName()
	return "modifier_courier_egg"
end
---------------------------------------------------------------------
--Modifiers
if modifier_courier_egg == nil then
	modifier_courier_egg = class({}, nil, eom_modifier)
end
function modifier_courier_egg:IsHidden()
	return true
end
function modifier_courier_egg:OnCreated(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.min_gold = self:GetAbilitySpecialValueFor("min_gold")
	self.max_gold = self:GetAbilitySpecialValueFor("max_gold")
	if IsServer() then
	end
end
function modifier_courier_egg:OnRefresh(params)
	self.chance = self:GetAbilitySpecialValueFor("chance")
	self.min_gold = self:GetAbilitySpecialValueFor("min_gold")
	self.max_gold = self:GetAbilitySpecialValueFor("max_gold")
	if IsServer() then
	end
end
function modifier_courier_egg:EDeclareFunctions()
	return {
		EMDF_EVENT_ON_BATTLEING_END
	}
end
function modifier_courier_egg:OnBattleEnd()
	local hCaster = self:GetCaster()
	local item = CreateItem("item_builder_egg", hCaster, hCaster)
	item:SetPurchaseTime(GameRules:GetGameTime())
	item.bonus_gold = RandomInt(self.min_gold, self.max_gold)
	item.hCaster = hCaster
	local pos = hCaster:GetAbsOrigin()
	local drop = CreateItemOnPositionSync(pos, item)
	local pos_launch = pos + RandomVector(RandomFloat(0, 50))
	item:LaunchLoot(false, 200, 0.75, pos_launch)
	drop:SetModelScale(0.8)
	drop:ResetSequence("portrait_idle")
	-- 10秒自动拾取
	GameTimer(10, function()
		if IsValid(item) then
			local hContainer = item:GetContainer()
			hCaster:AddItem(item)
			if IsValid(hContainer) then
				UTIL_Remove(hContainer)
			end
		end
	end)

	hCaster:EmitSound("Hero_SkywrathMage.ChickenTaunt")
end