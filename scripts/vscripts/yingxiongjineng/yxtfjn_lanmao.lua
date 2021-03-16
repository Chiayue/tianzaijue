yxtfjn_lanmao = class({})
LinkLuaModifier("modifier_yxtfjn_lanmao", "yingxiongjineng/modifier_yxtfjn_lanmao.lua", LUA_MODIFIER_MOTION_HORIZONTAL )

--------------------------------------------------------------------------------
function yxtfjn_lanmao:Precache( hContext )
	
	PrecacheResource( "particle", "particles/econ/items/storm_spirit/storm_spirit_orchid_hat/stormspirit_orchid_ball_lightning.vpcf", hContext )
	
end
function yxtfjn_lanmao:OnAbilityPhaseStart()
	--self:GetCaster():StartGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
	return true
end

--------------------------------------------------------------------------------

function yxtfjn_lanmao:OnAbilityPhaseInterrupted()
	--self:GetCaster():RemoveGesture( ACT_DOTA_OVERRIDE_ABILITY_1 )
end

--------------------------------------------------------------------------------

function yxtfjn_lanmao:OnSpellStart()
	local hCaster=self:GetCaster()
	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end
	self.EndPos=vPos
	self.StartPos=hCaster:GetOrigin()
	self.distenceper=100
	self.vDirection = vPos- self.StartPos
	self.vDirection.z = 0.0
	self.vDirection = self.vDirection:Normalized()
	hCaster:AddNewModifier( hCaster, self, "modifier_yxtfjn_lanmao", {duration=11} )
end