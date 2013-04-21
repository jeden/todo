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

class exports.TaskEntity extends BaseEntity
	@VALIDATION_OK = 0
	@VALIDATION_USERID_MISSING = 1
	@VALIDATION_DESCRIPTION_MISSING = 2

	@PRIORITY_LOW = 1
	@PRIORITY_NORMAL = 2
	@PRIORITY_HIGH = 3
	@PRIORITY_CRITICAL = 4

	constructor: (task) ->
		super(task)
		@userId = task.userId
		@description = task.description
		@priority = if task.priority? then task.priority else @PRIORITY_NORMAL
		@completed = if task.completed? then task.completed else 0
		@archived = task.archived if task.archived?
		@createdOn = if task.createdOn? then task.createdOn else new Date()
		@completedOn = task.completedOn if task.completedOn?

	###
      Validate the task fields
	###
	validate: () ->
		err = TaskEntity.VALIDATION_OK
		if not @userId?
			err = TaskEntity.VALIDATION_USERID_MISSING
		else if not @description?
			err = TaskEntity.VALIDATION_DESCRIPTION_MISSING
		return err
