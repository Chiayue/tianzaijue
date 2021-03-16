
modifier_bw_5_5 = class({})
LinkLuaModifier( "modifier_bw_5_5_buff", "lua_modifiers/baowu/modifier_bw_5_5_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_5_5:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_5_5:IsHidden()
	return true
end
function modifier_bw_5_5:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_5:OnRefresh()
	
end
function modifier_bw_5_5:OnDestroy()
	if IsServer() then
		
	end
end


function modifier_bw_5_5:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_AGILITY_BONUS,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end


function modifier_bw_5_5:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local caster = self:GetParent()
			local hTarget = params.target
			if hTarget ~= nil  then
				if RollPercent(30) then
					local particle = ParticleManager:CreateParticle( "particles/econ/items/luna/luna_lucent_ti5_gold/luna_eclipse_impact_notarget_moonfall_gold.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
					ParticleManager:SetParticleControl( particle, 0, hTarget:GetAbsOrigin())
					ParticleManager:SetParticleControl( particle, 1, hTarget:GetAbsOrigin())
					ParticleManager:SetParticleControl( particle, 5, hTarget:GetAbsOrigin())
					local damage = caster:GetAgility() * 88
					ApplyDamageEx(caster,hTarget,nil,damage)
				end	
				if not caster:HasModifier("modifier_bw_5_5_buff") then	
					if RollPercent(1) then
						caster:AddNewModifier( caster, caster, "modifier_bw_5_5_buff", {duration=3} )
						caster:SetModifierStackCount( "modifier_bw_5_5_buff",caster, math.ceil(caster:GetBaseAgility()*1.5) )
					end
				end
			end
		end
	end
end

function modifier_bw_5_5:GetModifierBonusStats_Agility( params )
	return 20000
end
function modifier_bw_5_5:GetModifierPreAttack_BonusDamage( params )
	return 46666
end

function modifier_bw_5_5:GetModifierAttackSpeedBonus_Constant( params )
	return 100
end
function modifier_bw_5_5:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end