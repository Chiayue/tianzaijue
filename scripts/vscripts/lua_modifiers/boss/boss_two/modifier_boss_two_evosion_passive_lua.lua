
modifier_boss_two_evosion_passive_lua = class({})


function modifier_boss_two_evosion_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_EVASION_CONSTANT,
	}
	return funcs
end
function modifier_boss_two_evosion_passive_lua:GetModifierPreAttack_BonusDamage( params )	--智力
	return self.value
end

--------------------------------------------------------------------------------

function modifier_boss_two_evosion_passive_lua:IsDebuff()
	return false
end
function modifier_boss_two_evosion_passive_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_two_evosion_passive_lua:GetTexture( params )
    return "modifier_boss_two_evosion_passive_lua"
end

function modifier_boss_two_evosion_passive_lua:OnCreated( kv )
	self.percent=self:GetAbility():GetSpecialValueFor("percent")
	
	
end

function modifier_boss_two_evosion_passive_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end



function modifier_boss_two_evosion_passive_lua:GetModifierEvasion_Constant(params)
    return self.percent
end
