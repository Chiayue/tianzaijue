
modifier_bw_4_5 = class({})

--------------------------------------------------------------------------------
function modifier_bw_4_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
function modifier_bw_4_5:GetTexture()
	return "item_treasure/弩炮"
end
--------------------------------------------------------------------------------
function modifier_bw_4_5:IsHidden()
	return true
end
function modifier_bw_4_5:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_4_5:OnRefresh()
	
end


function modifier_bw_4_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_ATTACK_RANGE_BONUS,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_bw_4_5:GetModifierAttackRangeBonus( params )
	
	return 500
end
function modifier_bw_4_5:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			if hTarget ~= nil  then
				local vLocation=self:GetParent():GetAbsOrigin()
				local kv_knockback =
				{
					center_x = vLocation.x,
					center_y = vLocation.y,
					center_z = vLocation.z,
					should_stun = false, 
					duration = 0.2,
					knockback_duration = 0.2,
					knockback_distance = 50,
					knockback_height = 0,
				}
				if hTarget.isboss ~= 1 then
					hTarget:AddNewModifier( self:GetParent(), nil, "modifier_knockback", kv_knockback )
		
				end
				local damageInfo =
					{
						victim = hTarget,
						attacker = self:GetParent(),
						damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent()) * 20,
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = nil,
					}
					ApplyDamage( damageInfo )
			
			end
		end
	end

	return 0.0

end

function modifier_bw_4_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end