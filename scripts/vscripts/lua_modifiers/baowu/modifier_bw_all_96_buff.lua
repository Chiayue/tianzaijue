
modifier_bw_all_96_buff = class({})
function modifier_bw_all_96_buff:GetTexture()
	return "item_treasure/modifier_bw_all_92_buff"
end
--------------------------------------------------------------------------------




--------------------------------------------------------------------------------


--------------------------------------------------------------------------------

function modifier_bw_all_96_buff:OnCreated( kv )
	self.hj = self:GetStackCount() - 90
	self:OnRefresh()
end


--------------------------------------------------------------------------------
function modifier_bw_all_96_buff:GetEffectName()
	return "particles/units/heroes/hero_broodmother/broodmother_hunger_buff.vpcf"
end


function modifier_bw_all_96_buff:OnRefresh( kv )

end

--------------------------------------------------------------------------------

function modifier_bw_all_96_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,

	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_all_96_buff:GetModifierAttackSpeedBonus_Constant( params )
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function modifier_bw_all_96_buff:GetModifierBaseDamageOutgoing_Percentage( params )
	return self:GetStackCount()
end

function modifier_bw_all_96_buff:GetModifierPhysicalArmorBonus( params )
	return -self.hj
end

--------------------------------------------------------------------------------

