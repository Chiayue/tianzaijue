modifier_boss_phoenix_firemana_lua = class({})

function modifier_boss_phoenix_firemana_lua:OnCreated( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target =self:GetParent()

		self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_sunray.vpcf", PATTACH_OVERHEAD_FOLLOW, caster )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 0, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetOrigin()+Vector(1,1,222), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 1, target, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", target:GetOrigin()+Vector(1,1,222), true )
			ParticleManager:SetParticleControlEnt( self.nFXIndex, 9, caster, PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", caster:GetOrigin()+Vector(1,1,222), true )
			
		self:StartIntervalThink(1)		
	end
end
function modifier_boss_phoenix_firemana_lua:OnDestroy( kv )
	if IsServer() then
		

			ParticleManager:DestroyParticle( self.nFXIndex, true )
	end
end
function modifier_boss_phoenix_firemana_lua:OnIntervalThink()
	if IsServer() then
		if not EntityIsAlive(self:GetCaster()) then
			return 
		end
		if not EntityIsAlive(self:GetParent()) then
			return 
		end
			local target =self:GetParent()
			
			local damageInfo =
				{
					victim = target,
					attacker = self:GetCaster(),
					damage = (5+5*GameRules:GetCustomGameDifficulty())/100*target:GetMaxHealth(),
					damage_type = DAMAGE_TYPE_MAGICAL,
					ability = self:GetAbility(),
				}
			ApplyDamage( damageInfo )
			
		
	end
end

---------------------------
--------------------------------------------------------------------------------



