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
local fillPlayer
local fillEnemy
local b1
local b2
local btn
local bar1Ant = 50
local bar2Ant = 50

local options = {
	label = "",
	width = 300,
	height = 60,
	fontSize = 50,
	onRelease = onButtonTap
}
display.setDefault( "background", 255/255,255/255,255/255)

local function zeraFill( event )
	fillPlayer.width = 0
	fillEnemy.width = 0
end

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

	fillPlayer = display.newRect( 0, 0, 0, display.contentHeight )
	fillPlayer:setFillColor( 0,1,0 )
	fillPlayer.anchorX = 0
	fillPlayer.anchorY = 0
	 
	fillEnemy = display.newRect( display.contentWidth, 0, 0, display.contentHeight )
	fillEnemy:setFillColor( 1,0,0 )
	fillEnemy.anchorX = 1
	fillEnemy.anchorY = 0


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
	p("Winner")
	p(event.data.msg.winner)
	p(gs:getPlayerNum())
	if event.data.msg.winner then
		function restart( event )
			bar1Ant = 50
			bar2Ant = 50
			gs:send( { ready = 1 } )
			display.remove( grupo )
		end
		options.id = 'restart'
		if gs:getPlayerNum() == event.data.msg.winner then
			options.label = "You Win!"
		else
			options.label = "You Lose!"
		end
		options.x = display.contentCenterX
		options.y = display.contentCenterY/2
		btn = widget.newButton( options )
		grupo = display.newGroup()
		grupo:insert( btn )
		Runtime:removeEventListener( "touch", sendHit )
		btn:addEventListener( "tap", restart )
	end
end

--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( event )
	p( event.data )
	local data = event.data
	p("--cliente data--")
	p(gs:getPlayerNum())

	if data.setbar then
		transition.to( player, {width = display.contentWidth / 100 * data.setbar.bar1, time = 100} )
		transition.to( enemy,  {width = display.contentWidth / 100 * data.setbar.bar2, time = 100} )
		if data.setbar.bar1 > bar1Ant then
			transition.to( fillPlayer, {width = display.contentWidth / 100 * data.setbar.bar1, time = 100, onComplete=zeraFill} )	
			bar1Ant = data.setbar.bar1
			bar2Ant = data.setbar.bar2
		end
		if data.setbar.bar2 > bar2Ant then
			transition.to( fillEnemy,  {width = display.contentWidth / 100 * data.setbar.bar2, time = 100, onComplete=zeraFill} )	
			bar1Ant = data.setbar.bar1
			bar2Ant = data.setbar.bar2
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
