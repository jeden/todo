###
Created by Antonio Bello
All right reserved
###

ServiceResponse = require('../service-response').ServiceResponse
BaseAdapter = require('./base-adapter').BaseAdapter
TaskEntity = require('../entity/task-entity').TaskEntity
mongojs = require('mongojs')

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
			priority: 1
			createdOn: -1
		)

	###
      Delete a task
	###
	deleteTask: (taskId, userId, onCompletion) ->
		criteria =
			_id: mongojs.ObjectId(taskId)
			userId: userId
		@db.tasks.remove criteria, (err, deleted) ->
			outcome = new ServiceResponse(err, deleted)
			onCompletion(outcome)

	###
      Update a task
	###
	updateTask: (task, userId, onCompletion) ->
		criteria =
			_id: mongojs.ObjectId(task._id)
			userId: userId

		delete task._id
		delete task.userId
		delete task.createdOn

		set = $set: task
		@db.tasks.update criteria, set, (err, updated) ->
			outcome = new ServiceResponse(err, updated)
			onCompletion(outcome)