###
Created by Antonio Bello
All right reserved
###

# Modules
express = require 'express'
path = require 'path'

# Paassport
passport = require 'passport'
BasicStrategy = require('passport-http').BasicStrategy
LocalStrategy = require('passport-local').Strategy;

# Routing
routes = require './routes'
login = require './routes/login'
todo = require './routes/todo'

# Server
http = require('http')

# Create the express app
app = express()

# Environment
app.set('port', process.env.PORT || 3000)
app.set('views', __dirname + '/views')
app.set('view engine', 'jade')
app.use(express.favicon())
app.use(express.logger('dev'))
app.use(express.bodyParser())
app.use(express.methodOverride())
app.use(express.cookieParser('ABEF45484EF002A'))
app.use(express.session())
app.use(express.static(path.join(__dirname, 'public')))
app.use(passport.initialize())
app.use(passport.session()) # After express.session()
app.use(app.router)

# Development only
if 'development' == app.get('env')
	app.use(express.errorHandler())

# Passport configuration

users = [
	{ id: 0, username: 'user', password: 'pwd', name: { first: 'User', last: 'First' } }
	{ id: 1, username: 'jeden', password: 'pwd', name: {first: 'Antonio', last: 'Bello' } }
]

authenticate = (username, password, done) ->
	foundUser = null
	for user in users
		if user.username == username and user.password == password
			foundUser = user
			break

	if foundUser?
		return done(null, foundUser)
	else
		return done(null, false, { message: 'Invalid username or password'} )

apiStrategy = new BasicStrategy authenticate
formStrategy = new LocalStrategy authenticate

passport.serializeUser (user, done) ->
	done null, user.id

passport.deserializeUser (id, done) ->
	if id < users.length
		done(null, users[id])
	else
		done(new Error "User #{id} not found")

passport.use(formStrategy)

# Define routes
app.get '/', routes.index

app.post '/login', passport.authenticate 'local',
	successRedirect: '/todos'
	failureRedirect: '/login'

app.get '/login', login.login
app.get '/logout', login.logout
app.get '/todos', login.isAuthenticated, todo.list

# Create and start the server
server = http.createServer(app)
server.listen app.get('port'), () ->
	console.log ('Express server listening on port ' + app.get('port'))
