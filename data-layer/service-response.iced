###
Copyright (c) 2013 Antonio Bello
https://github.com/jeden/todo

MIT License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to
deal in the Software without restriction, including without limitation the
rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
sell copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
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
