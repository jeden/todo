###
Created by Antonio Bello
All right reserved
###

ServiceResponse = require('../service-response').ServiceResponse
BaseAdapter = require('./base-adapter').BaseAdapter

class exports.TaskAdapter extends BaseAdapter
	constructor: (@db) ->
		super 'tasks'
