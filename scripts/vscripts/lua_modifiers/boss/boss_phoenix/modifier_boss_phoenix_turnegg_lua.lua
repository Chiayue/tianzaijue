modifier_boss_phoenix_turnegg_lua = class({})

function modifier_boss_phoenix_turnegg_lua:OnCreated( kv )
	if IsServer() then
		local caster = self:GetCaster()
		local target =self:GetParent()
		caster:SetHealth(caster:GetMaxHealth()*0.15)
		self.model=caster:GetModelName()
		--caster:SetModel("models/items/phoenix/ultimate/blazing_wing_blazing_egg/blazing_wing_blazing_egg.vmdl")
        
        self.nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_egg.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetCaster() )
        ParticleManager:SetParticleControlEnt(self.nFXIndex, 0, self:GetCaster(), PATTACH_OVERHEAD_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true)
        ParticleManager:SetParticleControlEnt(self.nFXIndex, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetCaster():GetOrigin(), true)
        --ParticleManager:SetParticleControl( self.nFXIndex, 1, self:GetCaster():GetOrigin() )
        --ParticleManager:SetParticleControl( self.nFXIndex, 0, self:GetCaster():GetOrigin() )
        
	end
end
function modifier_boss_phoenix_turnegg_lua:OnDestroy( kv )
	if IsServer() then
		local caster = self:GetCaster()
        --caster:SetModel(self.model)
        EmitSoundOn( "Hero_Phoenix.SuperNova.Explode", caster )
        if self.nFXIndex then
			ParticleManager:DestroyParticle(self.nFXIndex, true)
		end
        local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phoenix/phoenix_supernova_reborn.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
        ParticleManager:ReleaseParticleIndex( nFXIndex )
		if caster:IsAlive() then
			caster:SetHealth(caster:GetMaxHealth())
			local buff=caster:AddNewModifier(caster, self:GetAbility(), "modifier_boss_phoenix_turnegg_lua_effect", {})
			buff:SetStackCount(buff:GetStackCount()+1)
		end

	end
end
function modifier_boss_phoenix_turnegg_lua:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MODEL_CHANGE,
	}
end

function modifier_boss_phoenix_turnegg_lua:GetModifierModelChange( params )	
	return "models/items/phoenix/ultimate/ti8_phoenix_heart_of_volcano_egg/ti8_phoenix_heart_of_volcano_egg.vmdl"
end
function modifier_boss_phoenix_turnegg_lua:CheckState()
	local state = {
	
	[MODIFIER_STATE_FROZEN]= false,
	[MODIFIER_STATE_DISARMED]= true,
	
	
	}

	return state
end
---------------------------
--------------------------------------------------------------------------------



