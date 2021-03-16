modifier_boss_wood_bot_lunpan_lua = class({})

--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_lua:IsHidden()
	return true
end




--------------------------------------------------------------------------------

function modifier_boss_wood_bot_lunpan_lua:OnCreated( kv )
	
	if IsServer() then
		
		
		EmitSoundOn( "Hero_Shredder.Chakram", self:GetParent() )
		
		self.postion=self:GetParent():GetOrigin()
		self:StartIntervalThink( 1)	
	end
end

--------------------------------------------------------------------------------
function modifier_boss_wood_bot_lunpan_lua:DeclareFunctions()
    local funcs = {
		MODIFIER_EVENT_ON_DEATH,
    }
    return funcs
end
function modifier_boss_wood_bot_lunpan_lua:CheckState()
	return {
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end
function modifier_boss_wood_bot_lunpan_lua:OnIntervalThink()
	if IsServer() then
		if  self:GetParent():IsAlive() then
			local hCaster=self:GetParent()
			local enemies = FindUnitsInRadius(hCaster:GetTeamNumber(), hCaster:GetOrigin(), nil, 250,
                    DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
                    DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_CLOSEST, false)
			    for _,enemy in pairs(enemies) do
			    	EmitSoundOn( "Hero_Shredder.Attack", self:GetParent() )
			    	local buff=enemy:AddNewModifier( hCaster, self:GetAbility(), "modifier_boss_wood_bot_lunpan_lua_effect", {duration=5} )
			    	local damage = {
						victim = enemy,
						attacker = self:GetParent(),
						damage = (self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*3.8)*(1+buff:GetStackCount()/10),
						damage_type = DAMAGE_TYPE_MAGICAL,
						ability = self:GetAbility(),
					}
					ApplyDamage( damage )
			    end
		end
	end
end
function modifier_boss_wood_bot_lunpan_lua:OnDeath( params )
	if IsServer() then
		if self:GetParent()==params.unit then
			
		end
	end
end
function modifier_boss_wood_bot_lunpan_lua:OnDestroy( kv )
	if IsServer() then
		StopSoundEvent( "Hero_Shredder.Chakram", self:GetParent() )
	end
end
--------------------------------------------------------------------------------