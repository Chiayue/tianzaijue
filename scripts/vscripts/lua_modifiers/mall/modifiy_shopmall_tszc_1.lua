


modifiy_shopmall_tszc_1 = class({})

--------------------------------------------------------------------------------

function modifiy_shopmall_tszc_1:GetTexture()
	return "rune/shopmall_tszc_1"
end
--------------------------------------------------------------------------------
function modifiy_shopmall_tszc_1:IsHidden()
	return true
end
function modifiy_shopmall_tszc_1:OnCreated( kv )
	if IsServer(  ) then
	end
end
function modifiy_shopmall_tszc_1:DeclareFunctions()
	local funcs = {

		MODIFIER_EVENT_ON_ABILITY_EXECUTED
	}

	return funcs
end
--------------------------------------------------------------------------------
-- Initializations


function modifiy_shopmall_tszc_1:OnAbilityExecuted( params )
	if not IsServer() then return end
	local caster = self:GetParent()
	if caster:HasModifier("zlyx_as") then --如果拥有智力英雄的多重施法就nil
		return nil
	end
	local ability = params.ability
	if params.unit~=caster then return end
	if caster:PassivesDisabled() then return end
	if not ability then return end
	if ability:IsItem() or ability:IsToggle() then return end
	if ability:GetAbilityName() =="ability_hero_2" then return end
	local abilityname = string.sub(ability:GetAbilityName(),1,6)
	if abilityname == "yxtfjn" then return end
	if caster:GetPrimaryAttribute() ~= 2 then
    	if RollPercent(25) then
			return nil
		end
    end
	local point = ability:GetCursorPosition()
	local target = ability:GetCursorTarget()
	local num  = 0
	local roll = 0
	local num2 = 1
	local zl = caster:GetIntellect()
	if zl >= 100000 then
		num = 3
	elseif zl >= 10000 then
		num = 2
		roll = math.floor(zl /1000)
		if RollPercent(roll) then
			num = 3
		end
	elseif zl >=1000 then
		num = 1
		roll = math.floor(zl /100)
		if RollPercent(roll) then
			num = 2
		end
	elseif zl>=100 then
		roll = math.floor(zl /10)
		if RollPercent(roll) then
			num = 1
		end
	end
	num = num + caster.cas_table.dcsfcs
	if num == 0 then
		return nil
	end
	local bfb = 0.6
	if caster:HasModifier("modifier_yxtfjn_bsrxt") then
    	bfb = bfb *0.5
    end
	TimerUtil.createTimerWithDelay(0.4,function()
    	if num > 0 then
    		local mp = caster:GetMana()
    		local xhmp = ability:GetManaCost(-1) * bfb
    		if mp >= xhmp then
    			caster:ReduceMana(xhmp)
    		else
    			return nil
    		end
	    	num2 = num2 + 1	
	    	local prt = ParticleManager:CreateParticle('particles/units/heroes/hero_ogre_magi/ogre_magi_multicast.vpcf', PATTACH_OVERHEAD_FOLLOW, self:GetParent())
			ParticleManager:SetParticleControl(prt, 1, Vector(num2, 0, 0))
			num  = num  - 1
			bfb = bfb * 2
			if point then
				 self:GetParent():SetCursorPosition(RandomPosInRadius(point,100,50))
			end
			if target then
				self:GetParent():SetCursorCastTarget(target)
			end
			 params.ability:OnSpellStart()
		return 0.3
		end
	end)
end


function modifiy_shopmall_tszc_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end



function modifiy_shopmall_tszc_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end