---------- This was originally taken from Quantum's gui_chicken.lua--------------
---------------------------------------------------------------------------------
---------------------------------------------------------------------------------
-- Author: Johan Hanssen Seferidis
---------------------------------------------------------------------------------


function gadget:GetInfo()
  return {
    name      = "Stats Panel",
    desc      = "Panel that keeps track of game statistics for the specific mod",
    author    = "Pithikos",
    date      = "Nov 01, 2010",
    license   = "GNU GPL, v2 or later",
    layer     = -9, 
    enabled   = false  --  loaded by default?
  }
end

-------------------------------------------------------------------------------

--GLOBALS
_G.BADefense={ -- keeps statistics of the  BA Defense mod
	totalBots=0, -- how many bots in the map
	totalBotKills=0, -- how many bots got killed
	totalBotBuildings=0, -- how many buildings there currently are
	totalBotBuildingKills=0 -- how many buildings got killed
}
local botTeamID=-1

-- Make references to Spring's functions
local echo            = Spring.Echo
local GetGameSeconds  = Spring.GetGameSeconds

--Main Initializer
function gadget:Initialize()
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------SYNCED OPERATIONS
if (gadgetHandler:IsSyncedCode()) then
--------------------------------------------------------------------------------
	echo("synced");


--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
------------------------------------------------------------------------UNSYNCED
else
--------------------------------------------------------------------------------

	
	local Spring          = Spring
	local gl, GL          = gl, GL
	local gadgetHandler   = gadgetHandler
	local math            = math
	local table           = table
	
	local displayList
	local fontHandler     = loadstring(VFS.LoadFile("LuaRules/".."modfonts.lua", VFS.ZIP_FIRST))()
	local panelFont       = "LuaRules/".."Fonts/FreeSansBold_14"
	local waveFont        = "LuaRules/".."Fonts/Skrawl_40"
	local panelTexture    = "LuaRules/".."Images/panel.tga"
	
	local viewSizeX, viewSizeY = 0,0
	local w               = 300
	local h               = 210
	local x1              = - w - 50
	local y1              = - h - 50
	local panelMarginX    = 30
	local panelMarginY    = 40
	local panelSpacingY   = 7
	local waveSpacingY    = 7
	local moving
	local capture
	local gameInfo
	local enabled
	local gotScore
	local scoreCount	  = 0
	
	local guiPanel --// a displayList
	local updatePanel
	
	local red             = "\255\255\001\001"
	local white           = "\255\255\255\255"

	
	-----------------------------------------------------------------------------
	
	
	fontHandler.UseFont(panelFont)
	local panelFontSize  = fontHandler.GetFontSize()
	
	function comma_value(amount)
	  local formatted = amount
	  while true do  
	    formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
	    if (k==0) then
	      break
	    end
	  end
	  return formatted
	end
	
	
	local function PanelRow(n)
	  return panelMarginX, h-panelMarginY-(n-1)*(panelFontSize+panelSpacingY)
	end
	
	
	local function CreatePanelDisplayList()
	  gl.PushMatrix()
	  gl.Translate(x1, y1, 0)
	  gl.CallList(displayList)
	  fontHandler.DisableCache()
	  fontHandler.UseFont(panelFont)
	  fontHandler.BindTexture()
	  local currentTime = GetGameSeconds()
	  local techLevel = ""
	  fontHandler.DrawStatic(white .. techLevel, PanelRow(1))
	  fontHandler.DrawStatic(white .. "Bot Units: "            .. PanelRow(2))
	  fontHandler.DrawStatic(white .. "Bot Kills: "            .. PanelRow(3))
	  fontHandler.DrawStatic(white .. "Buildings: "            .. PanelRow(4))
	  fontHandler.DrawStatic(white .. "Buildings Destroyed: "  .. PanelRow(5))
	  local s = white.."Mode: "..difficulties[gameInfo.difficulty]
	  if gotScore then
	    fontHandler.DrawStatic(white.."Your Score: "..comma_value(scoreCount), 88, h-170)
	  else
	    fontHandler.DrawStatic(white.."Mode: "..difficulties[gameInfo.difficulty], 120, h-170)--test=difficulties[gameInfo.difficulty]
	  end
	  gl.Texture(false)
	  gl.PopMatrix()
	end
	
	
	local function Draw()
	  if (not enabled)or(not gameInfo) then
	    echo("Returning: line 252")
	    return
	  end
	

	  if (updatePanel) then
	    if (guiPanel) then gl.DeleteList(guiPanel); guiPanel=nil end
	    guiPanel = gl.CreateList(CreatePanelDisplayList)
	    updatePanel = false
	  end
	
	  if (guiPanel) then
	    gl.CallList(guiPanel)
	  end
	
	  if (waveMessage)  then
	    local t = Spring.GetTimer()
	    fontHandler.UseFont(waveFont)
	    local waveY = viewSizeY - Spring.DiffTimers(t, waveTime)*waveSpeed*viewSizeY
	    if (waveY > 0) then
	      for i, message in ipairs(waveMessage) do
	        fontHandler.DrawCentered(message, viewSizeX/2, waveY-WaveRow(i))
	      end
	    else
	      waveMessage = nil
	      waveY = viewSizeY
	    end
	  end
	end
	
	
	--------------------------------------------------------------------------------
	--------------------------------------------------------------------------------
	
	function gadget:Initialize()
	  displayList = gl.CreateList( function()
	    gl.Color(1, 1, 1, 1)
	    gl.Texture(panelTexture)
	    gl.TexRect(0, 0, w, h)
	  end)
	  UpdateRules()
	end
	
	--update panel infin.
	function gadget:Update(n)
	  UpdateRules()	
	  enabled = true
	  queenAnger = math.ceil((((GetGameSeconds()-gameInfo.gracePeriod+gameInfo.queenAnger)/(gameInfo.queenTime-gameInfo.gracePeriod))*100) -0.5)
	  if gotScore then
	    local sDif = gotScore - scoreCount
	    if sDif > 0 then
	      scoreCount = scoreCount + math.ceil(sDif / 7.654321)
	      if scoreCount > gotScore then 
	        scoreCount = gotScore 
	      else
	        updatePanel = true
	      end
	    end
	  end
	end
	
	
	function gadget:DrawScreen()
	  x1 = math.floor(x1 - viewSizeX)
	  y1 = math.floor(y1 - viewSizeY)
	  viewSizeX, viewSizeY = gl.GetViewSizes()
	  x1 = viewSizeX + x1
	  y1 = viewSizeY + y1
	  Draw()
	end
	
	
	function gadget:MouseMove(x, y, dx, dy, button)
	  if (enabled and moving) then
	    x1 = x1 + dx
	    y1 = y1 + dy
	    updatePanel = true
	  end
	end
	
	
	function gadget:MousePress(x, y, button)
	  if (enabled and 
	       x > x1 and x < x1 + w and
	       y > y1 and y < y1 + h) then
	    capture = true
	    moving  = true
	  end
	  return capture
	end
	
	 
	function gadget:MouseRelease(x, y, button)
	  if (not enabled) then
	    return
	  end
	  capture = nil
	  moving  = nil
	  return capture
	end
	
	
	function gadget:ViewResize(vsx, vsy)
	  x1 = math.floor(x1 - viewSizeX)
	  y1 = math.floor(y1 - viewSizeY)
	  viewSizeX, viewSizeY = vsx, vsy
	  x1 = viewSizeX + x1
	  y1 = viewSizeY + y1
	end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-----------------------------------------------------------------------------END
end
--------------------------------------------------------------------------------
