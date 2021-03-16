boss_phoenix_stone_lua = class({})
LinkLuaModifier( "modifier_boss_phoenix_stone_lua","lua_modifiers/boss/boss_phoenix/modifier_boss_phoenix_stone_lua", LUA_MODIFIER_MOTION_NONE )


LinkLuaModifier( "stun_nothing","lua_modifiers/boss/stun_nothing", LUA_MODIFIER_MOTION_NONE )
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
function boss_phoenix_stone_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	if self.times==nil then
		self.times=4
	end
	if self:GetCaster():GetHealthPercent()<90 then
		self.times=6
	end
	if  self:GetCaster():GetHealthPercent()<60 then
		self.times=8
	end
	if  self:GetCaster():GetHealthPercent()<30 then
		self.times=12
	end
    for i=1,self.times do
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
						point = unit:GetAbsOrigin()+Vector(RandomInt(-200,200),RandomInt(-200,200))
					end				 
				end
			end
		end
    	local hThinker = CreateModifierThinker( self:GetCaster(), self, "modifier_boss_phoenix_stone_lua", { duration = 1.5 }, point, self:GetCaster():GetTeamNumber(), false )
    end
end

function boss_phoenix_stone_lua:GetCooldown( nLevel )

	if IsServer() then
		if self:GetCaster():HasModifier("modifier_boss_phoenix_turnegg_lua") then
			return self.BaseClass.GetCooldown( self, nLevel )/2	
		else
			self.BaseClass.GetCooldown( self, nLevel )
		end
	end
	return self.BaseClass.GetCooldown( self, nLevel )
end