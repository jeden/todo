###
Created by Antonio Bello
All right reserved
###

###
Translate mongodb response into a generic response
(ideally independent from the DB)
###
class exports.ServiceResponse
	constructor: (err, param) ->
		# The platform specific error
		@__platformError = err

		# Flag indicating whether the request succeded
		@__succeeded = not err? or param

		# Container for result data, if any
		@__results = if typeof param != 'boolean' then param else null

		# Calculate the number of returned rows
		@__affectedRows = 0
		if @__results?
			if @__results instanceof Array
				@__affectedRows = @__results.length
			else
				@__affectedRows = 1

	hasError: () -> __platformError?
	succeeded: () -> @__succeeded
	failed: () -> not @__succeeded

	getError: () -> @__platformError
	getResults: () -> @__results
	getAffectedRows: () -> @__affectedRows
