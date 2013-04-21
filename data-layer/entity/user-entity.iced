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