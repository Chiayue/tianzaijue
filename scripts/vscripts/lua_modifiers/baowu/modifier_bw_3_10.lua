
modifier_bw_3_10 = class({})
LinkLuaModifier( "modifier_bw_3_10_buff", "lua_modifiers/baowu/modifier_bw_3_10_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_3_10:GetTexture()
	return "item_treasure/黯灭"
end
--------------------------------------------------------------------------------
function modifier_bw_3_10:IsHidden()
	return true
end
function modifier_bw_3_10:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_10:OnRefresh()
	
end


function modifier_bw_3_10:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_3_10:GetModifierPreAttack_BonusDamage( params )
	
	return 10000
end

function modifier_bw_3_10:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  then
				hTarget:AddNewModifier( self:GetParent(), nil, "modifier_bw_3_10_buff", {duration=7} )
			end
		end
	end

	return 0.0

end

function modifier_bw_3_10:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end