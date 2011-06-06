--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  author:  Johan Hanssen Seferidis
--  date:    2011 June 5th
--	license: GPL
--  description: sets zombie in the middle of the map
--               sets resources
--
--  "zombie" refers to unit or structure that will work as the dumie that gets hit
--
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--TODO--
-- fix it so elevation can be recognised at center of map (y)
--
function gadget:GetInfo()
	return {
		name      = "Spawn",
		desc      = "spawns start unit and sets storage levels",
		author    = "Tobi Vollebregt/TheFatController",
		date      = "January, 2010",
		license   = "GNU GPL, v2 or later",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
local echo = Spring.Echo

--when gadget loads
function gadget:Initialize()
	gaiaTeamID = Spring.GetGaiaTeamID()
	Spring.SetTeamResource(gaiaTeamID, "ms", 1000)
	Spring.SetTeamResource(gaiaTeamID, "es", 1000)
	spawnZombie()
end


--coords used are in gl format(x=width, z=height, y=elevation)
function spawnZombie()
	x = Game.mapSizeX/2
	z = Game.mapSizeZ/2
	y = Spring.GetGroundHeight(x, z)
	if (y>=0) then
		_G.zombieID=Spring.CreateUnit("zombie_land", x, y, z, "south", gaiaTeamID);   --land zombie zombie_land
	else
	  _G.zombieID=Spring.CreateUnit("zombie_sea", x, y, z, "south", gaiaTeamID);    --sea zombie
	end
end
