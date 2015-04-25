--======================================================================--
--== Coronium GS LÖVE 2d Client
--======================================================================--

local gs = require( 'gs.CoroniumGSClient' ):new()
local p = gs.p --== Pretty Printer

local tick, ping --== CGS handlers, for LÖVE 2d update
--======================================================================--
--== Game Code
--======================================================================--

local latency, status = "latency: -", "Connecting..."

function love.mousepressed( x, y, button )

end

function love.draw()
	love.graphics.print( latency, 40, 40 )
	love.graphics.printf( status, 0, 300, 800, 'center' )
end

--======================================================================--
--== Game Events
--======================================================================--
function onGameCreate( event )
	p( event.data )
end

function onGameJoin( event )
	p( event.data )
end

function onGameStart( event )
	p( "game started" )
end

function onGameData( event )
	p( event.data )
end

function onGameLeave( event )
	p( event.data )
end

function onGameDone()
	p( 'Game Done' )
end

--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( event )
	p( event.data )
end

local function onClientConnect( event )
	p( "client connected" )

	status = "Connected!"

end

local function onClientClose( event )
	p( "client closed" )

	status = "Connection closed."
end

local function onClientPing( event )
	p( "timestamp: " .. event.data )

	--== Calculate latency
	local diff = ( os.time() - event.data ) * .5
	latency = "latency: " .. diff .. " ms"
end

function onClientError( event )
	p( "error: " .. event.data )
end
--======================================================================--
--== Game Handlers
--======================================================================--
gs.events:on( "GameCreate", onGameCreate )
gs.events:on( "GameJoin", onGameJoin )
gs.events:on( "GameStart", onGameStart )
gs.events:on( "GameData", onGameData )
gs.events:on( "GameLeave", onGameLeave )
gs.events:on( "GameDone", onGameDone )
--======================================================================--
--== Client Handlers
--======================================================================--
gs.events:on( "ClientData", onClientData )
gs.events:on( "ClientConnect", onClientConnect )
gs.events:on( "ClientClose", onClientClose )
gs.events:on( "ClientPing", onClientPing )
gs.events:on( "ClientError", onClientError )
--======================================================================--
--== Server Connection
--======================================================================--
local connection = 
{
	host = 'ping.coronium.gs',
	port = 7173,
	handle = "Nickname",
	data = 
	{
		color = "blue",
	},
	key = 'abc',
	ping = true
}
--======================================================================--
--== Love2d Listeners
--======================================================================--

function love.load()
  if arg[#arg] == "-debug" then require("mobdebug").start() end
  
	love.graphics.setNewFont( 18 )

	--== Connect to Coronium GS instance
	tick, ping = gs:connect( connection )
end

function love.update( dt )
	--== Run CGS updates
	tick()
	ping()
end

