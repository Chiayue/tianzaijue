function secount(event)
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local modifyname=event.modify
    local buff=target:FindModifierByName(modifyname)
    buff:SetStackCount(math.ceil(target:GetHealthRegen()*0.8))
    
end
function qiangzhuangtizhi_secount_armor(event)
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local modifyname=event.modify
    local buff=target:FindModifierByName(modifyname)
    buff:SetStackCount(math.ceil(target:GetPhysicalArmorValue(false)*0.3))
    
end
function qiangzhuangtizhi_secount_health(event)
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    LinkLuaModifier( "mofifire_qiangzhuangtizhi","lua_modifiers/creature/mofifire_qiangzhuangtizhi", LUA_MODIFIER_MOTION_NONE )
    target:AddNewModifier( caster, this_ability, "mofifire_qiangzhuangtizhi", {} )
    
end
function qiangzhuangtizhi_secount_health_des(event)
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    target:RemoveModifierByName("mofifire_qiangzhuangtizhi")
    
end
function xianji_setdamage(event)
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    if caster == nil or caster:IsNull() then
        return
    end
    local damage =
			{
				victim = target,
				attacker = caster,
				damage = 1*caster:GetAverageTrueAttackDamage(caster),
				damage_type = this_ability:GetAbilityDamageType(),
				ability = this_ability
			}
			ApplyDamage( damage )
    
end
function siwangzuzhou(event)
    PrintTable(event)
    local caster = event.caster
    local target = event.attacker
    local this_ability = event.ability
    
end
function tuzhimaidong_set(event)
    
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local buff = event.buff
    local debuff = event.debuff
    if target:GetTeamNumber()==caster:GetTeamNumber() then
        this_ability:ApplyDataDrivenModifier(caster, target, debuff, {})
    else
        this_ability:ApplyDataDrivenModifier(caster, target, buff, {})
    end
    
end
function tuzhimaidong_des(event)
    
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local buff = event.buff
    local debuff = event.debuff
    target:RemoveModifierByName(buff)
    target:RemoveModifierByName(debuff)
    
end
function fenzhizhufu_set(event)
    
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local buff = event.buff
    local debuff = event.debuff
    
    if target:GetTeamNumber()==caster:GetTeamNumber() then
        this_ability:ApplyDataDrivenModifier(caster, target, buff, {})
    else
        this_ability:ApplyDataDrivenModifier(caster, target, debuff, {})
    end
    
end
function fenzhizhufu_des(event)
    
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local buff = event.buff
    local debuff = event.debuff
    target:RemoveModifierByName(buff)
    target:RemoveModifierByName(debuff)
    
end
function getperson(event)
    local caster = event.caster
    local this_ability = event.ability
    local talent=this_ability:GetSpecialValueFor("talent")
    local plus=this_ability:GetSpecialValueFor("plus")
    local name="npc_boss_phoenix"
	local sxxx=CreateUnitByName(name,Vector(0,0) , true, nil, nil, DOTA_TEAM_BADGUYS )
    --sxxx:SetControllableByPlayer(caster:GetPlayerOwnerID(), true)
    
    local abname=CC_AB.ablist[RandomInt(1,#CC_AB.ablist)]
    sxxx:AddAbility(abname):SetLevel(1)
    local PlusAbTable=table_repeat_no(CC_AB.ablist_plus,plus)
     for i=1,#PlusAbTable do
        sxxx:AddAbility(PlusAbTable[i]):SetLevel(1)
     end
end
function buqunuhou(event)
    
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local buff = event.buff
    if this_ability:IsCooldownReady() and caster:GetHealthPercent()<50 then
        this_ability:ApplyDataDrivenModifier(caster, caster, buff, {duration=10})
        this_ability:StartCooldown(this_ability:GetCooldown(1))
    end
    
    
end
function yilibudao(event)
    
    local caster = event.caster
    local target = event.target
    local this_ability = event.ability
    local buff = event.buff
    if this_ability:IsCooldownReady() and caster:GetHealthPercent()<50 then
        this_ability:ApplyDataDrivenModifier(caster, caster, buff, {duration=10})
        this_ability:StartCooldown(this_ability:GetCooldown(1))
    end
    
    
end

