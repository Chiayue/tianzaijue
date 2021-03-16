

function feast_heal( keys )
  local attacker = keys.attacker
  local target = keys.target
  local ability = keys.ability

  local hp_leech_percent = ability:GetLevelSpecialValueFor("hp_leech_percent", ability:GetLevel() - 1)
  local damage = attacker:GetMaxHealth() * (hp_leech_percent / 100)
  ApplyDamageEx(attacker,target,ability,damage) 
  attacker:Heal(damage*0.1, ability)
end
