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

	###
	Web App REST APIs
	Using form authentication
	###
	app.get '/backoffice/api/tasks', auth.isAuthenticated, todo.list
	app.put '/backoffice/api/tasks', auth.isAuthenticated, todo.add
	app.post '/backoffice/api/tasks/:taskId', auth.isAuthenticated, todo.update
	app.delete '/backoffice/api/tasks/:taskId', auth.isAuthenticated, todo.delete

	###
	Public Rest APIs
	Using basic HTTP authentication
	###
	app.get '/api/tasks', passport.authenticate('basic'), todo.list
	app.put '/api/tasks', passport.authenticate('basic'), todo.add
	app.post '/api/tasks/:taskId', passport.authenticate('basic'), todo.update
	app.delete '/api/tasks/:taskId', passport.authenticate('basic'), todo.delete
