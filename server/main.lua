--======================================================================--
--== Coronium GS
--======================================================================--
local gs = require( 'CoroniumGS' ):new( 7173, 'abc' )

_G.gs = gs
--======================================================================--
--== Game Code
--======================================================================--
--local ClientData = require( 'ClientData' ).new()
local DataProcessor = require( "DataProcessor" )
local dp = DataProcessor:new()

--== Game Code Goes Here

local function calculateHit(client,hit)
	local game = gs:getPlayerGame (client)
	local win = 0

	local player_num = client:getPlayerNum()
	p(player_num)

	player1 = game:getPlayerByNumber(1)
	player2 = game:getPlayerByNumber(2)

	if player_num == 1 then
		game.bar2 = game.bar2 - hit
		game.bar1 = game.bar1 + hit

	else
		game.bar1 = game.bar1 - hit
		game.bar2 = game.bar2 + hit
	end

	if game.bar1 == 100 then
		--game:publishGameDone("bye")
		--game:close( )
		win = 1
	elseif game.bar2 == 100 then
		--game:publishGameDone("bye")
		--game:close( )
		win = 2
	end
	p("Winner:",win)
	player1:send( { setbar = { bar1 = game.bar1, bar2= game.bar2, win=win } } )
	player2:send( { setbar = { bar1 = game.bar2, bar2= game.bar1, win=win } } )

end

local function restart( client )
	local game = gs:getPlayerGame (client)
	local player_num = client:getPlayerNum()
	game.bar1 = 50
	game.bar2 = 50
	if player_num == 1 then
		game.ready1 = 1
	elseif player_num == 2 then
		game.ready2 = 1
	end
	p("Restart:",game.ready1,game.ready2)
	if game.ready1 == 1 and game.ready2 == 1 then
		game:broadcast({ setbar = { bar1 = game.bar1, bar2 = game.bar2, restart = 1 } })
		game.ready1 = 0
		game.ready2 = 0
	end
end


--======================================================================--
--== Game Events
--======================================================================--
local function onGameCreate( game )
	p( "--== Game Created ==--" )
	p( game:getId() )

	game.bar1 = 50
	game.bar2 = 50
	game.ready1 = 0
	game.ready2 = 0

end

local function onGameJoin( game, player )
	p( "--== Game Joined ==--" )
	p( game:getId(), player:getId() )

end

local function onGameStart( game, players )
	p( "--== New Game Started " .. game:getId() .. " ==--" )
	p( "Games", gs:getGameCount() )

	game:broadcast({ setbar = { bar1 = game.bar1, bar2 = game.bar2 } })
end

local function onGameLeave( game, player )
	p( "--== Game Leave ==--" )
	p( game:getId(), player:getId() )
end

local function onGameClose( game_id )
	p( "--== Game Closed ==--" )
	p( game_id )
end
--======================================================================--
--== Client Events
--======================================================================--
local function onClientData( client, data )

	dp:process( client,data )

	if data.hit then
		calculateHit( client, data.hit )
	elseif data.ready then
		restart( client )
	end
end

local function onClientConnect( client )
	p( '--== Client Connected ==--' )
	p( client:getHost() )

	client.score = 0
end

local function onClientClose( client )
	p( '--== Client Closed ==--' )
end

local function onClientTimeout( client )
	p( '--== Client Timeout ==--' )
	p( client:getHost()  )
end

local function onClientError( client, error )
	p( '--== Client Error ==--' )
	p( error )
end
--======================================================================--
--== GameManager Handlers
--======================================================================--
gs:on( "GameStart", onGameStart )
gs:on( "GameCreate", onGameCreate )
gs:on( "GameJoin", onGameJoin )
gs:on( "GameLeave", onGameLeave )
gs:on( "GameClose", onGameClose )
--======================================================================--
--== Client Handlers
--======================================================================--
gs:on( "ClientConnect", onClientConnect )
gs:on( "ClientData", onClientData )
gs:on( "ClientError", onClientError )
gs:on( "ClientClose", onClientClose )
gs:on( "ClientTimeout", onClientTimeout )
