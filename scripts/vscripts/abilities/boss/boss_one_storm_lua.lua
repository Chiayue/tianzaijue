boss_one_storm_lua = class({})
LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function boss_one_storm_lua:OnAbilityPhaseStart()
	if IsServer() then
		--local vPos = self:GetCursorPosition()
		EmitSoundOn( "Hero_Sven.StormBolt", self:GetCaster() )
		local hCaster = self:GetCaster()
		local radius = self:GetSpecialValueFor("radius") 
		local cd  = self.BaseClass.GetCastPoint( self )-GameRules:GetCustomGameDifficulty()*0.04
		if cd < 1 then
			cd = 1
		end
		ParticleMgr.CreateWarnRing(hCaster,nil,radius,cd)
	end
	return true
end

function boss_one_storm_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")

	local attachment = hCaster:ScriptLookupAttachment( "attach_attack1" )
	 local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetAbsOrigin(), nil, radius,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
    local target
    for _,enemy in pairs(enemies) do
        local info = 
		{
			Target = enemy,
			Source = hCaster,
			Ability = self,
			EffectName = "particles/units/heroes/hero_sven/sven_spell_storm_bolt.vpcf",
			iMoveSpeed = 1100,
			vSourceLoc = hCaster:GetAttachmentOrigin( attachment ),
			bDodgeable = false,
			bProvidesVision = false,
			flExpireTime = GameRules:GetGameTime() + 1,
		}

		ProjectileManager:CreateTrackingProjectile( info )
    end
	
			-- body


end

---------------------------------------------------------------------

function boss_one_storm_lua:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil then
			EmitSoundOn( "Hero_Sven.StormBoltImpact", hTarget )
			hTarget:AddNewModifier( self:GetCaster(), self, "stun_nothing", {duration=2} )
				local damageInfo =
					{
						victim = hTarget,
						attacker = self:GetCaster(),
						damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*self:GetSpecialValueFor("i"),	
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self,
					}
				ApplyDamage( damageInfo )
		end
	end

	return true
end


function boss_one_storm_lua:GetCooldown( nLevel )
	local cd = self.BaseClass.GetCooldown( self, nLevel )-0.2*GameRules:GetCustomGameDifficulty()
	if cd < 6 then
		cd = 6
	end
	return cd
end
function boss_one_storm_lua:GetCastPoint()
	local cd  = self.BaseClass.GetCastPoint( self )-GameRules:GetCustomGameDifficulty()*0.04
	if cd < 1 then
		cd = 1
	end
	return cd
end
