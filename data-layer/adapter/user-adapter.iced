###
Created by Antonio Bello
All right reserved
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