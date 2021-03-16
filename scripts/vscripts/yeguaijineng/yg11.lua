function yg11shjs( keys )
    local caster = keys.caster
    local target = keys.target
 
    --获取技能等级
    local i = keys.ability:GetLevel() - 1
 
    --获取伤害加成
    local damage_per =  caster:GetAverageTrueAttackDamage(caster)*0.5
 
    --如果标记在被攻击目标身上的伤害为nil，进行初始化
    if target:GetContext("yg11_1")==nil then
        target:SetContextNum("yg11_1", 0, 0) 
    end
 
    --标记叠加的伤害到被攻击的目标身上
    target:SetContextNum("yg11_1", target:GetContext("yg11_1") + damage_per, 0) 
 
    --创建伤害table
    local damageTable = {victim=target,
                        attacker=caster,
                        damage_type=DAMAGE_TYPE_PHYSICAL,
                        damage=target:GetContext("yg11_1")}
    --造成伤害
    ApplyDamage(damageTable)
end
 
function yg11shjs_over( keys )
    local target = keys.target
 
    --重置被攻击目标身上的伤害叠加
    target:SetContextNum("yg11_1", 0, 0)
end
 

