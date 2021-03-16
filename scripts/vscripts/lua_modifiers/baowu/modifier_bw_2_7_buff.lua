
modifier_bw_2_7_buff = class({})
function modifier_bw_2_7_buff:GetTexture()
	return "item_treasure/modifier_bw_2_7_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_2_7_buff:OnCreated( kv )
	if IsServer() then
		--print( "test" )
	end
end

--------------------------------------------------------------------------------

function modifier_bw_2_7_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_2_7_buff:GetModifierPhysicalArmorBonus( params )
	return 15
end

--------------------------------------------------------------------------------
function modifier_bw_2_7_buff:GetModifierConstantHealthRegen( params )
	return 2000
end