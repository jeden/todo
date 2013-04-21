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