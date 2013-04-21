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


apiStrategy = new BasicStrategy authenticate
formStrategy = new LocalStrategy authenticate

passport.serializeUser (user, done) ->
	done null, user._id

passport.deserializeUser (id, done) ->
	userManager = new UserManager dal
	await userManager.fetchUserById id, defer user
	if user?
		done(null, user)
	else
		done(new Error "User #{id} not found")

passport.use(formStrategy)
passport.use(apiStrategy)