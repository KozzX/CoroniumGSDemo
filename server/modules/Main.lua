--======================================================================--
--== Coronium GS
--======================================================================--
--local gs = require( 'CoroniumGS' ):new( 7173, 'abc' )



--======================================================================--
--== Game Code
--======================================================================--
--local ClientData = require( 'ClientData' ).new()
local Emitter = require( 'core' ).Emitter
local Barras = require( 'Barras' )
local DataProcessor = require( "DataProcessor" )

--== Game Code Goes Here
local Main = Emitter:extend()

function Main:initialize( gs )

	_G.gs = gs

	self.dp = DataProcessor:new()
	self.bar = Barras:new()

--======================================================================--
--== Game Events
--======================================================================--
	local function onGameCreate( game )
		p( "--== Game Created ==--" )
		p( game:getId() )
		self.bar:criar( game )
		p("criar",game.bar1)
	end

	local function onGameJoin( game, player )
		p( "--== Game Joined ==--" )
		p( game:getId(), player:getId() )

	end

	local function onGameStart( game, players )
		p( "--== New Game Started " .. game:getId() .. " ==--" )
		p( "Games", gs:getGameCount() )

		self.bar:comecar(game)
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

		self.dp:process( client,data )

		if data.hit then
			self.bar:setBar( client, data.hit )
		elseif data.ready then
			self.bar:restart( client )
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

end

return Main
