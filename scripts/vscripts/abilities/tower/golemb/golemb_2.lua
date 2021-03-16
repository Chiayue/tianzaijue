--Abilities
if golemB_2 == nil then
	golemB_2 = class({iOrderType = FIND_CLOSEST}, nil, ability_base_ai)
end
function golemB_2:OnSpellStart()
	local hCaster = self:GetCaster()
	local hTarget = self:GetCursorTarget()
	local info = {
		EffectName = "particles/neutral_fx/mud_golem_hurl_boulder.vpcf",
		Ability = self,
		iMoveSpeed = 1000,
		Source = hSource,
		Target = hTarget,
		iSourceAttachment = DOTA_PROJECTILE_ATTACHMENT_ATTACK_1,
		vSourceLoc = hCaster:GetAbsOrigin(),
		bDodgeable = true,
	}
	ProjectileManager:CreateTrackingProjectile(info)
	-- sound
	hCaster:EmitSound("n_mud_golem.Boulder.Cast")
end
function golemB_2:OnProjectileHit(hTarget, vLocation)
	if hTarget ~= nil then
		local hCaster = self:GetCaster()
		hCaster:DealDamage(hTarget, self)
		hTarget:AddBuff(hCaster, BUFF_TYPE.STUN, self:GetDuration())
	end
end