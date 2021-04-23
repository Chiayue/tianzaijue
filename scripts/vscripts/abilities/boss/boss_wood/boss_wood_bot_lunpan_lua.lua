boss_wood_bot_lunpan_lua = class({})
LinkLuaModifier( "modifier_boss_wood_bot_lunpan_lua","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_lunpan_lua", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_bot_lunpan_lua_effect","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_lunpan_lua_effect", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_boss_wood_bot_lunpan_end_lua","lua_modifiers/boss/boss_wood/modifier_boss_wood_bot_lunpan_end_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------
function boss_wood_bot_lunpan_lua:OnSpellStart()
	local hCaster = self:GetCaster()
	if self.lunpan==nil then
		self.lunpan={}
	end
	local num = 6
	local hp = hCaster:GetHealthPercent()
	if hp <= 80  then
		num =num +2
	end
	if hp <= 50  then
		num =num +2
	end
	if hp <= 30  then
		num =num +2
	end
	if hp <= 10  then
		num =num +2
	end
	local point2 = hCaster:GetOrigin() + RandomVector(1000)
	local jd = 360/num 
    for i=1,num do
    	point2 = RotateVector2DWithCenter(hCaster:GetOrigin(),point2,jd)
  		local jl = RandomInt(200,1600) * GetForwardVector(hCaster:GetOrigin(),point2)
    	local point=hCaster:GetOrigin()+ jl	
    	local unit=CreateUnitByName("npc_wood_bot_lunpan",point, true, hCaster, hCaster, hCaster:GetTeamNumber() )
    	unit:AddNewModifier(hCaster, self, "modifier_boss_wood_bot_lunpan_lua", {})
    	unit:AddNewModifier(hCaster, self, "modifier_boss_wood_bot_lunpan_end_lua", {})
    	
    	unit:AddNewModifier(hCaster, self, "modifier_kill", {duration=15})
    	table.insert(self.lunpan,unit)
    end
    
end

function boss_wood_bot_lunpan_lua:GetCooldown( nLevel )
	return self.BaseClass.GetCooldown( self, nLevel )
end