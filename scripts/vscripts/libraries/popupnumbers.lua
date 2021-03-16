

PopupNum = {
  POPUP_SYMBOL_PRE_PLUS = 0,           --加号
  POPUP_SYMBOL_PRE_MINUS = 1,          --减号
  POPUP_SYMBOL_PRE_SADFACE = 2,        --悲伤的脸
  POPUP_SYMBOL_PRE_BROKENARROW = 3,    --断开的箭
  POPUP_SYMBOL_PRE_SHADES = 4,         --墨镜
  POPUP_SYMBOL_PRE_MISS = 5,           --MISS,丢失
  POPUP_SYMBOL_PRE_EVADE = 6,          --EVADE,回避
  POPUP_SYMBOL_PRE_DENY = 7,           --DENY,否决
  POPUP_SYMBOL_PRE_ARROW = 8,          --向上的箭头
   
  POPUP_SYMBOL_POST_EXCLAMATION = 0,   --无
  POPUP_SYMBOL_POST_POINTZERO = 1,     --".0"
  POPUP_SYMBOL_POST_MEDAL = 2,         --勋章
  POPUP_SYMBOL_POST_DROP = 3,          --水滴
  POPUP_SYMBOL_POST_LIGHTNING = 4,     --闪电
  POPUP_SYMBOL_POST_SKULL = 5,        --骷髅
  POPUP_SYMBOL_POST_EYE = 6,           --眼睛
  POPUP_SYMBOL_POST_SHIELD = 7,        --盾牌
  POPUP_SYMBOL_POST_POINTFIVE = 8,     --".5"
  
  green = Vector(0, 255, 0), --绿色
  red = Vector(255, 0, 0), --红色
  fuchsia = Vector(215, 50, 248),--紫红色
  white = Vector(255, 255, 255), --白色
  orange = Vector(255, 200, 33),--橘色
  
  
};
--  治疗（正数，前面带一个加号）
function PopupNum:PopupHealing(target, amount)
    PopupNum:PopupNumbers(target, "heal", PopupNum.green , 1.0, amount, PopupNum.POPUP_SYMBOL_PRE_PLUS, nil)
end
 
--大量伤害（正数，后面是个雨滴）
function PopupNum:PopupDamage(target, amount)
    PopupNum:PopupNumbers(target, "damage", PopupNum.red , 1.0, amount, nil, PopupNum.POPUP_SYMBOL_POST_DROP)
end
 
-- 暴击伤害（正数，后面有闪电）
function PopupNum:PopupCriticalDamage(target, amount)
    PopupNum:PopupNumbers(target, "crit", PopupNum.red, 1.0, amount, nil, PopupNum.POPUP_SYMBOL_POST_LIGHTNING)
end
 
-- 持续的毒性伤害（正数，后面有个眼睛）
function PopupNum:PopupDamageOverTime(target, amount)
    PopupNum:PopupNumbers(target, "poison", PopupNum.fuchsia , 1.0, amount, nil, PopupNum.POPUP_SYMBOL_POST_EYE)
end
 
-- 格挡伤害（负数）
function PopupNum:PopupDamageBlock(target, amount)
    PopupNum:PopupNumbers(target, "block", PopupNum.white, 1.0, amount, PopupNum.POPUP_SYMBOL_PRE_MINUS, nil)
end
 
-- e.g. when last-hitting a creep
function PopupNum:PopupGoldGain(target, amount)
    PopupNum:PopupNumbers(target, "gold", PopupNum.orange , 1.0, amount, PopupNum.POPUP_SYMBOL_PRE_PLUS, nil)
end
 
-- 丢失
function PopupNum:PopupMiss(target)
    PopupNum:PopupNumbers(target, "miss", PopupNum.red, 1.0, nil, PopupNum.POPUP_SYMBOL_PRE_MISS, nil)
end
 
-- Customizable version.
function PopupNum:PopupNumbers(target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_OVERHEAD_FOLLOW, target) -- target:GetOwner()
    
    --只显示整数
    number = math.floor(number)
 
    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end
 
    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
    
    --销毁特效
    TimerUtil.createTimerWithDelay(lifetime,function()
      ParticleManager:DestroyParticle(pidx,false) --第二个参数，表示是否立即销毁
    end)
end