###
Created by Antonio Bello
All right reserved
###

BaseEntity = require('./base-entity').BaseEntity

class exports.UserEntity extends BaseEntity
	@VALIDATION_OK = 0
	@VALIDATION_USERNAME_TOO_SHORT = 1
	@VALIDATION_USERNAME_MISSING = 2
	@VALIDATION_USERNAME_INVALID_CHARS = 3
	@VALIDATION_USERNAME_EXISTS = 4
	@VALIDATION_PASSWORD_TOO_SHORT = 10
	@VALIDATION_PASSWORDS_DONT_MATCH = 11

	@USERNAME_MIN_LEN = 4
	@PASSWORD_MIN_LEN = 6

	@__REGEX_USERNAME = /^[a-zA-Z\-_\.]+$/;

	constructor: (user) ->
		super(user)
		@hash = user.hash if user.hash?
		@salt = user.salt if user.salt?
		@username = user.username
		@name =
			first:  if user.name.first? then user.name.first else ''
			last: if user.name.last? then user.name.last else ''

	setPassword: (hash, salt) ->
		@hash = hash
		@salt = salt

	###
      Validate the user fields
	###
	validate: () ->
		err = UserEntity.VALIDATION_OK
		if @username.length < UserEntity.USERNAME_MIN_LEN
			err = UserEntity.VALIDATION_USERNAME_TOO_SHORT
		else if not @username?
			err = UserEntity.VALIDATION_USERNAME_MISSING
		else if @username.match(UserEntity.__REGEX_USERNAME) == null
			err = UserEntity.VALIDATION_USERNAME_INVALID_CHARS
		return err

	###
      Validate the password
	###
	validatePassword: (user) ->
		err = UserEntity.VALIDATION_OK
		if not user.password? or user.password.length < UserEntity.PASSWORD_MIN_LEN
			err = UserEntity.VALIDATION_PASSWORD_TOO_SHORT
		else if not user.confirmPassword? or user.confirmPassword != user.password
			err = UserEntity.VALIDATION_PASSWORDS_DONT_MATCH
		return err