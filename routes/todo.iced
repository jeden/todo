###
Created by Antonio Bello
antonio@ubersimple.com
(c) 2013 ubersimple llc
All right reserved
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