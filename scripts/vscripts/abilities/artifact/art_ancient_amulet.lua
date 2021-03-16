LinkLuaModifier("modifier_art_ancient_amulet", "abilities/artifact/art_ancient_amulet.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_art_ancient_amulet_mana", "abilities/artifact/art_ancient_amulet.lua", LUA_MODIFIER_MOTION_NONE)
--Abilities
--古代护身符
if art_ancient_amulet == nil then
	art_ancient_amulet = class({}, nil, artifact_base)
end
function art_ancient_amulet:GetIntrinsicModifierName()
	return "modifier_art_ancient_amulet"
end
---------------------------------------------------------------------
--Modifiers
if modifier_art_ancient_amulet == nil then
	modifier_art_ancient_amulet = class({}, nil, eom_modifier)
end
function modifier_art_ancient_amulet:OnCreated(params)
	if IsServer() then
		local hParent = self:GetParent()
		hParent:GameTimer(0.1, function()
			local mana_limit_pct = self:GetAbilitySpecialValueFor("mana_limit_pct")
			local mana_bonus = hParent:GetMaxMana() * mana_limit_pct * 0.01
			self.hModifier = hParent:AddNewModifier(self:GetCaster(), self:GetAbility(), "modifier_art_ancient_amulet_mana", { mana_bonus = mana_bonus })
			hParent:SetMana(math.min(mana_bonus, hParent:GetMana()))
			-- hParent:SetHealth(math.min(hParent:GetHealth(), hParent:GetMaxHealth()))
		end)
		-- hParent:GiveMana(mana_bonus)
	end
end
function modifier_art_ancient_amulet:OnRefresh(params)
end
function modifier_art_ancient_amulet:OnDestroy()
	if IsServer() then
		if IsValid(self.hModifier) then
			self.hModifier:Destroy()
		end
	end
end
function modifier_art_ancient_amulet:EDeclareFunctions()
	return {
		[EMDF_HERO_PERCENTAGE_MANA_REGEN] = self:GetAbilitySpecialValueFor("mana_regen_pct"),
	}
end
-- function modifier_art_ancient_amulet:DeclareFunctions()
-- 	return {
-- 		MODIFIER_PROPERTY_EXTRA_HEALTH_PERCENTAGE
-- 	}
-- end
-- function modifier_art_ancient_amulet:GetModifierExtraHealthPercentage()
-- 	return -self:GetAbilitySpecialValueFor("health_pct")
-- end
------------------------------------------------------------------------------
if modifier_art_ancient_amulet_mana == nil then
	modifier_art_ancient_amulet_mana = class({})
end
function modifier_art_ancient_amulet_mana:OnCreated(params)
	if IsServer() then
		self.mana_bonus = params.mana_bonus
	end
end
function modifier_art_ancient_amulet_mana:OnRefresh(params)
	if IsServer() then
		self.mana_bonus = params.mana_bonus
	end
end
function modifier_art_ancient_amulet_mana:OnDestroy(params)
	if IsServer() then
	end
end
function modifier_art_ancient_amulet_mana:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MANA_BONUS
	}
end
function modifier_art_ancient_amulet_mana:GetModifierManaBonus()
	return self.mana_bonus
end