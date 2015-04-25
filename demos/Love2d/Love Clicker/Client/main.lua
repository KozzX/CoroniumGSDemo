--======================================================================--
--== Coronium GS Client
--======================================================================--
local gs = require( 'gs.CoroniumGSClient' ):new()
local p = gs.p --== Pretty Printer

local tick, ping --== CGS handlers, for Love2d update
--======================================================================--
--== Game Code
--======================================================================--

local latency, results = "latency: -", "Connecting..."
local p1_love, p2_love = "P1 Loved: 0", "P2 Loved: 0"

function love.mousepressed( x, y, button )
	if button == 'l' then
		gs:send( { love = 1 } )
	end
end

function love.draw()
	love.graphics.print( latency, 40, 40 )
	love.graphics.printf( results, 0, 200, 800, 'center' )
	love.graphics.printf( p1_love, 0, 300, 800, 'center' )
	love.graphics.printf( p2_love, 0, 360, 800, 'center' )
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
	p( event.data )

	results = "Click mouse to send some love to other player..."
end

function onGameData( event )
	local d = event.data

	p1_love = "P1 Loved: " .. d.p1_loved
	p2_love = "P2 Loved: " .. d.p2_loved
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
	if event.data.results then
		results = event.data.state
	end
end

local function onClientConnect( event )
	p( "client connected" )

	gs:createGame( 2 )
end

local function onClientClose( event )
	results = "Connection closed."
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
	handle = 'Nickname',
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
	love.graphics.setNewFont( 18 )

	--== Connect to Coronium GS instance
	tick, ping = gs:connect( connection )

end

function love.update( dt )
	--== Run CGS updates
	tick()
	ping()
end