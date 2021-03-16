yxtfjn_zimao = class({})
LinkLuaModifier("modifier_yxtfjn_zimao", "yingxiongjineng/modifier_yxtfjn_zimao.lua", LUA_MODIFIER_MOTION_HORIZONTAL )
LinkLuaModifier("modifier_yxtfjn_zimao_move", "yingxiongjineng/modifier_yxtfjn_zimao_move.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------
function yxtfjn_zimao:Precache( hContext )
	
	PrecacheResource( "particle", "particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf", hContext )
	
end
function yxtfjn_zimao:OnAbilityPhaseStart()
	EmitSoundOn( "Hero_VoidSpirit.AstralStep.Start", self:GetCaster() )
	return true
end
--------------------------------------------------------------------------------

function yxtfjn_zimao:OnSpellStart()
	local hCaster=self:GetCaster()
	local vPos = nil
	vPos = self:GetCursorPosition()
	self.EndPos=vPos
	self.StartPos=hCaster:GetOrigin()
	self.distenceper=100
	self.vDirection = vPos- self.StartPos
	self.vDirection.z = 0.0
	self.vDirection = self.vDirection:Normalized()
	--hCaster:AddNewModifier( hCaster, self, "modifier_yxtfjn_zimao_move", {duration=11} )
	if GridNav:CanFindPath( self.StartPos, vPos ) then
  	  self:SetNewPlace(vPos)
  	end
end
function yxtfjn_zimao:GetIntrinsicModifierName()
	return "modifier_yxtfjn_zimao"
end
function yxtfjn_zimao:SetNewPlace(vPos)
    local hCaster=self:GetCaster()
 	local i  = self:GetSpecialValueFor( "i" )
	self.particleID = ParticleManager:CreateParticle("particles/units/heroes/hero_void_spirit/astral_step/void_spirit_astral_step.vpcf",PATTACH_WORLDORIGIN,hCaster)--火女火焰灰烬特效
    ParticleManager:SetParticleControl(self.particleID,0,hCaster:GetOrigin())
    ParticleManager:SetParticleControl(self.particleID,1,vPos)
    local units = FindUnitsInLine( hCaster:GetTeamNumber(),hCaster:GetOrigin(),vPos, nil, 300, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, FIND_ANY_ORDER  )
	local damage = i*hCaster:GetIntellect()
	if units ~= nil then
        for key, unit in pairs(units) do
            ApplyDamageMf(hCaster,unit,ability,damage)
        end	
    end
    EmitSoundOn( "Hero_VoidSpirit.AstralStep.End", self:GetCaster() )
    hCaster:SetOrigin(vPos)
end