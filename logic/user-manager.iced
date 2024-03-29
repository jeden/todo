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

UserAdapter = require('../data-layer/adapter/user-adapter').UserAdapter
UserEntity = require('../data-layer/entity/user-entity').UserEntity

crypto = require 'crypto'

SALT_LEN = 9

class exports.UserManager
	@SUCCESS = 0
	@ERROR_REGISTRATION = -1

	constructor: (@dal) ->
		# Empty

	###
      Find a user by id
      ###
	fetchUserById: (id, onCompletion) ->
		await @dal.user_adapter.fetchById id, defer outcome
		ret = null
		if outcome.succeeded() and outcome.getAffectedRows() > 0
			user = outcome.getResults()
			ret = new UserEntity user
		onCompletion ret

	###
      Authenticate
	Return:
      - the user if authentication succeeds
      - null if authentication fails
      ###
	authenticateUser: (username, password, onCompletion) ->
		await @dal.user_adapter.fetchByUsername username, defer outcome
		ret = null
		if outcome.succeeded() and outcome.getAffectedRows() > 0
			user = outcome.getResults()
			if this.__validatePassword user, password
				ret = new UserEntity user
		onCompletion ret


	###
      Register a new user
      Return:
      - UserManger.SUCCESS if registration succeeds
      - One of UserEntity.VALIDATION_* in case of validation error
      - UserManger.ERROR_REGISTRATION in case of any other error
	###
	registerUser: (user, onCompletion) ->
		userEntity = new UserEntity(user)

		# Validate user fields
		val = userEntity.validate()
		if val != UserEntity.VALIDATION_OK
			onCompletion val
			return

		# Validate the password
		val = userEntity.validatePassword(user)
		if val != UserEntity.VALIDATION_OK
			onCompletion val
			return

		# Ensure the username is not in use
		await this.__usernameExists user.username, defer exists
		if exists
			onCompletion UserEntity.VALIDATION_USERNAME_EXISTS
			return

		# Generate salt and hash from the chosen password
		this.__hashPassword(userEntity, user.password)

		await @dal.user_adapter.insertUser userEntity, defer outcome

		if outcome.succeeded()
			onCompletion UserManager.SUCCESS
		else
			onCompletion UserManager.ERROR_REGISTRATION

	#
	# PRIVATE METHODS
	#

	###
	Generate salt and hash for the user's password
	###
	__hashPassword: (user, password) ->
		salt = this.__generateSalt(SALT_LEN)
		hash = this.__hash(password, salt)
		user.setPassword hash, salt

	###
	Generate a random salt for hashing the password
	###
	__generateSalt: (len) ->
		set = '0123456789abcdefghijklmnopqurstuvwxyzABCDEFGHIJKLMNOPQURSTUVWXYZ'
		setLen = set.length
		salt = ''

		for i in [1..len]
			index = Math.floor(Math.random() * setLen)
			salt += set[index]

		return salt

	###
      Hash a string using the MD5 function
	###
	__hash: (password, salt) ->
		return crypto.createHash('md5').update(password + salt).digest('hex')

	###
      Validate a password against its hash
      ###
	__validatePassword: (user, password) ->
		hash = this.__hash(password, user.salt)
		return hash == user.hash

	###
      Verify whether a username already exists
      ###
	__usernameExists: (username, onCompletion) ->
		@dal.user_adapter.fetchByUsername username, (outcome) ->
			onCompletion(outcome.failed() or outcome.getAffectedRows() > 0)