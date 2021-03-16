
modifier_bw_all_88 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_88:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_all_88:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_all_88:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 2 )
	end
end
function modifier_bw_all_88:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_all_88:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,1500)
			if #units >= 1 then
				local vDirection = GetForwardVector(caster:GetAbsOrigin(),units[1]:GetOrigin())
				local info = 
				{
					EffectName = "particles/units/heroes/hero_venomancer/venomancer_venomous_gale.vpcf",
					Ability = self,
					vSpawnOrigin = point,
					fDistance = 2000,
					fStartRadius = 250,
					fEndRadius = 250,
					Source = self:GetCaster(),
					iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
					iUnitTargetType = DOTA_UNIT_TARGET_ALL + DOTA_UNIT_TARGET_BASIC,
				}
				info.vVelocity = vDirection *2000
				ProjectileManager:CreateLinearProjectile( info )
			end		
		end
	end
end

function modifier_bw_all_88:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
	    if hTarget ~= nil and ( not hTarget:IsInvulnerable() ) then
	     	local caster = self:GetCaster()
			local ll = caster:GetPrimaryAttribute()
			local damage = ll * (caster:GetLevel()*0.5+10)
			ApplyDamageMf(caster,hTarget,self,damage)
			EmitSoundOn( "Dungeon.BanditDagger.Target", hTarget )
		end
	end

	return true
end
function modifier_bw_all_88:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

