
modifier_bw_all_92_buff = class({})
function modifier_bw_all_92_buff:GetTexture()
	return "item_treasure/modifier_bw_all_92_buff"
end
--------------------------------------------------------------------------------

function modifier_bw_all_92_buff:OnCreated( kv )
	if IsServer() then
		--print( "test" )
	end
end

--------------------------------------------------------------------------------
function modifier_bw_all_92_buff:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

--function modifier_bw_all_92_buff:GetEffectName()
--	return "particles/items4_fx/spirit_vessel_heal.vpcf"
--end

--------------------------------------------------------------------------------

function modifier_bw_all_92_buff:OnCreated( kv )
	self:OnRefresh()
end


--------------------------------------------------------------------------------

function modifier_bw_all_92_buff:OnRefresh( kv )
	
end

--------------------------------------------------------------------------------

function modifier_bw_all_92_buff:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,

	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_bw_all_92_buff:GetModifierHealthRegenPercentage( params )
	return 5
end

--------------------------------------------------------------------------------

function modifier_bw_all_92_buff:GetModifierTotalPercentageManaRegen( params )
	return 5
end

--------------------------------------------------------------------------------
