boss_tiny_attack_lua = class({})
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_tiny_attack_lua:OnAbilityPhaseStart()
	if IsServer() then
		--local vPos = self:GetCursorPosition()
		EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
		local hCaster = self:GetCaster()
		
		local point= self:GetCursorPosition()
		local cd = self.BaseClass.GetCastPoint( self ) 
		if hCaster:HasModifier("modifier_boss_tiny_bloodfire_lua") then
			 cd = self.BaseClass.GetCastPoint( self ) *0.5
		end
		
		ParticleMgr.CreateWarnRing(hCaster,point,500,cd)
		
	end
	--StartAnimation( self:GetCaster(), {duration=0.8, activity=ACT_DOTA_CAST_ABILITY_1, rate=0.8})
	return true
end

function boss_tiny_attack_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local point= self:GetCursorPosition()
	EmitSoundOn( "Hero_Brewmaster.ThunderClap", self:GetCaster() )
	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, point )
		ParticleManager:SetParticleControl( nFXIndex, 1, Vector(500,1,1)  )
		ParticleManager:ReleaseParticleIndex(nFXIndex)
	 local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), point, nil, 500,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    local target
    for _,enemy in pairs(enemies) do
    	enemy:AddNewModifier( hCaster, self, "stun_nothing", {duration=2} )
        local damage = {
			victim = enemy,
			attacker = self:GetCaster(),
			damage =  self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*5,
			damage_type = DAMAGE_TYPE_PHYSICAL,
			ability = self,
		}
		ApplyDamage( damage )
    end
	
			-- body


end



function boss_tiny_attack_lua:GetCooldown( nLevel )
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_boss_tiny_bloodfire_lua") then
			return self.BaseClass.GetCooldown( self, nLevel )-0.5
		end
	end
	return self.BaseClass.GetCooldown( self, nLevel ) 
end
function boss_tiny_attack_lua:GetCastPoint()
	local cd = self.BaseClass.GetCastPoint( self ) 
	if IsServer() then
		if self:GetCaster():HasModifier("modifier_boss_tiny_bloodfire_lua") then
			 cd = self.BaseClass.GetCastPoint( self ) *0.5
		end
	end
	return cd
end
