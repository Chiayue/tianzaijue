
modifier_boss_undying_flesh_golem_effect_enemy_buff = class({})


function modifier_boss_undying_flesh_golem_effect_enemy_buff:DeclareFunctions()
	local funcs = {
        MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
	}
	return funcs
end

function modifier_boss_undying_flesh_golem_effect_enemy_buff:GetModifierMoveSpeedBonus_Percentage( params )	--
   
    return self.cc
end

function modifier_boss_undying_flesh_golem_effect_enemy_buff:IsDebuff()
	return true
end

function modifier_boss_undying_flesh_golem_effect_enemy_buff:GetTexture( params )
    return "modifier_boss_undying_flesh_golem_effect_enemy_buff"
end
function modifier_boss_undying_flesh_golem_effect_enemy_buff:IsHidden()
	return false
	-- body
end

function modifier_boss_undying_flesh_golem_effect_enemy_buff:OnCreated( kv )
    self.cc= -30
    if  self:GetCaster():HasModifier("modifier_boss_undying_tombstone_zombie_night") then
        self.cc= -50
    end
	
end

function modifier_boss_undying_flesh_golem_effect_enemy_buff:GetAttributes()
  return MODIFIER_ATTRIBUTE_PERMANENT
end


	