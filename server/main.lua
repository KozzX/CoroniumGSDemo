--======================================================================--
--== Coronium GS
--======================================================================--
local gs = require( 'CoroniumGS' ):new( 7173, 'abc' )
--======================================================================--
--== Game Code
--======================================================================--

--== Game Code Goes Here
local function calculateDown(client,down)
	local game = gs:getPlayerGame (client)

	local player_num = client:getPlayerNum()
	p(player_num)

	if player_num == 1 then
		game.bar2 = game.bar2 + down
		game.bar1 = game.bar1 - down
	else
		game.bar1 = game.bar1 + down
		game.bar2 = game.bar2 - down
	end

	game:broadcast( {setbar = { bar1 = game.bar1, bar2= game.bar2 } } )

end

local function calculateUp(client,up)
	local game = gs:getPlayerGame (client)

	local player_num = client:getPlayerNum()
	p(player_num)

	if player_num == 1 then
		game.bar1 = game.bar1 + up
	else
		game.bar2 = game.bar2 + up
	end

	game:broadcast( {setbar = { bar1 = game.bar1, bar2= game.bar2 } } )

end

local function moveUp(client,up)
	local game = gs:getPlayerGame (client)

	game.bar1 = game.bar1 + up
	game.bar2 = game.bar2 + up

	game:broadcast( {setbar = { bar1 = game.bar1, bar2= game.bar2 } } )

end

--======================================================================--
--== Game Events
--======================================================================--
local function onGameCreate( game )
	p( "--== Game Created ==--" )
	p( game:getId() )

	game.bar1 = 0
	game.bar2 = 0

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

	p( data )
	if data.up then
		calculateUp( client, data.up)
	elseif data.down then
		calculateDown( client, data.down)
	elseif data.move then
		moveUp( client, data.move)
	elseif data.win then
		
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
