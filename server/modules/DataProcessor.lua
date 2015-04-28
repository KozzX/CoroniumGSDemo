local Emitter = require( 'core' ).Emitter

local DataProcessor = Emitter:extend()
function DataProcessor:initialize( )

end

local function autoNegotiate( client )
	local game_count = gs:getGameCount( { game_state = 'open' } )
	p("processor",game_count)

	if game_count == 0 then
		gs:createGame( client, 2 )
	else
		gs:addToGameQueue( client, 2 )
	end
end

function DataProcessor:process( client,data )

	if data.play then
		autoNegotiate( client )
	end
end

return DataProcessor