

function feast_heal( keys )
  local attacker = keys.attacker
  local target = keys.target
  local ability = keys.ability

  local hp_leech_percent = ability:GetLevelSpecialValueFor("hp_leech_percent", ability:GetLevel() - 1)
  local damage = attacker:GetMaxHealth() * (hp_leech_percent / 100)
  ApplyDamageEx(attacker,target,ability,damage) 
  local heal = damage*0.1
  if heal > 100000000 then
  	heal = 100000000
  end
  attacker:Heal(heal, ability)
end
