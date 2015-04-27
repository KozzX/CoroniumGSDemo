local Emitter = require ( 'core' ).Emitter

local DataProcessor = Emitter:extend()

function DataProcessor:initialize( )
	
end

function DataProcessor:process( data )
	p( data )
end

return DataProcessor