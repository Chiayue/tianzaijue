
add_armor = class({})


function add_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
	return funcs
end
function add_armor:GetModifierPhysicalArmorBonus( params )	--智力
	
	return self:GetStackCount()
end

--------------------------------------------------------------------------------

function add_armor:IsDebuff()
	return false
end

function add_armor:GetTexture( params )
    return "add_armor"
end
function add_armor:IsHidden()
	return true
	-- body
end
function add_armor:OnCreated( kv )
 

end

function add_armor:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end
