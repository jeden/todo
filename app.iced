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
	'tasks'
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
