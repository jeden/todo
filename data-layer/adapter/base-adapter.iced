###
Created by Antonio Bello
All right reserved
###

ServiceResponse = require('../service-response').ServiceResponse
mongojs = require('mongojs')

class exports.BaseAdapter
	constructor: (@collectionName) ->
		# Empty

	fetchById: (id, onCompletion) ->
		@db[@collectionName].findOne _id: mongojs.ObjectId(id), (err, entity) ->
			outcome = new ServiceResponse(err, entity)
			onCompletion(outcome)
