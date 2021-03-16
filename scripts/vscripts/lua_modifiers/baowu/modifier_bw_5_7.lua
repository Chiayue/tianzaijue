
modifier_bw_5_7 = class({})
LinkLuaModifier( "modifier_bw_5_7_buff", "lua_modifiers/baowu/modifier_bw_5_7_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_5_7:GetTexture()
	return "item_treasure/林野长弓"
end
--------------------------------------------------------------------------------
function modifier_bw_5_7:IsHidden()
	return true
end
function modifier_bw_5_7:OnCreated( kv )
	
	self:OnRefresh()
end


function modifier_bw_5_7:OnRefresh()
	self.bIsCrit = false
end



function modifier_bw_5_7:DeclareFunctions()
	local funcs = 
	{

		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PREATTACK_CRITICALSTRIKE,
	}
	return funcs
end


function modifier_bw_5_7:OnAttackLanded( params )

	if IsServer() then
		-- play sounds and stuff
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			hTarget:AddNewModifier( hTarget, nil, "modifier_bw_5_7_buff", {duration=3} )
			if hTarget ~= nil and self.bIsCrit then
				local vDir = ( self:GetParent():GetAbsOrigin() - hTarget:GetAbsOrigin() ):Normalized()
				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
				ParticleManager:SetParticleControlEnt( nFXIndex, 0, hTarget, PATTACH_POINT_FOLLOW, "attach_hitloc", hTarget:GetAbsOrigin(), true )
				ParticleManager:SetParticleControl( nFXIndex, 1, hTarget:GetAbsOrigin() )
				ParticleManager:SetParticleControlForward( nFXIndex, 1, vDir )
				ParticleManager:SetParticleControlEnt( nFXIndex, 10, hTarget, PATTACH_ABSORIGIN_FOLLOW, nil, hTarget:GetAbsOrigin(), true )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
				EmitSoundOn( "Ability.CoupDeGrace", self:GetParent() )
				self.bIsCrit = false
			end
		end
	end

	return 0.0

end
function modifier_bw_5_7:GetModifierPreAttack_CriticalStrike( params )
	if IsServer() then
		local hTarget = params.target
		local hAttacker = params.attacker

		if hTarget and ( hTarget:IsBuilding() == false ) and ( hTarget:IsOther() == false ) 
				and hAttacker and ( hAttacker == self:GetParent() )
				and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
			if RollPseudoRandomPercentage( 12, DOTA_PSEUDO_RANDOM_CUSTOM_GAME_1, hAttacker ) == true then
				self.bIsCrit = true
				return 5000
			end
		end
	end

	return 0
end
function modifier_bw_5_7:GetModifierPreAttack_BonusDamage( params )
	return 77777
end

function modifier_bw_5_7:GetModifierAttackSpeedBonus_Constant( params )
	return 122
end
function modifier_bw_5_7:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end