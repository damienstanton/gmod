SWEP.PrintName = "The Chair Gun"
SWEP.Author = "(Damien Stanton)"
SWEP.Instructions = "Throw some chairs"
SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Weight = 5
SWEP.AutoSwitchTo = false
SWEP.AutoSwitchFrom = false
SWEP.Slot = 1
SWEP.SlotPos = 2
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = true
SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = "models/weapons/w_pistol.mdl"

local ShootSound = Sound("Metal.SawbladeStick")

-- left mouse: automatic fire
function SWEP:PrimaryAttack()
    self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
    self:ThrowChair("models/props_c17/FurnitureChair001a.mdl")
end

-- right mouse: single fire
function SWEP:SecondaryAttack()
    self:ThrowChair("models/props_c17/FurnitureChair001a.mdl")
end

-- fire op
function SWEP:ThrowChair(model_file)
    self:EmitSound(ShootSound)

    if (CLIENT) then
        return
    end

    local ent = ents.Create("prop_physics")

    if (not IsValid(ent)) then
        return
    end

    ent:SetModel(model_file)
    ent:SetPos(self.Owner:EyePos() + (self.Owner:GetAimVector() * 16))
    ent:SetAngles(self.Owner:EyeAngles())
    ent:Spawn()

    local phys = ent:GetPhysicsObject()
    if (not IsValid(phys)) then
        ent:Remove()
        return
    end

    local velocity = self.Owner:GetAimVector()
    -- TODO: modify velocity and number of chairs later?
    velocity = velocity * 100
    velocity = velocity + (VectorRand() * 10)
    phys:ApplyForceCenter(velocity)

    cleanup.Add(self.Owner, "props", ent)

    undo.Create("Thrown_Chair")
    undo.AddEntity(ent)
    undo.SetPlayer(self.Owner)
    undo.Finish()
end
