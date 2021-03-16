LinkLuaModifier("modifier_item_list_of_assassins", "abilities/items/item_list_of_assassins.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
if item_list_of_assassins == nil then
	item_list_of_assassins = class({}, nil, base_ability_attribute)
end
function item_list_of_assassins:Assassination(hTarget)
	local hCaster = self:GetCaster()

	local info = {
		EffectName = "particles/units/heroes/hero_phantom_assassin/phantom_assassin_stifling_dagger.vpcf",
		Ability = self,
		iMoveSpeed = 1500,
		Source = hCaster,
		Target = hTarget,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_HITLOCATION,
		vSourceLoc = hCaster:GetAbsOrigin(),
		bDodgeable = false,
	}
	ProjectileManager:CreateTrackingProjectile(info)
end
function item_list_of_assassins:OnProjectileHit(hTarget, vLocation)
	if hTarget then
		local hCaster = self:GetCaster()
		local bounty = self:GetSpecialValueFor("bounty")
		hCaster:DealDamage(hTarget, self, self:GetAbilityDamage())
		if not hTarget:IsAlive() then
			PlayerData:ModifyGold(GetPlayerID(hCaster), bounty)
		end
	end
	return true
end
function item_list_of_assassins:GetIntrinsicModifierName()
	return "modifier_item_list_of_assassins"
end
---------------------------------------------------------------------
--Modifiers
if modifier_item_list_of_assassins == nil then
	modifier_item_list_of_assassins = class({}, nil, modifier_base_ability_attribute)
end
function modifier_item_list_of_assassins:OnCreated(params)
	self.radius = self:GetAbilitySpecialValueFor("radius")
	self.unlock_level = self:GetAbilitySpecialValueFor("unlock_level")
	self.bonus_count = self:GetAbilitySpecialValueFor("bonus_count")
	if IsServer() then
		self:StartIntervalThink(1)
	end
end
function modifier_item_list_of_assassins:OnRefresh(params)
	if IsServer() then
	end
end
function modifier_item_list_of_assassins:OnIntervalThink()
	local hParent = self:GetParent()
	local hAbility = self:GetAbility()
	if hAbility:IsCooldownReady() then
		local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
		if #tTargets > 0 then
			table.sort(tTargets, function(a, b) return a:GetHealth() < b:GetHealth() end)
			local hTarget = tTargets[1]
			hAbility:UseResources(false, false, true)
			hAbility:Assassination(hTarget)
			if hAbility:GetLevel() >= self.unlock_level then
				local bonus_count = 0
				hParent:GameTimer(0.1, function()
					local tTargets = FindUnitsInRadiusWithAbility(hParent, hParent:GetAbsOrigin(), self.radius, hAbility)
					if #tTargets > 0 then
						local hTarget = tTargets[1]
						hAbility:Assassination(hTarget)
					end
					bonus_count = bonus_count + 1
					if bonus_count < self.bonus_count then
						return 0.1
					end
				end)
			end
		end
	end
end