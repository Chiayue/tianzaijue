
modifiy_shopmall_cmzc_2 = class({})
LinkLuaModifier( "modifiy_shopmall_cmzc_2_buff", "lua_modifiers/mall/modifiy_shopmall_cmzc_2_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifiy_shopmall_cmzc_2:GetTexture()
	return "rune/shopmall_cmzc_2"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_cmzc_2:IsHidden()
	return false
end
function modifiy_shopmall_cmzc_2:OnCreated( kv )
	
end

function modifiy_shopmall_cmzc_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifiy_shopmall_cmzc_2:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  then
				hTarget:AddNewModifier( self:GetParent(), nil, "modifiy_shopmall_cmzc_2_buff", {duration=5} )
			end
		end
	end



end


function modifiy_shopmall_cmzc_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end