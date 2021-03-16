if modifier_color_aura == nil then
	modifier_color_aura = class({})
end

local public = modifier_color_aura

function public:IsHidden()
	return true
end
function public:IsDebuff()
	return false
end
function public:IsPurgable()
	return false
end
function public:IsPurgeException()
	return false
end
function public:AllowIllusionDuplicate()
	return false
end
function public:RemoveOnDeath()
	return false
end
function public:DestroyOnExpire()
	return false
end
function public:IsPermanent()
	return true
end
function public:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end
function public:OnCreated(params)
	self:OnRefresh(params)
end
function public:OnRefresh(params)
	if IsServer() then
		local rbg = params.RGB or params.rgb or 0xffffff
		self:SetStackCount(rbg)
	else
		self:Color()
	end
end
function public:Color()
	local hParent = self:GetParent()
	if hParent:GetPlayerOwnerID() == GetLocalPlayerID() then
		if not self.iPtcl then
			self.iPtcl = ParticleManager:CreateParticle('particles/self_unit_aura.vpcf', PATTACH_POINT_FOLLOW, hParent)
			self:AddParticle(self.iPtcl, false, false, -1, false, false)
		end
		local rbg = self:GetStackCount()
		local r = bit.rshift(rbg, 16)
		local b = bit.rshift(rbg - bit.lshift(r, 16), 8)
		local g = rbg - bit.lshift(r, 16) - bit.lshift(b, 8)
		ParticleManager:SetParticleControl(self.iPtcl, 10, Vector(r, b, g))
	end
end