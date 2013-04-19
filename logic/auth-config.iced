###
Created by Antonio Bello
All right reserved
###

# Passport
passport = require 'passport'
BasicStrategy = require('passport-http').BasicStrategy
LocalStrategy = require('passport-local').Strategy

UserManager = require('./user-manager').UserManager

dal = null

exports.init = (app) ->
	dal = app.dal
	app.use(passport.initialize())
	app.use(passport.session()) # After express.session()
	return passport

# Passport configuration

###
      Authenticate a user
###
authenticate = (username, password, done) ->
	userManager = new UserManager dal
	await userManager.authenticateUser username, password, defer user

	if user?
		done(null, user)
	else
		done(null, false, { message: 'Invalid username or password'} )


# apiStrategy = new BasicStrategy authenticate
formStrategy = new LocalStrategy authenticate

passport.serializeUser (user, done) ->
	done null, user.id

passport.deserializeUser (id, done) ->
	userManager = new UserManager dal
	await userManager.fetchUserById id, defer user
	if user?
		done(null, user)
	else
		done(new Error "User #{id} not found")

passport.use(formStrategy)
