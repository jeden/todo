###
Created by Antonio Bello
All right reserved
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
