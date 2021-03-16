
modifier_boss_undying_decays_effect_debuff = class({})


function modifier_boss_undying_decays_effect_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
	}
	return funcs
end
function modifier_boss_undying_decays_effect_debuff:GetModifierBonusStats_Strength( params )	--智力
    if IsServer() then
        return -self:GetStackCount(  )
    end
    return 0
end

--------------------------------------------------------------------------------

function modifier_boss_undying_decays_effect_debuff:IsDebuff()
	return false
end

function modifier_boss_undying_decays_effect_debuff:GetTexture( params )
    return "modifier_boss_undying_decays_effect_debuff"
end
function modifier_boss_undying_decays_effect_debuff:IsHidden()
	return false
	-- body
end
function modifier_boss_undying_decays_effect_debuff:OnCreated( kv )
    if  IsServer() then
        --self:SetStackCount(1)
    end
	
end

function modifier_boss_undying_decays_effect_debuff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	