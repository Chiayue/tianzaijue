
modifier_bw_5_1 = class({})
LinkLuaModifier( "modifier_bw_5_1_buff", "lua_modifiers/baowu/modifier_bw_5_1_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_5_1:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_5_1:IsHidden()
	return true
end
function modifier_bw_5_1:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_1:OnRefresh()
	
end


function modifier_bw_5_1:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_STATS_STRENGTH_BONUS,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end


function modifier_bw_5_1:OnAttackLanded( params )
	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local caster = self:GetParent()
			local hTarget = params.target
			if hTarget ~= nil  then
				if RollPercent(20) then
					local particle = ParticleManager:CreateParticle( "particles/econ/items/zeus/arcana_chariot/zeus_arcana_blink_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, hTarget )
					ParticleManager:SetParticleControl( particle, 0, hTarget:GetAbsOrigin())
					local damage = caster:GetAgility() * 120
					hTarget:AddNewModifier( hTarget, self, "modifier_bw_5_1_buff", {duration=3} )
					ApplyDamageEx(caster,hTarget,self,damage)
				end	
			end
		end
	end
end
function modifier_bw_5_1:GetModifierPreAttack_BonusDamage( params )
	return 50000
end
function modifier_bw_5_1:GetModifierBonusStats_Strength( params )
	return 25000
end
function modifier_bw_5_1:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end