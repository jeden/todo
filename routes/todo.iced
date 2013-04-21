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

TaskManager = require('../logic/task-manager').TaskManager
log = require 'winston'

exports.show = (req, res) ->
	params =
		title: 'To Do List'
		user: req.user

	res.render 'todos', params

exports.list = (req, res) ->
	userId = req.user._id
	dal = req.app.dal

	taskManager = new TaskManager(dal, userId)
	await taskManager.getAllTasks defer tasks
	res.json tasks, 200

exports.add = (req, res) ->
	userId = req.user._id
	dal = req.app.dal
	form = req.body

	task = form.task
	if not task?
		res.json {}, 412
		return

	taskManager = new TaskManager(dal, userId)
	await taskManager.createTask task, defer outcome

	if outcome != TaskManager.SUCCESS
		log.warn "Error creating new task: #{outcome}"
		res.json {}, 412
		return

	log.log "Task created successfully"
	res.json {}, 200

exports.update = (req, res) ->
	dal = req.app.dal
	userId = req.user._id
	task = req.body.task

	if not task?
		res.json {}, 412
		return

	if not req.params.taskId?
		res.json {}, 412
		return

	task._id = req.params.taskId

	taskManager = new TaskManager(dal, userId)
	await taskManager.updateTask task, defer outcome

	if outcome != TaskManager.SUCCESS
		log.warn "Error updating task #{task._id}: #{outcome}"
		res.json {}, 412
		return

	log.log "Task #{task._id} successfully updated"
	res.json {}, 200

exports.delete = (req, res) ->
	userId = req.user._id
	taskId = req.params.taskId
	dal = req.app.dal

	taskManager = new TaskManager(dal, userId)
	await taskManager.deleteTask taskId, defer outcome

	if outcome != TaskManager.SUCCESS
		log.warn "Error deleting task #{taskId}"
		res.json {}, 412
		return

	log.log "Task #{taskId} successfully deleted"
	res.json {}, 200