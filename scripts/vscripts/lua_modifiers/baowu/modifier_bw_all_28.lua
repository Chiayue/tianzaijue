
modifier_bw_all_28 = class({})
LinkLuaModifier( "modifier_bw_all_28_debuff", "lua_modifiers/baowu/modifier_bw_all_28_debuff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_all_28:GetTexture()
	return "item_treasure/重击"
end
--------------------------------------------------------------------------------
function modifier_bw_all_28:IsHidden()
	return true
end
function modifier_bw_all_28:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_28:OnRefresh()
	
end

function modifier_bw_all_28:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_all_28:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil and not hTarget:HasModifier("modifier_bw_all_28_debuff")  then
				hTarget:AddNewModifier( self:GetParent(), nil, "modifier_bw_all_28_debuff", {} )
				print(params.damage)
				local damageInfo =
				{
					victim = hTarget,
					attacker = self:GetParent(),
					damage = params.damage,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = nil,
				}
				ApplyDamage( damageInfo )
			end
		end
	end

	return 0.0

end

function modifier_bw_all_28:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end