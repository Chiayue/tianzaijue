modifier_bw_all_100 = class( {} )

LinkLuaModifier( "modifier_bw_all_100_buff", "lua_modifiers/baowu/modifier_bw_all_100_buff", LUA_MODIFIER_MOTION_NONE )


function modifier_bw_all_100:GetIntrinsicModifierName()
	return "modifier_bw_all_100_buff"
end

------------------------------------------------------------------
function modifier_bw_all_100:OnProjectileHit( hTarget, vLocation )
	if IsServer() then
		if hTarget ~= nil and hTarget:IsAlive()  then
			local caster=self:GetCaster()
			local damage = caster:GetIntellect() * (5+caster:GetLevel()/6)
			ApplyDamageMf(caster,hTarget,nil,damage)
			EmitSoundOn( "Hero_Sven.StormBoltImpact", hTarget )
		
		end
	end

	return true
end