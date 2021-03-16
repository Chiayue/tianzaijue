modifier_boss_wood_charge_lua_effect = class({})
function modifier_boss_wood_charge_lua_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
	}
	return funcs
end

function modifier_boss_wood_charge_lua_effect:IsHidden()
    return true
end
function modifier_boss_wood_charge_lua_effect:GetModifierBonusStats_Agility( params )	--智力
	return -self:GetStackCount()
end
function modifier_boss_wood_charge_lua_effect:OnCreated( kv )
	if IsServer() then
		EmitSoundOn( "Hero_Shredder.Attack", self:GetParent() )
		if self:GetParent()~=self:GetAbility().vTarget then
			 local damage = {
                victim = self:GetParent() ,
                attacker = self:GetCaster(),
                damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*2,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
            }
            ApplyDamage( damage )
		else
			self:GetParent():AddNewModifier( self:GetCaster(), self:GetAbility(), "stun_nothing", {duration=2.2} )	
			 local damage = {
                victim = self:GetParent(),
                attacker = self:GetCaster(),
                damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*2.7,
                damage_type = DAMAGE_TYPE_MAGICAL,
                ability = self:GetAbility(),
            }
            ApplyDamage( damage )
			
		end
		
	end
end
function modifier_boss_wood_charge_lua_effect:OnRefresh( kv )
	if IsServer() then
		
	end
end