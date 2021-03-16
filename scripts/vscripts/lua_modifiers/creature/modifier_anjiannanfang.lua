
    
    
    modifier_anjiannanfang = class({})

-----------------------------------------------------------------------------

function modifier_anjiannanfang:OnCreated( kv )
    self.delay_time=self:GetAbility():GetSpecialValueFor("delay_time")
    self.damage_radius=self:GetAbility():GetSpecialValueFor("damage_radius")
    self.enemy_radius=self:GetAbility():GetSpecialValueFor("enemy_radius")
    if IsServer() then
        if self:GetAbility():GetLevel()==0 then
            self:GetParent():RemoveModifierByName(self:GetName())
            return 
        end
        self:StartIntervalThink(2)
        self:OnIntervalThink()
	end
end
function modifier_anjiannanfang:IsHidden()
    return true
end

-----------------------------------------------------------------------------
-----------------------------------------------------------------------------

function modifier_anjiannanfang:OnIntervalThink()
    if IsServer() then
        local hCaster=self:GetCaster()
        local max = GetAbilitySpecialValueByLevel(self:GetAbility(),"max")
        if self:GetAbility():IsCooldownReady() and hCaster:IsAlive() then 
            local enemies = FindUnitsInRadius( self:GetParent():GetTeamNumber(), self:GetParent():GetOrigin(), self:GetParent(), self.enemy_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false )
        	local num = 0
        	if #enemies then
        		num = #enemies
	    		if #enemies > 12 then  --防卡死，最多选中12个单位
	    			num =  12
	    		end
        	end
        	if num > 0 then
           for i=1,num do
               if enemies[i] then
                for i2=1,max do
                local vPos=self:GetCaster():GetOrigin()+RandomVector(5000)
                local vDirection = enemies[i]:GetOrigin() - vPos
                vDirection.z = 0.0
                vDirection = vDirection:Normalized()

                --local  jd = GetForwardVector(vPos,enemies[i]:GetOrigin())
               -- local point = vPos + jd * 8000

                local info = 
                {
                    EffectName = "particles/econ/items/mars/mars_ti9_immortal/mars_ti9_immortal_crimson_spear.vpcf",
                    Ability = self:GetAbility(),
                    vSpawnOrigin = vPos, 
                    fStartRadius = self.damage_radius,
                    fEndRadius = self.damage_radius,
                    vVelocity = vDirection * 900,
                    fDistance = 10000,
                    Source = self:GetCaster(),
                    iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
                    iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
                }
                
                ProjectileManager:CreateLinearProjectile( info )
                EmitSoundOn( "Dungeon.BanditDagger.Cast", self:GetCaster() )  
                end
            end
           end
           
            
            self:GetAbility():StartCooldown(self:GetAbility():GetCooldown(1))
        end
		
		end
	end
end

-----------------------------------------------------------------------------

