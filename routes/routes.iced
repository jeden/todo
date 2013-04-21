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
