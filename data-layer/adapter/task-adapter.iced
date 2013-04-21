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