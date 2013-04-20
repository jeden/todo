###
Created by Antonio Bello
All right reserved
###

TaskEntity = require('../data-layer/entity/task-entity').TaskEntity

class exports.TaskManager
	@SUCCESS = 0
	@ERROR_ADD_TASK = -1

	constructor: (@dal, @userId) ->
		# Empty

	getAllTasks: (onCompletion) ->
		await @dal.task_adapter.findByUser @userId, defer outcome
		tasks = []
		if outcome.succeeded()
			tasks = outcome.getResults()
		onCompletion tasks

	createTask: (task, onCompletion) ->
		task.userId = @userId
		taskEntity = new TaskEntity(task)

		# Validate the task
		val = taskEntity.validate()
		if val != TaskEntity.VALIDATION_OK
			onCompletion val
			return

		await @dal.task_adapter.insertTask taskEntity, defer outcome

		if outcome.succeeded()
			onCompletion TaskManager.SUCCESS
		else
			onCompletion TaskManager.ERROR_ADD_TASK

	updateTask: (task, onCompletion) ->
		await @dal.task_adapter.updateTask task, @userId, defer outcome
		onCompletion TaskManager.SUCCESS

	deleteTask: (taskId, onCompletion) ->
		await @dal.task_adapter.deleteTask taskId, @userId, defer outcome
		onCompletion TaskManager.SUCCESS