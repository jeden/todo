###
Created by Antonio Bello
All right reserved
###

class exports.BaseEntity
	constructor: (entity) ->
		@_id = entity._id

	###
	Return a dictionary made up of all non null class properties
	###
	toDictionary: () ->
		dict = {}
		for key in Object.keys(this)
			if this[key]?
				dict[key] = this[key]
		return dict
