--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--
--  author:  Johan Hanssen Seferidis
--  date:    2011 June 5th
--	license: GPL
--  description: checks for winning conditions
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

function gadget:GetInfo()
	return {
		name      = "Main module",
		desc      = "Keeps track of winning conditions",
		author    = "Johan Hanssen Seferidis/aka Pithikos",
		date      = "June, 2011",
		license   = "GPL",
		layer     = 0,
		enabled   = true  --  loaded by default?
	}
end


-- references
local echo           = Spring.Echo
local DestroyUnit    = Spring.DestroyUnit
local GetTeamUnits   = Spring.GetTeamUnits
local AreTeamsAllied = Spring.AreTeamsAllied


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

-- synced only
if (not gadgetHandler:IsSyncedCode()) then
	echo("Game not synced. Can't load 'god.lua'")
	return false
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
---------------------------------CALLINS----------------------------------------

-- record damage done
function gadget:UnitDamaged(unitID, unitDefID, unitTeam, damage, paralyzer, weaponID, attackerID, attackerDefID, attackerTeam)
	if (unitID==_G.zombieID) then
		echo("Zombie damaged by team: "..attackerTeam)
		echo("Damaged done: "..damage)
	end
end

-- check if zombie is killed
function gadget:UnitDestroyed(unitID, unitDefID, unitTeamID, attackerID)
	if (unitID==_G.zombieID) then
		echo("YOU WON THE GAME!!")
		killAllEnemies(1)
	end
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-----------------------------LOCAL FUNCTIONS------------------------------------

-- get amount of alliances

-- kill everyone but given team's allies and himself
function killAllEnemies(survivorTeamID)
	local teams=Spring.GetTeamList()
	for _, teamID in pairs(teams) do
		if (not AreTeamsAllied(teamID, survivorTeamID)) then
			local teamUnits = GetTeamUnits(teamID)
			for a, unitID in pairs(teamUnits) do
				DestroyUnit(unitID)
			end
		end
  end
end

-- kill all ally units of a given team(with the given team included)
function killAlliedTeams(allyTeamID)
	local teams=Spring.GetTeamList()
	for _, teamID in pairs(teams) do
		if AreTeamsAllied(allyTeamID, teamID) then --if team is an ally
			local teamUnits = GetTeamUnits(teamID)
			for a, unitID in pairs(teamUnits) do
				DestroyUnit(unitID)
			end
		end
  end
end
