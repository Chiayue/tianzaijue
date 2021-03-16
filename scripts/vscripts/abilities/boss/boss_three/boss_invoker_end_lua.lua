boss_invoker_end_lua = class({})
LinkLuaModifier( "modifier_boss_invoker_sun_lua","lua_modifiers/boss/boss_three/modifier_boss_invoker_sun_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_thunder_lua","lua_modifiers/boss/boss_three/modifier_boss_invoker_thunder_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_thunder_lua_effect","lua_modifiers/boss/boss_three/modifier_boss_invoker_thunder_lua_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_puncture_lua","lua_modifiers/boss/boss_three/modifier_boss_invoker_puncture_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_invoker_ice_lua","lua_modifiers/boss/boss_three/modifier_boss_invoker_ice_lua", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "lower_movespeed","lua_modifiers/boss/lower_movespeed", LUA_MODIFIER_MOTION_NONE )

LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_invoker_end_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	local monster={"npc_invoker_fire","npc_invoker_dust","npc_invoker_water","npc_invoker_thender"}
	local random=RandomInt(1, 4)
	local ab=hCaster:FindAbilityByName("boss_invoker_call_lua")
	

	--if self.time == nil then
	--	self.time = 0
	--end
	--self.time = self.time + 1

	if ab~=nil then
		local sl = 0
		if Stage.kezhw then
			sl = #Stage.kezhw
		end
		local num= 2+  Stage.playernum + sl
		if num >  GetGameDifficulty() *Stage.playernum /2 then
			num =  GetGameDifficulty()*Stage.playernum /2
		end
		if num < 4 then
			num = 4
		end
		if num > 12  then
			num = 12
		end

	    for i=1,num do
	    	if random==1 then
	    		local point = hCaster:GetOrigin()+Vector(RandomInt(-1500,1500),RandomInt(-1500,1500))
	    		if RollPercent(50) then		--50%的概率，技能会对着人放，可能会对单人不太友好,到时候根据玩家数量设置概率吧
					local units= FindAlliesInRadiusExdd(hCaster,hCaster:GetAbsOrigin(),2500)
					local unit = nil
					local i = 0
					if units then
						for k,v in pairs(units) do
							if i == 0 then			
								i = i +1
								unit = v
								point = unit:GetAbsOrigin()+Vector(RandomInt(-100,100),RandomInt(-100,100))
							end				 
						end
					end
				end
	    		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_invoker_sun_lua", { duration = 1.5 }, point, self:GetCaster():GetTeamNumber(), false )
	    	end
	    	if random==2 then
	    		self.stat=2
	    		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_invoker_puncture_lua", { duration = 1.5 }, hCaster:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	    	end
	    	if random==3 then
	    		self.stat=1
	    		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_invoker_ice_lua", { duration = 1.5 }, hCaster:GetOrigin(), self:GetCaster():GetTeamNumber(), false )
	    	end
	    	if random==4 then
	    		local point = hCaster:GetOrigin()+Vector(RandomInt(-1500,1500),RandomInt(-1500,1500))
	    		if RollPercent(50) then		--50%的概率，技能会对着人放，可能会对单人不太友好,到时候根据玩家数量设置概率吧
					local units= FindAlliesInRadiusExdd(hCaster,hCaster:GetAbsOrigin(),2500)
					local unit = nil
					local i = 0
					if units then
						for k,v in pairs(units) do
							if i == 0 then			
								i = i +1
								unit = v
								point = unit:GetAbsOrigin()+Vector(RandomInt(-100,100),RandomInt(-100,100))
							end				 
						end
					end
				end
	    		local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_invoker_thunder_lua", { duration = 1.5 }, point, self:GetCaster():GetTeamNumber(), false )
	    	end    
		end
	end
end

function boss_invoker_end_lua:OnProjectileHit( hTarget, vLocation )

	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		if self.stat==1 then
			local buff=hTarget:AddNewModifier( hCaster, self, "lower_movespeed", {duration=3} )
			buff:SetStackCount(40)
			EmitSoundOn( "hero_jakiro.projectileImpact", hTarget )
			local damageInfo =
						{
							victim = hTarget,
							attacker = self:GetCaster(),
							damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*3,
							damage_type = DAMAGE_TYPE_MAGICAL,
							ability = self,
						}
					ApplyDamage( damageInfo )
			

		else
			local hCaster=self:GetCaster()
			hTarget:AddNewModifier( hCaster, self, "stun_nothing", {duration=2} )
			EmitSoundOn( "Hero_Lion.ImpaleHitTarget", hTarget )
			local damageInfo =
						{
							victim = hTarget,
							attacker = self:GetCaster(),
							damage = self:GetCaster():GetAverageTrueAttackDamage(self:GetCaster())*3,
							damage_type = DAMAGE_TYPE_PURE,
							ability = self,
						}
					ApplyDamage( damageInfo )
			
			
		end
		
	end

	return false
end
function boss_invoker_end_lua:GetCooldown( nLevel )
	if IsServer() then
		local cd = self.BaseClass.GetCooldown( self, nLevel )- 0.15*GameRules:GetCustomGameDifficulty()
		if self:GetCaster():HasModifier("modifier_boss_invoker_end_lua_bloodfier") then
			cd = cd / 2
			return cd 
		end
		return cd
	end

end