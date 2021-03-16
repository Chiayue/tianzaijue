function yg27bsdj( keys )
    local caster = keys.caster
    local target = keys.target
    local point = target:GetAbsOrigin()
    local ability=keys.ability

    local radius = keys.ability:GetLevelSpecialValueFor("radius", keys.ability:GetLevel())
    
    local damage =  caster:GetAverageTrueAttackDamage(caster) *3
   

  local p1 = ParticleManager:CreateParticle("particles/units/heroes/hero_ancient_apparition/ancient_ice_vortex.vpcf",PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl( p1, 0, point )
   
    TimerUtil.createTimerWithDelay(1.5, function()
             ParticleManager:DestroyParticle(p1,true)
            yg27bsdj2 (ability,caster,target,point,damage,radius)
        end
    )

 --   Timers:CreateTimer(2,yg13blgj2 (ability,caster,point,damage,radius))

end
 
function yg27bsdj2(ability,caster,target,point,damage,radius)
  
    
    local p1 = ParticleManager:CreateParticle("particles/econ/items/crystal_maiden/crystal_maiden_cowl_of_ice/maiden_crystal_nova_cowlofice.vpcf",PATTACH_ABSORIGIN,caster)
    ParticleManager:SetParticleControl( p1, 0, point )
     ParticleManager:SetParticleControl( p1, 1, Vector(radius,1,1)  )

    TimerUtil.createTimerWithDelay(1.5, function()
             ParticleManager:DestroyParticle(p1,true)          
        end
    )
   -- local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, point, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, 
            --                                  DOTA_UNIT_TARGET_BASIC, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
    local units = FindAlliesInRadiusEx(target,point,radius)

   if units~=nil then
    for key, unit in pairs(units) do
        ability:ApplyDataDrivenModifier(caster, unit, "modifier_yg27_1_2", {duration=stun_time})  
        ApplyDamageEx(caster,unit,ability,damage)
        ShowOverheadMsg(unit,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
     end
  end

end


--[[
  Author: Ractidous
  Date: 27.01.2015.
  Launch the icy breath
]]
function Launch_IcyBreath( event )
  local caster = event.caster
  local ability = event.ability

  local casterOrigin = caster:GetAbsOrigin()
  local targetPos = event.target_points[1]
  local direction = targetPos - casterOrigin
  direction = direction / direction:Length2D()

  ProjectileManager:CreateLinearProjectile( {
    Ability       = ability,
  --  EffectName      = "",
    vSpawnOrigin    = casterOrigin,
    fDistance     = event.distance,
    fStartRadius    = event.start_radius,
    fEndRadius      = event.end_radius,
    Source        = caster,
    bHasFrontalCone   = true,
    bReplaceExisting  = false,
    iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType   = DOTA_UNIT_TARGET_BASIC,
  --  fExpireTime     = ,
    bDeleteOnHit    = false,
    vVelocity     = direction * event.speed,
    bProvidesVision   = false,
  --  iVisionRadius   = ,
  --  iVisionTeamNumber = caster:GetTeamNumber(),
  } )

  local particleName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_ice.vpcf"
  local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
  ParticleManager:SetParticleControl( pfx, 0, casterOrigin )
  ParticleManager:SetParticleControl( pfx, 1, direction * event.speed * 1.333 )
  ParticleManager:SetParticleControl( pfx, 3, Vector(0,0,0) )
  ParticleManager:SetParticleControl( pfx, 9, casterOrigin )

  caster:SetContextThink( DoUniqueString( "destroy_particle" ), function ()
    ParticleManager:DestroyParticle( pfx, false )
  end, event.distance / event.speed )
end

--[[
  Author: Ractidous
  Date: 27.01.2015.
  Launch the fiery breath
]]
function Launch_FieryBreath( event )
  local caster = event.caster
  local fieryAbility = caster:FindAbilityByName( event.fiery_ability_name )

  local casterOrigin = caster:GetAbsOrigin()
  local targetPos = event.target_points[1]
  local direction = targetPos - casterOrigin
  direction = direction / direction:Length2D()

  ProjectileManager:CreateLinearProjectile( {
    Ability       = fieryAbility,
  --  EffectName      = "",
    vSpawnOrigin    = casterOrigin,
    fDistance     = event.distance,
    fStartRadius    = event.start_radius,
    fEndRadius      = event.end_radius,
    Source        = caster,
    bHasFrontalCone   = true,
    bReplaceExisting  = false,
    iUnitTargetTeam   = DOTA_UNIT_TARGET_TEAM_ENEMY,
    iUnitTargetFlags  = DOTA_UNIT_TARGET_FLAG_NONE,
    iUnitTargetType   = DOTA_UNIT_TARGET_BASIC,
  --  fExpireTime     = ,
    bDeleteOnHit    = false,
    vVelocity     = direction * event.speed,
    bProvidesVision   = false,
  --  iVisionRadius   = ,
  --  iVisionTeamNumber = caster:GetTeamNumber(),
  } )

  local particleName = "particles/units/heroes/hero_jakiro/jakiro_dual_breath_fire.vpcf"
  local pfx = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN, caster )
  ParticleManager:SetParticleControl( pfx, 0, casterOrigin )
  ParticleManager:SetParticleControl( pfx, 1, direction * event.speed * 1.333 )
  ParticleManager:SetParticleControl( pfx, 3, Vector(0,0,0) )
  ParticleManager:SetParticleControl( pfx, 9, casterOrigin )

  caster:SetContextThink( DoUniqueString( "destroy_particle" ), function ()
    ParticleManager:DestroyParticle( pfx, false )
  end, event.distance / event.speed )
end

--[[
  Author: Ractidous
  Date: 26.01.2015.
  Apply burn modifier to the target.
]]
function OnProjectileHit_Fiery( event )
  local caster = event.caster
  local target = event.target
  local ability = caster:FindAbilityByName( event.main_ability_name )

  ability:ApplyDataDrivenModifier( caster, target, event.modifier_name, {} )
end

function yg27hbtx( keys )
  
  local caster = keys.caster
  local target = keys.target
  local ability = keys.ability
  local damage =  caster:GetAverageTrueAttackDamage(caster) * 5
  
  ApplyDamageMf(caster,target,ability,damage)
  --显示一个特殊效果
  ShowOverheadMsg(target,OVERHEAD_ALERT_BONUS_SPELL_DAMAGE,damage)
        

end