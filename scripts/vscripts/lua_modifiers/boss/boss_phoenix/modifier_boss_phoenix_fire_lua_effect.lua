modifier_boss_phoenix_fire_lua_effect = class({})

function modifier_boss_phoenix_fire_lua_effect:OnCreated( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target =self:GetParent()

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_ABSORIGIN_FOLLOW, "hitloc", target:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
		self:StartIntervalThink(2)		
	end
end

function modifier_boss_phoenix_fire_lua_effect:OnIntervalThink()
	if IsServer() then
		if self:GetCaster() == nil or self:GetCaster():IsNull() then
			return
		end
		if  self:GetCaster():IsAlive() then
			local target =self:GetParent()
			local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/huskar/huskar_searing_dominator/huskar_searing_lifebreak_cast.vpcf", PATTACH_ABSORIGIN_FOLLOW, target )
			ParticleManager:SetParticleControlEnt( nFXIndex, 0, target, PATTACH_ABSORIGIN_FOLLOW, "hitloc", target:GetOrigin(), true )
			ParticleManager:ReleaseParticleIndex(nFXIndex)
			EmitSoundOn( "hero_jakiro.projectileImpact", target )
			
			if self:GetParent():HasModifier("modifier_boss_phoenix_turnegg_lua") then
				local damageInfo =
				{
					victim = target,
					attacker = self:GetCaster(),
					damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*2,
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
			else
				local damageInfo =
				{
					victim = target,
					attacker = self:GetCaster(),
					damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster()),
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}
				ApplyDamage( damageInfo )
			end
	
			
			
		end
	end
end

---------------------------
--------------------------------------------------------------------------------



