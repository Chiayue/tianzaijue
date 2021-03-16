
modifier_bw_5_2 = class({})
LinkLuaModifier( "modifier_bw_5_2_buff", "lua_modifiers/baowu/modifier_bw_5_2_buff", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------

function modifier_bw_5_2:GetTexture()
	return "item_treasure/达贡之神力"
end

function modifier_bw_5_2:IsHidden()
	return true
end
--------------------------------------------------------------------------------
function modifier_bw_5_2:OnCreated( kv )
	if IsServer() then
		self:StartIntervalThink( 2 )
	end
end
function modifier_bw_5_2:OnRefresh()
	
end

--------------------------------------------------------------------------------

function modifier_bw_5_2:DeclareFunctions()
	local funcs = 
	{
		MODIFIER_PROPERTY_STATS_INTELLECT_BONUS,
		MODIFIER_PROPERTY_SPELL_AMPLIFY_PERCENTAGE,
	}
	return funcs
end


function modifier_bw_5_2:OnIntervalThink()
	if IsServer() then
		local caster=self:GetCaster()
		local point = caster:GetAbsOrigin()
		if caster ~= nil and caster:IsAlive() then
			local units = FindAlliesInRadiusExdd(caster,point,1000)
			local damage = caster:GetIntellect() * 160
			if #units >= 1 then
				local hTarget = units[1]
				local attachment = caster:ScriptLookupAttachment( "attach_attack1" )
				hTarget:AddNewModifier( hTarget, self, "modifier_bw_5_2_buff", {duration=3} )
				local info = 
							{
					Target = hTarget,
					Source = caster,
					Ability = self,
					EffectName = "particles/econ/items/morphling/morphling_ethereal/morphling_adaptive_strike_ethereal.vpcf",
					iMoveSpeed = 1000,
					vSourceLoc = caster:GetAttachmentOrigin( attachment ),
					bDodgeable = false,
					bProvidesVision = false,
					flExpireTime = GameRules:GetGameTime() +1,
					}

				ProjectileManager:CreateTrackingProjectile( info )
				ApplyDamageMf(caster,hTarget,self,damage)
			end		
		end
	end
end

function modifier_bw_5_2:GetModifierBonusStats_Intellect( params )
	return 33333
end
function modifier_bw_5_2:GetModifierSpellAmplify_Percentage( params )
	return 200
end
function modifier_bw_5_2:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT 
end
-----------------------------------------------------------------------

