boss_undying_tombstone_zombie_night = class({})
LinkLuaModifier( "modifier_boss_undying_tombstone_zombie_night","lua_modifiers/boss/boss_undying/modifier_boss_undying_tombstone_zombie_night", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function boss_undying_tombstone_zombie_night:OnSpellStart()
    self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_boss_undying_tombstone_zombie_night", {duration=30})
end
--function boss_undying_tombstone_zombie_night:GetIntrinsicModifierName(self)
  --  return "modifier_boss_undying_tombstone_zombie_night"
--end