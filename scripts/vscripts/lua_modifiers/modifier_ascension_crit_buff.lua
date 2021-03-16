
modifier_ascension_crit_buff = class({})

--------------------------------------------------------------------------------

function modifier_ascension_crit_buff:GetTexture()
	return "../items/river_painter4"
end

--------------------------------------------------------------------------------
function modifier_ascension_crit_buff:IsHidden()
	return false
end
function modifier_ascension_crit_buff:OnCreated( kv )
	
	self.gjjshj = self:GetAbility():GetSpecialValueFor( "gjjshj" )
	
end

--------------------------------------------------------------------------------

function modifier_ascension_crit_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end

-----------------------------------------------------------------------
function modifier_ascension_crit_buff:GetModifierPhysicalArmorBonus( params )	--智力
	return -self.gjjshj
end

