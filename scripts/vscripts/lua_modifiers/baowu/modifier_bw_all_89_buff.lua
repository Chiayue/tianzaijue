
modifier_bw_all_89_buff = class({})
function modifier_bw_all_89_buff:GetTexture()
	return "item_treasure/modifier_bw_all_89"
end
--------------------------------------------------------------------------------

function modifier_bw_all_89_buff:OnCreated( kv )
	if IsServer() then
		--print( "test" )
	end
end

--------------------------------------------------------------------------------
function modifier_bw_all_89_buff:IsPurgable()
	return true
end

function modifier_bw_all_89_buff:IsDebuff()
	return true
end
function modifier_bw_all_89_buff:IsHidden()
	return true
end
--------------------------------------------------------------------------------

function modifier_bw_all_89_buff:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

--------------------------------------------------------------------------------

function modifier_bw_all_89_buff:OnCreated( kv )
	self:OnRefresh()
end


--------------------------------------------------------------------------------

function modifier_bw_all_89_buff:OnRefresh( kv )
	
end

function modifier_bw_all_89_buff:CheckState()
	local state =
	{
		[MODIFIER_STATE_ROOTED] = true,

	}

	return state
end