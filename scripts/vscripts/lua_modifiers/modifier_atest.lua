
modifier_atest = class({})

--------------------------------------------------------------------------------

function modifier_atest:GetTexture()
	return "../items/river_painter4"
end

--------------------------------------------------------------------------------

function modifier_atest:OnCreated( kv )
	
	self.shrapnel_damage = 50
	-- Allow you to specify different keys for each claim level
	
end

--------------------------------------------------------------------------------

function modifier_atest:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL,
		MODIFIER_PROPERTY_OVERRIDE_ABILITY_SPECIAL_VALUE,
	}
	return funcs
end

-----------------------------------------------------------------------

function modifier_atest:GetModifierOverrideAbilitySpecial( params )
	if self:GetParent() == nil or params.ability == nil then
		return 0
	end

	local szAbilityName = params.ability:GetAbilityName()
	local szSpecialValueName = params.ability_special_value

	if szAbilityName ~= "ascension_crit" then
		return 0
	end

	if szSpecialValueName == "crit_chance" then
		--print( 'modifier_atest:GetModifierOverrideAbilitySpecial - looking for radius!' )
		return 1
	end

	return 0
end

-----------------------------------------------------------------------

function modifier_atest:GetModifierOverrideAbilitySpecialValue( params )
	local szAbilityName = params.ability:GetAbilityName() 
	if szAbilityName ~= "ascension_crit" then
		return 0
	end

	local szSpecialValueName = params.ability_special_value
	if szSpecialValueName == "crit_chance" then
		local nSpecialLevel = params.ability_special_level
		local flBaseValue = params.ability:GetLevelSpecialValueNoOverride( szSpecialValueName, nSpecialLevel )
		--print( 'modifier_atest:GetModifierOverrideAbilitySpecialValue - radius is ' .. flBaseValue .. '. Adding on an additional ' .. self.radius_percent )

		return flBaseValue  + self.shrapnel_damage 
	end

	return 0
end
