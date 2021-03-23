
modifier_bw_3_14 = class({})

--------------------------------------------------------------------------------

function modifier_bw_3_14:GetTexture()
	return "item_treasure/撒旦邪之力"
end
--------------------------------------------------------------------------------
function modifier_bw_3_14:IsHidden()
	return true
end
function modifier_bw_3_14:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_3_14:OnRefresh()
	
end


function modifier_bw_3_14:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end
function modifier_bw_3_14:GetModifierBonusStats_Strength( params )
	return 1500
end
function modifier_bw_3_14:GetModifierPreAttack_BonusDamage( params )
	
	return 6000
end
function modifier_bw_3_14:OnTakeDamage( params )
	if IsServer() then
		local hAttacker = params.attacker
		if hAttacker == self:GetParent() then
			local heal = ( params.damage * 0.1)
			if heal > 100000000 then
				heal = 100000000
			end
			--print( 'modifier_blessing_life_steal healing for ' .. heal )
			self:GetParent():Heal( heal, nil )
			ParticleManager:ReleaseParticleIndex( ParticleManager:CreateParticle( "particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent() ) )
			
		end
	end

	return 0
end

function modifier_bw_3_14:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end