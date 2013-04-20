###
Created by Antonio Bello
All right reserved
###

BaseEntity = require('./base-entity').BaseEntity

class exports.TaskEntity extends BaseEntity
	constructor: (task) ->
		super(task)
		@userId = task.userId
		@description = task.description
		@priority = task.priority
		@completed = task.priority
		@archived = task.archived
		@createdOn = task.createdOn
		@completedOn = task.completedOn if task.completedOn?
