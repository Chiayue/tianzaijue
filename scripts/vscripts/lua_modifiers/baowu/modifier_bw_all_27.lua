
modifier_bw_all_27 = class({})

--------------------------------------------------------------------------------

function modifier_bw_all_27:GetTexture()
	return "item_treasure/多重射击"
end
--------------------------------------------------------------------------------
function modifier_bw_all_27:IsHidden()
	return true
end
function modifier_bw_all_27:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_all_27:OnRefresh()
	if IsServer() then
		if self:GetParent():GetAttackCapability()==2 then
			self:SetStackCount(self:GetStackCount()+1)
		end
	end
end


function modifier_bw_all_27:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_EVENT_ON_ATTACK,
	}
	return funcs
end
function modifier_bw_all_27:OnAttack( params )
	local caster = params.attacker
	local target = params.target
	if caster ~= self:GetParent() then
		return nil
	end

	if caster == target then
		return;
	end
	if caster._SplitAttackStart then
		return;
	end
	
	local count = 1+self:GetStackCount()
	if count and count > 1 then
		--默认count代表的是攻击总数量，普通攻击已经有一个了，这里额外攻击数量少一个即可
		count = count - 1
	
		local radius = caster:Script_GetAttackRange()
		local projectile = caster:GetRangedProjectileName()
		local speed = caster:GetProjectileSpeed()
		
		local enemies = FindAlliesInRadiusExdd(caster,caster:GetAbsOrigin(),radius) --寻找玩家的敌对单位	
		if enemies then
			for key, unit in pairs(enemies) do
				if unit ~= target then
					---调用PerformAttack会触发modifier的OnAttack事件，从而导致重复进入这个函数，
					--出现死循环。所以这里加一个标记
					caster._SplitAttackStart = true
					pcall(function()
						--倒数第二个参数：bFakeAttack如果为true，则不会造成伤害
						--第三个参数如果为false，则会触发OnAttack事件，但是不会触发其余的几个事件（start、land、finish），这样有些攻击命中才生效的逻辑就不会触发了
						--PerformAttack(handle hTarget, bool bUseCastAttackOrb, bool bProcessProcs, bool bSkipCooldown, bool bIgnoreInvis, bool bUseProjectile, bool bFakeAttack, bool bNeverMiss)
						caster:PerformAttack(unit,true,true,true,true,true,false,false)
					end)
					caster._SplitAttackStart = false
					
					count = count - 1
					if count == 0 then
						break;
					end
				end
			end
		end
	end
end
function modifier_bw_all_27:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end