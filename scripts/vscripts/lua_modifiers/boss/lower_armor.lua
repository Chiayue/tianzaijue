
lower_armor = class({})


function lower_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function lower_armor:GetModifierPhysicalArmorBonus( params )	--智力
	
	return -self:GetStackCount()
end

--------------------------------------------------------------------------------

function lower_armor:IsDebuff()
	return false
end

function lower_armor:GetTexture( params )
    return "lower_armor"
end
function lower_armor:IsHidden()
	return true
	-- body
end
function lower_armor:OnCreated( kv )
 

end

function lower_armor:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
