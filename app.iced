###
Created by Antonio Bello
All right reserved
###

# Modules
express = require 'express'
path = require 'path'
mongojs = require 'mongojs'

# Auth config
auth_config = require './logic/auth-config'

# Routing
routes = require './routes/routes'

# Server
http = require('http')

# Connect to the Mongo DB
# Note: conf.js is not under source control - must be manually created
# It contains sensitive data, such as database url, username and password
dbUrl = require('./conf').MONGO_DB_URL
console.log("Connecting to MongoDB: #{dbUrl}")
dbCollections = [
	'users'
	'todos'
]
db = mongojs.connect dbUrl, dbCollections

# Use DI to separate logic from DB
UserAdapter = require('./data-layer/adapter/user-adapter').UserAdapter
TaskAdapter = require('./data-layer/adapter/task-adapter').TaskAdapter
dal =
	user_adapter: new UserAdapter(db)
	task_adapter: new TaskAdapter(db)

###
###

# Create the express app
app = express()
app.dal = dal

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
passport = auth_config.init(app)
app.use(app.router)

# Development only
if 'development' == app.get('env')
	app.use(express.errorHandler())

# Register the routes
routes.register app, passport

# Create and start the server
server = http.createServer(app)
server.listen app.get('port'), () ->
	console.log ('Express server listening on port ' + app.get('port'))
