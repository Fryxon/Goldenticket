if SERVER then
 AddCSLuaFile("sh_config_gungame.lua")
 AddCSLuaFile("gungame/sh_main.lua")
 AddCSLuaFile("gungame/cl_main.lua")

 include("sh_config_gungame.lua")
 include("gungame/sh_main.lua")
 include("gungame/sv_main.lua")
end


if CLIENT then
    include("sh_config_gungame.lua")
    include("gungame/sh_main.lua")
    include("gungame/cl_main.lua")
end