boss_pudge_dismember_lua = class({})
LinkLuaModifier( "modifier_boss_pudge_dismember_lua","lua_modifiers/boss/boss_pudge/modifier_boss_pudge_dismember_lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_pudge_dismember_lua:GetConceptRecipientType()
	return DOTA_SPEECH_USER_ALL
end

--------------------------------------------------------------------------------

function boss_pudge_dismember_lua:SpeakTrigger()
	return DOTA_ABILITY_SPEAK_CAST
end

--------------------------------------------------------------------------------

function boss_pudge_dismember_lua:GetChannelTime()
	self.creep_duration = self:GetSpecialValueFor( "creep_duration" )
	self.hero_duration = self:GetSpecialValueFor( "hero_duration" )
	if Stage.playernum == 1 then
		self.creep_duration = 2
		self.hero_duration = 2
	end
	if IsServer() then
		if self.hVictim ~= nil then
			if self.hVictim:IsConsideredHero() then
				return self.hero_duration
			else
				return self.creep_duration
			end
		end

		return 0.0
	end

	return self.hero_duration
end

--------------------------------------------------------------------------------

function boss_pudge_dismember_lua:OnAbilityPhaseStart()
	if IsServer() then
		self.hVictim = self:GetCursorTarget()
	end

	return true
end

--------------------------------------------------------------------------------

function boss_pudge_dismember_lua:OnSpellStart()
	if self.hVictim == nil then
		return
	end
	if self.hVictim:TriggerSpellAbsorb( self ) then
		self.hVictim = nil
		self:GetCaster():Interrupt()
	else
		self.hVictim:AddNewModifier( self:GetCaster(), self, "modifier_boss_pudge_dismember_lua", { duration = self:GetChannelTime() } )
		self.hVictim:Interrupt()
	end
end


--------------------------------------------------------------------------------

function boss_pudge_dismember_lua:OnChannelFinish( bInterrupted )
	if self.hVictim ~= nil then
		self.hVictim:RemoveModifierByName( "modifier_boss_pudge_dismember_lua" )
	end
end
function boss_pudge_dismember_lua:GetCooldown( nLevel )
	local cd = self.BaseClass.GetCooldown( self, nLevel )-0.4*GameRules:GetCustomGameDifficulty()
	if cd < 10 then
		cd = 10
	end
	return cd
end
function boss_pudge_dismember_lua:GetCastPoint()
	local cd  = self.BaseClass.GetCastPoint( self )-GameRules:GetCustomGameDifficulty()*0.04
	if cd < 0.5 then
		cd = 0.5
	end
	return cd
end
--------------------------------------------------------------------------------