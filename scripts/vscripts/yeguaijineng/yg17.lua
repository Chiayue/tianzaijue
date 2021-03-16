function yg17bczj( keys )
    local caster = keys.caster
    local target = keys.target
    local point = target:GetAbsOrigin()
    local ability=keys.ability

    local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
    
    local damage =  caster:GetAverageTrueAttackDamage(caster) * 3
   
  
    TimerUtil.createTimerWithDelay(2, function()
            yg17bczj2 (ability,caster,target,point,damage,radius)
        end
    )


end
 
function yg17bczj2(ability,caster,target,point,damage,radius)
  
    
         local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_leshrac/leshrac_split_earth.vpcf",PATTACH_ABSORIGIN,caster)
     ParticleManager:SetParticleControl( p1, 0, point )
      ParticleManager:SetParticleControl( p1, 1, Vector(radius,1,1)  )

    local units = FindAlliesInRadiusEx(target,point,radius)

   if units~=nil then
    for key, unit in pairs(units) do
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_yg17_1_2", {duration=stun_time})  
        ApplyDamageMf(caster,unit,ability,damage)
        ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
     end
  end

end