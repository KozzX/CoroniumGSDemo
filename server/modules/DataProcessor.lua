local Emitter = require( 'core' ).Emitter

local DataProcessor = Emitter:extend()
function DataProcessor:initialize( )

end


function DataProcessor:process( client,data )
	--local game = gs:getPlayerGame (client)
	if data.play then
		p("morreu")
	end
end

return DataProcessor