modifier_boss_pudge_dismember_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:IsDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:IsStunDebuff()
	return true
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:OnCreated( kv )
	self.dismember_damage = self:GetAbility():GetSpecialValueFor( "dismember_damage" )
	self.tick_rate = self:GetAbility():GetSpecialValueFor( "tick_rate" )
	self.strength_damage_scepter = self:GetAbility():GetSpecialValueFor( "strength_damage_scepter" )

	if IsServer() then
		self:GetParent():InterruptChannel()
		self:OnIntervalThink()
		self:StartIntervalThink( self.tick_rate )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:OnDestroy()
	if IsServer() then
		self:GetCaster():InterruptChannel()
	end
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:OnIntervalThink()
	if IsServer() then
		local flDamage = self.dismember_damage
		if self:GetCaster():HasScepter() then
			flDamage = flDamage + ( self:GetCaster():GetStrength() * self.strength_damage_scepter )
			self:GetCaster():Heal( flDamage, self:GetAbility() )
		end

		local damage = {
			victim = self:GetParent(),
			attacker = self:GetCaster(),
			damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		}
		local heal = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())
		if self:GetCaster().shjs then
			heal = heal / self:GetCaster().shjs
		end
		self:GetCaster():Heal(heal,self:GetCaster())
		ApplyDamage( damage )
		EmitSoundOn( "Hero_Pudge.Dismember", self:GetParent() )
	end
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_INVISIBLE] = false,
	}

	return state
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_OVERRIDE_ANIMATION,
	}

	return funcs
end

--------------------------------------------------------------------------------

function modifier_boss_pudge_dismember_lua:GetOverrideAnimation( params )
	return ACT_DOTA_FLAIL
end

--------------------------------------------------------------------------------
