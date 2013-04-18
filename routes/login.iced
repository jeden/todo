###
Created by Antonio Bello
###

###
      Route middleware to ensure a user is authenticated
      To be used to protect any resource
###
exports.isAuthenticated = (req, res, next) ->
	if req.isAuthenticated()
		return next()
	res.redirect '/login'


###
      Render the login page
###
exports.login = (req, res) ->
	res.render 'login', title: 'Login'

###
      Logout the current user
###
exports.logout = (req, res) ->
	req.logout
	res.redirect '/'
