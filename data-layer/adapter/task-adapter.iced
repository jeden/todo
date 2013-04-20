###
Created by Antonio Bello
All right reserved
###

ServiceResponse = require('../service-response').ServiceResponse
BaseAdapter = require('./base-adapter').BaseAdapter
TaskEntity = require('../entity/task-entity').TaskEntity

class exports.TaskAdapter extends BaseAdapter
	constructor: (@db) ->
		super 'tasks'

	###
	Create a new task
      ###
	insertTask: (task, onCompletion) ->
		if not task instanceof TaskEntity
			throw "Not an instance of TaskEntity: #{task}"

		taskToSave = task.toDictionary()
		@db.tasks.save taskToSave, (err, saved) ->
			outcome = new ServiceResponse(err, saved)
			onCompletion(outcome)


	###
      Retrieve all tasks by user
	###
	findByUser: (userId, onCompletion) ->
		@db.tasks.find(userId: userId, (err, tasks) ->
			outcome = new ServiceResponse(err, tasks)
			onCompletion(outcome)
		).sort(
			priority: -1
			createdOn: -1
		)