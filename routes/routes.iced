###
Created by Antonio Bello
All right reserved
###

index = require './index'
auth = require './auth'
todo = require './todo'

exports.register = (app, passport) ->
	# Define routes
	app.get '/', index.index
	app.get '/todos', auth.isAuthenticated, todo.show

	app.post '/login', passport.authenticate 'local',
			successRedirect: '/todos'
			failureRedirect: '/login'

	app.get '/login', auth.login
	app.get '/logout', auth.logout

	app.get '/register', auth.register
	app.post '/doRegister', auth.doRegister

	# Rest APIs
	app.get '/api/tasks', todo.list
	app.put '/api/tasks/', todo.add
	app.post '/api/tasks/:id', todo.update
	app.delete '/api/tasks/:id', todo.delete