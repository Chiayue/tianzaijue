
modifier_bw_3_2 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_2:GetTexture()
	return "item_treasure/骑士剑"
end
--------------------------------------------------------------------------------
function modifier_bw_3_2:IsHidden()
	return true
end
function modifier_bw_3_2:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_2:OnRefresh()
	
end


function modifier_bw_3_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_BASEDAMAGEOUTGOING_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end
function modifier_bw_3_2:GetStatusEffectName()
	return "particles/generic_gameplay/generic_lifesteal.vpcf"
end
function modifier_bw_3_2:GetModifierBaseDamageOutgoing_Percentage( params )
	return 80
end
function modifier_bw_3_2:GetModifierAttackSpeedBonus_Constant( params )
	return  50
end
function modifier_bw_3_2:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		if hAttacker == self:GetParent() then
			local heal = ( params.damage * 0.05)
			if heal > 100000000 then
				heal = 100000000
			end
			self:GetParent():Heal( heal, nil )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
			
		end
	end

	return 0
end
function modifier_bw_3_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end