util.AddNetworkString("Talk1")
util.AddNetworkString("Next1")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/player/jojo3/jtr.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_BBOX)
    self:SetNPCState(NPC_STATE_SCRIPT)
    self:SetUseType(SIMPLE_USE)
    local phys = self:GetPhysicsObject()

    if (phys:IsValid()) then
        phys:Wake()
    end
end

function ENT:Use(ply)
    net.Start("Talk1")
    net.Send(ply)
end