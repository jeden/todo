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

ServiceResponse = require('../service-response').ServiceResponse
BaseAdapter = require('./base-adapter').BaseAdapter
UserEntity = require('../entity/user-entity').UserEntity

class exports.UserAdapter extends BaseAdapter
	constructor: (@db) ->
		super 'users'

	###
      Insert a new user
	###
	insertUser: (user, onCompletion) ->
		if not user instanceof UserEntity
			throw "Not an instance of User: #{user}"

		userToSave = user.toDictionary()
		@db.users.save userToSave, (err, saved) ->
			outcome = new ServiceResponse(err, saved)
			onCompletion(outcome)

	###
	Find a user by username
      ###
	fetchByUsername: (username, onCompletion) ->
		@db.users.findOne username: username, (err, user) ->
			outcome = new ServiceResponse(err, user)
			onCompletion(outcome)