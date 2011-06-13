Author:  Johan Hanssen Seferidis/Pithikos
Date:    Summer 2011
Licence: GPL


     ------------------------------------------
     -THIS DOCUMENT IS INTENDED FOR DEVELOPERS-
     ------------------------------------------

------------------- Game explanation --------------------
The idea is that a passive unit or structure spawns in the middle of the map. Whenever a team causes damage to it, the attacking team gets score points.
When the "dummy" structure/unit is totally destroyied, the team with highest score wins the game.


---------------------- Media files ---------------------
images -> keeps all image files that are used from widgets
fonts  -> fonts holds all font files that are used by widgets
sounds -> keeps all sound files that are used from widgets and gadgets


------------------ Gadget script files -----------------
init_bot.lua  -> spawns the zombie at game start
main.lua      -> is the script that keeps track of the zombie's state


------------------ Widget script files ------------------
stats_panel.lua -> is the end user graphic interface. NOTICE: This script is directly depended on the above gadgets!


----------------- Interface(Game Table) -----------------
Interface is made by global variables and constants that can be accessed with the Spring funtion GetGameRulesParam(param) where param is a string of the following:

dummyID             -> the ID number of the dummy
dummyHealth         -> the current health of the dummy
dummyMaxHealth      -> the max health the dummy can have

initAlliancesN      -> number of player alliances at the beginning of the game
alliance1Score      -> the current score for an alliance
alliance2Score
..
alliance99Score
winnerAllianceID    -> the ID of the alliance that won the game. This is nil as long as it's not game over


---------------- Crucial Information --------------
At current state, the dummy team is implemented as parth of the Gaia team. Be aware of this when using maps that keep Gaia elements.
