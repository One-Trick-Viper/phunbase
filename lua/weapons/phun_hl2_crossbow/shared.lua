SWEP.Base = "base_gmod4phun"

SWEP.PrintName = "CROSSBOW"
SWEP.Category = "PHUNBASE | HL2"
SWEP.Slot = 3
SWEP.SlotPos = 1

SWEP.ViewModelFOV = 55
SWEP.AimViewModelFOV = 55
SWEP.ViewModel = "models/weapons/c_crossbow.mdl"
SWEP.WorldModel = "models/weapons/w_crossbow.mdl"
SWEP.HoldType = "crossbow"

SWEP.Spawnable = true
SWEP.AdminSpawnable = true

// weapon specific variables

SWEP.Primary.Ammo = "xbowbolt"
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = SWEP.Primary.ClipSize
SWEP.Primary.Automatic = false
SWEP.Primary.Delay = 0.1
SWEP.Primary.Damage = 20
SWEP.Primary.Force = 10
SWEP.Primary.Bullets = 1
SWEP.Primary.Tracer = 0
SWEP.Primary.Spread = 0
SWEP.Primary.Cone = 0.01

SWEP.BasePos = Vector(0,0,0)
SWEP.BaseAng = Vector(0,0,0)

SWEP.IronsightPos = Vector(-7.995, -11.25, 2.075)
SWEP.IronsightAng = Vector(0, 0, 0)

SWEP.SprintPos = Vector(0, -6.061, 2.937)
SWEP.SprintAng = Vector(-19.701, 29.7, 0)

SWEP.HolsterPos = Vector(0,0,20)
SWEP.HolsterAng = Vector(0,0,0)

SWEP.NearWallPos = Vector(1.6, -11.5, -10.301)
SWEP.NearWallAng = Vector(64.8, 0, 0)

SWEP.PistolSprintSway = true

SWEP.Sequences = {
	idle = "idle",
	idle_empty = "idle_empty",
	idle_iron = "idle",
	idle_iron_empty = "idle_empty",
	fire = "fire",
	fire_last = "fire",
	fire_iron = "fire",
	fire_iron_last = "fire",
	fire_left = "fire",
	fire_left_iron = "fire",
	fire_right = "fire",
	fire_right_iron = "fire",
	reload = "reload",
	deploy = "draw",
	holster = "holster",
	lighton = "idle",
	lighton_iron = "idle",
	goto_iron = "idle",
	goto_hip = "idle",
}

SWEP.Sounds = {
	reload = {
		{time = 0.90, sound = "Weapon_Crossbow.BoltElectrify", callback = function(wep) wep.XBOWGLOW = true end},
	},
}

SWEP.DeployTime = 0.4
SWEP.HolsterTime = 0.25
SWEP.ReloadTime = 1.9

SWEP.ViewModelMovementScale = 0.8

// shell-related stuff
SWEP.ShellVelocity = {X = 60, Y = 0, Z = -40}
SWEP.ShellAngularVelocity = {Pitch_Min = -500, Pitch_Max = 200, Yaw_Min = 0, Yaw_Max = 1000, Roll_Min = -200, Roll_Max = 100}
SWEP.ShellViewAngleAlign = {Forward = 0, Right = -90, Up = 0}
SWEP.ShellAttachmentName = "1"
SWEP.ShellDelay = 0.001
SWEP.ShellScale = 0.5
SWEP.ShellModel = "models/weapons/shell.mdl"
SWEP.ShellEjectVelocity = 0

SWEP.MuzzleAttachmentName = "muzzle"
SWEP.MuzzleEffect = {"weapon_muzzle_flash_smoke_small2", "PistolGlow", "muzzle_lee_simple_pistol", "muzzle_fire_pistol", "muzzle_sparks_pistol", "smoke_trail"}

SWEP.FireSound = {"Weapon_Crossbow.Single", "Weapon_Crossbow.BoltFly"}

SWEP.NormalFlashlight = true
SWEP.CustomFlashlight = false

SWEP.DisableReloadBlur = true
SWEP.ReloadAfterShot = true
SWEP.ReloadAfterShotTime = 0.1
SWEP.XBOWGLOW = true

function SWEP:FireCrossbowBolt()
	if CLIENT then return end
	local ply = self.Owner
	local dir = ply:EyeAngles():Forward()
	local ent = ents.Create( "crossbow_bolt" )
	if ( IsValid( ent ) ) then
		ent:SetPos( ply:GetShootPos() + dir * 32 )
		ent:SetAngles( ply:EyeAngles() )
		ent:Spawn()
		ent:Activate()
		ent:SetVelocity( dir * 3500 )
		ent:SetOwner( ply )
		ent.Owner = self:GetOwner()
		ent:SetMoveCollide(MOVECOLLIDE_FLY_CUSTOM)
		ent.CustomXBOWBolt = true
	end
	
	local tr = util.TraceLine({
		start = ply:GetPos(),
		endpos = ply:GetPos()+Vector(0,0,-32),
	})
	
	if ply:EyeAngles().p >= 80 and tr.Hit then // jumpity jump
		ply:SetVelocity(Vector(0,0,500))
	end
end

function SWEP:PrimaryAttackOverride()
	self:FireCrossbowBolt()
	self.XBOWGLOW = false
end

function SWEP:PrimaryAttackOverride_CL()
	self.XBOWGLOW = false
end

function SWEP:ThinkOverrideClient()
	local vm = self.VM
	local seq = self:GetActiveSequence()
	if self.XBOWGLOW then
		if vm:GetSkin() != 1 then
			vm:SetSkin(1)
		end
	else
		if vm:GetSkin() != 0 then
			vm:SetSkin(0)
		end
	end
end