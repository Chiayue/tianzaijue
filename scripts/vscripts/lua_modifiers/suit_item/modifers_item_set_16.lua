
modifers_item_set_16 = class({})


function modifers_item_set_16:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end
function modifers_item_set_16:GetModifierBonusStats_Agility( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==1	 then
			return 1500
		end
	end
	return 0
end
function modifers_item_set_16:GetModifierBonusStats_Strength( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==0	 then
			return 1500
		end
	end
	return 0
end
function modifers_item_set_16:GetModifierBonusStats_Intellect( params )	--智力
	if IsServer() then
		if self:GetParent():GetPrimaryAttribute()==2	 then
			return 1500
		end
	end
	return 0
end
function modifers_item_set_16:GetModifierPreAttack_BonusDamage( params )	--智力
	
	return 4000
end
function modifers_item_set_16:GetModifierAttackSpeedBonus_Constant( params )	--智力
	
	return 80
end
function modifers_item_set_16:GetModifierMoveSpeedBonus_Constant( params )	--智力
	
	return 40
end
function modifers_item_set_16:GetModifierPreAttack_CriticalStrike(params)
    if IsServer() then
        local hTarget = params.target
        local hAttacker = params.attacker
        
        if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) and hAttacker and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
            if RollPercentage(20) then -- expose RollPseudoRandomPercentage?
               	EmitSoundOn( "Hero_PhantomAssassin.CoupDeGrace", hAttacker)
               	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, nil )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, -self:GetCaster():GetForwardVector() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
            	return 800
            end
        end
    end
    return 0.0
end
--------------------------------------------------------------------------------

function modifers_item_set_16:IsDebuff()
	return false
end

function modifers_item_set_16:GetTexture( params )
    return "tz/黑暗执行者"
end
function modifers_item_set_16:IsHidden()
	return false
	-- body
end
function modifers_item_set_16:OnCreated( kv )
	 if IsServer() then
 			
 	end
end

function modifers_item_set_16:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end
