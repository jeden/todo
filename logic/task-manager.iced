###
Created by Antonio Bello
All right reserved
###

class exports.TaskManager
	constructor: (@dal, @userId) ->
		# Empty

	getAllTasks: (onCompletion) ->
		await @dal.task_adapter.findByUser @userId, defer outcome
		tasks = []
		if outcome.succeeded()
			tasks = outcome.getResults()
		onCompletion tasks