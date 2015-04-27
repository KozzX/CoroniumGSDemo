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
local player
local enemy
local b1
local b2
local btn

local options = {
	label = "",
	width = 300,
	height = 60,
	fontSize = 50,
	onRelease = onButtonTap
}
display.setDefault( "background", 255/255,255/255,255/255)

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

	player = display.newRect( 0, 0, 0, display.contentHeight )
	player:setFillColor( 44/255,176/255,172/255 )
	player.anchorX = 0
	player.anchorY = 0
	 
	 
	enemy = display.newRect( display.contentWidth, 0, 0, display.contentHeight )
	enemy:setFillColor( 227/255,79/225,145/255 )
	enemy.anchorX = 1
	enemy.anchorY = 0


	function sendHit( event )
		if event.phase == "ended" then
			gs:send({hit = 10})
		end
	end
	Runtime:addEventListener( "touch", sendHit )

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
		transition.to( player, {width = display.contentWidth / 100 * data.setbar.bar1, time = 100} )
		transition.to( enemy,  {width = display.contentWidth / 100 * data.setbar.bar2, time = 100} )
	end
	if data.setbar.win then
		if data.setbar.win > 0 then
			function restart( event )
				gs:send( { ready = 1 } )
				btn:removeEventListener( "tap", restart )
				display.remove( btn )
			end
			options.id = 'restart'
			if gs:getPlayerNum() == data.setbar.win then
				options.label = "You Win!"
			else
				options.label = "You Lose!"
			end
			options.x = display.contentCenterX
			options.y = display.contentCenterY
			btn = widget.newButton( options )
			Runtime:removeEventListener( "touch", sendHit )
			btn:addEventListener( "tap", restart )
		end
	end
	if data.setbar.restart then
		p("reiniciar")
		Runtime:addEventListener( "touch", sendHit )	
	end


end

local function onClientConnect( event )
	p( "client connected" )

	local function onButtonTap( event )
		local btn_id = event.target.id
		if btn_id == 'play' then
			gs:send({play = 1})
		end
		b1:removeEventListener( "tap", onButtonTap )
		--b2:removeEventListener( "tap", onButtonTap )
		display.remove( connct_grp )
		
	end

	connct_grp = display.newGroup()
	options.id = 'play'
	options.label = "Play"
	options.x = display.contentCenterX
	options.y = display.contentCenterY 
	b1 = widget.newButton( options )

	--[[options.id = 'join'
	options.label = "Join"
	options.x = display.contentCenterX
	options.y = display.contentCenterY + 40
	b2 = widget.newButton( options )]]--

	b1:addEventListener( "tap", onButtonTap )
	--b2:addEventListener( "tap", onButtonTap )

	connct_grp:insert( b1 )
	--connct_grp:insert( b2 )

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
