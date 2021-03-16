
modifier_boss_one_attack_passive_lua = class({})


function modifier_boss_one_attack_passive_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end
function modifier_boss_one_attack_passive_lua:GetModifierPreAttack_BonusDamage( params )	--智力
	return self.value
end

--------------------------------------------------------------------------------

function modifier_boss_one_attack_passive_lua:IsDebuff()
	return false
end

function modifier_boss_one_attack_passive_lua:GetTexture( params )
    return "modifier_boss_one_attack_passive_lua"
end
function modifier_boss_one_attack_passive_lua:IsHidden()
	return true
	-- body
end
function modifier_boss_one_attack_passive_lua:OnCreated( kv )
	self.value=kv.value
	
end

function modifier_boss_one_attack_passive_lua:GetAttributes()
  return MODIFIER_ATTRIBUTE_MULTIPLE
end

function modifier_boss_one_attack_passive_lua:OnAttackLanded( params )
	if IsServer() then
		
		if params.attacker == self:GetParent() then
			if RollPercentage(15) then
				local target = params.target
				target:AddNewModifier( self:GetParent(), self:GetAbility(), "stun_nothing", {duration=1.5} )
				local damageInfo =
					{
						victim = target,
						attacker = self:GetParent(),
						damage = self:GetParent():GetAverageTrueAttackDamage(self:GetParent())*2,	--造成2倍的攻击伤害
						damage_type = DAMAGE_TYPE_PHYSICAL,
						ability = self:GetAbility(),
					}
				ApplyDamage( damageInfo )
			end
			
		end
	end
	
	return 0
end

	