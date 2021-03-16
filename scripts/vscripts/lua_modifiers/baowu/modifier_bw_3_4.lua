
modifier_bw_3_4 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_4:GetTexture()
	return "item_treasure/智灭"
end
--------------------------------------------------------------------------------
function modifier_bw_3_4:IsHidden()
	return true
end
function modifier_bw_3_4:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_4:OnRefresh()
	
end


function modifier_bw_3_4:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_3_4:GetModifierAttackSpeedBonus_Constant( params )
	return 50
end

function modifier_bw_3_4:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  then
				local damageInfo =
				{
					victim = hTarget,
					attacker = self:GetParent(),
					damage = self:GetParent():GetAgility()*5,
					damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = nil,
				}
				ApplyDamage( damageInfo )
					
			end
		end
	end

	return 0.0

end
function modifier_bw_3_4:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end