###
Created by Antonio Bello
antonio@ubersimple.com
(c) 2013 ubersimple llc
All right reserved
###

TaskManager = require('../logic/task-manager').TaskManager

exports.show= (req, res) ->
	params =
		title: 'To Do List'
		user: req.user

	res.render 'todos', params

exports.list = (req, res) ->
	userId = null
	taskManager = new TaskManager(req.app.dal, userId)
	await taskManager.getAllTasks defer tasks
	res.send tasks

exports.add = (req, res) ->

exports.update = (req, res) ->

exports.delete = (req, res) ->
