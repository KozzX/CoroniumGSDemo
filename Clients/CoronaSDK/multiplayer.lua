--======================================================================--
--== Coronium GS Client
--======================================================================--
local gs = require( 'gs.CoroniumGSClient' ):new()
local p = gs.p --== Pretty Printer
local widget = require( 'widget' )
--======================================================================--
--== Game Code
--======================================================================--

--== Game Code Goes Here
local fillBarra1
local fillBarra2
local barra1
local barra2
--======================================================================--
--== Game Events
--======================================================================--
function onGameCreate( event )
	p( event.data )
end

function onGameCancel( event )
	p( event.data )
end

function onGameJoin( event )
	p( event.data )
end

function onGameStart( event )
	p( "game started" )

	barra1 = display.newRect( display.contentCenterX/2, display.contentCenterY + display.contentCenterY/2, 100, 500 )
	barra1:setFillColor( 0.5,0.5,0.5 )
	barra1.anchorX = 0.5
	barra1.anchorY = 1
	fillBarra1 = display.newRect( barra1.x, barra1.y, 100, 0 )
	fillBarra1:setFillColor( 0,0,1 )
	fillBarra1.anchorX = 0.5
	fillBarra1.anchorY = 1
	 
	 
	barra2 = display.newRect( display.contentCenterX + display.contentCenterX / 2, display.contentCenterY + display.contentCenterY/2, 100, 500 )
	barra2:setFillColor( 0.5,0.5,0.5 )
	barra2.anchorX = 0.5
	barra2.anchorY = 1
	fillBarra2 = display.newRect( barra2.x, barra2.y, 100, 0 )
	fillBarra2:setFillColor( 1,0,0 )
	fillBarra2.anchorX = 0.5
	fillBarra2.anchorY = 1


	function sendHit( event )
		if event.y < display.contentCenterY then
			gs:send({up = 10})
		elseif event.y > display.contentCenterY then
			gs:send({down = 10})
		end
	end
	Runtime:addEventListener( "tap", sendHit )

	tempo = timer.performWithDelay( 1000, function( )
		gs:send({move = 1})
	end , -1 )

end

function onGameData( event )
	p( event.data )
end

function onGameLeave( event )
	p( event.data )
end

function onGameDone(event)
	p(event.data)
	p( 'Game Done' )
end

--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( event )
	p( event.data )
	local data = event.data

	if data.setbar then
		transition.to( fillBarra1, {height=barra1.height / 100 * data.setbar.bar1, time = 100} )
		transition.to( fillBarra2, {height=barra2.height / 100 * data.setbar.bar2, time = 100} )
		if(data.setbar.bar1 >= 100) then
			gs:send({win = "1"})
		elseif (data.setbar.bar1 >= 100) then
			gs:send({win = "2"})
		end
	end

end

local function onClientConnect( event )
	p( "client connected" )

	local function onButtonTap( event )
		local btn_id = event.target.id
		if btn_id == 'create' then
			gs:createGame( 2 )
		elseif btn_id == 'join' then
			gs:joinGame( 2 )
		end

		display.remove( connct_grp )
	end

	connct_grp = display.newGroup()

	local b1 = widget.newButton( {
		label = "Create",
		id = 'create',
		x = display.contentCenterX,
		y = display.contentCenterY - 40,
		width = 60,
		height = 40,
		onRelease = onButtonTap
	} )

	local b2 = widget.newButton( {
		label = "Join",
		id = 'join',
		x = display.contentCenterX,
		y = display.contentCenterY + 40,
		width = 60,
		height = 40,
		onRelease = onButtonTap
	} )

	connct_grp:insert( b1 )
	connct_grp:insert( b2 )

end

local function onClientClose( event )
	p( "client closed" )
end

local function onClientPing( event )
	p( "timestamp: " .. event.data )
end

function onClientError( event )
	p( "error: " .. event.data )
end
--======================================================================--
--== Game Handlers
--======================================================================--
gs.events:on( "GameCreate", onGameCreate )
gs.events:on( "GameCancel", onGameCancel )
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
	host = 'ec2-54-94-252-145.sa-east-1.compute.amazonaws.com',
	port = 7173,
	handle = "Andre",
	data = 
	{
		color = "blue",
	},
	key = 'abc',
	ping = true
}
gs:connect( connection )
