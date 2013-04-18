###
Created by Antonio Bello
All right reserved
###

class exports.UserAdapter
	constructor: (@db) ->
		# Empty



class exports.User
	constructor: (user) ->
		@id = user.id
		@username = user.username
		@password = user.password if user.password? else null
		@name =
			first: user.name.first
			last: user.name.last

