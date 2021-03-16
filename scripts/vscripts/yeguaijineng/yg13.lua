function yg13blgj( keys )
    local caster = keys.caster
    local target = keys.target
    local point = target:GetAbsOrigin()
    local ability=keys.ability

    local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
    
    local damage =  caster:GetAverageTrueAttackDamage(caster) * 3
   
   
    TimerUtil.createTimerWithDelay(2, function()
            yg13blgj2 (ability,caster,target,point,damage,radius)
        end
    )

 --   Timers:CreateTimer(2,yg13blgj2 (ability,caster,point,damage,radius))

end
 
function yg13blgj2(ability,caster,target,point,damage,radius)
  
    
         local p1 = ParticleManager:CreateParticle("particles/test/xb_fmj_uicide_fire.vpcf",PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl( p1, 0, point )


   -- local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
            --                                  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    local units = FindAlliesInRadiusEx(target,point,radius)

   if units~=nil then
    for key, unit in pairs(units) do
           
        ApplyDamageMf(caster,unit,ability,damage)
        ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
     end
  end

end