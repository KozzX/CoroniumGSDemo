local Emitter = require( 'core' ).Emitter

--======================================================================--
--== Game Local Functions
--======================================================================--
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
		game:publishGameDone({winner = 1})
	elseif game.bar2 == 100 then
		game:publishGameDone({winner = 2})
	end
	player1:send( { setbar = { bar1 = game.bar1, bar2= game.bar2 } } )
	player2:send( { setbar = { bar1 = game.bar2, bar2= game.bar1 } } )

end
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------


local Barras = Emitter:extend()
function Barras:initialize( )

end

function Barras:criar( game )
	game.bar1 = 50
	game.bar2 = 50
	game.ready1 = 0
	game.ready2 = 0
end

function Barras:comecar( game )
	game:broadcast({ setbar = { bar1 = game.bar1, bar2 = game.bar2 } })
end

function Barras:setBar( client,hit )
	calculateHit(client,hit)	
end

function Barras:restart( client )
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

return Barras