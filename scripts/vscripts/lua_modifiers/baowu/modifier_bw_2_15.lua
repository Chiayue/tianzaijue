
modifier_bw_2_15 = class({})
LinkLuaModifier( "modifier_bw_2_15_buff", "lua_modifiers/baowu/modifier_bw_2_15_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_2_15:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_2_15:IsHidden()
	return true
end
function modifier_bw_2_15:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_2_15:OnRefresh()
	
end


function modifier_bw_2_15:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_2_15:GetModifierAttackRangeBonus( params )
	if IsServer() then
		if self:GetParent():GetAttackCapability()==1 then
			return 0
		end
	end
	return 100
end

function modifier_bw_2_15:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  then
				hTarget:AddNewModifier( hTarget, hTarget, "modifier_bw_2_15_buff", {duration=6} )
			end
		end
	end



end
function modifier_bw_2_15:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end