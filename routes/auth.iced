###
Created by Antonio Bello
###

UserManager = require('../logic/user-manager').UserManager
log = require 'winston'

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
      Render the registration page
###
exports.register = (req, res) ->
	res.render 'register', title: 'Register'

exports.doRegister = (req, res) ->
	form = req.body
	user =
		username: form.username
		password: form.password
		confirmPassword: form.confirmPassword
		name:
			first: form.firstName
			last: form.lastName
	log.info("Registering new user", user)

	userManager = new UserManager req.app.dal
	await userManager.registerUser user, defer outcome

	if outcome == UserManager.SUCCESS
		log.log('Registration succeeded')
		res.redirect '/login'
	else
		log.warn("Registration failed with error #{outcome}")
		res.render 'register',
			title: 'Register'
			user: user
###
      Logout the current user
###
exports.logout = (req, res) ->
	req.logout()
	res.redirect '/'

