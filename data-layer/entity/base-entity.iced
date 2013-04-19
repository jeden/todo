###
Created by Antonio Bello
All right reserved
###

class exports.BaseEntity
	@FIELD_ID = '_id'

	_getId: (entity) ->
		if entity.id?
			@id = entity.id
		else if entity[BaseEntity.FIELD_ID]?
			@id = entity[BaseEntity.FIELD_ID]
	###
	Return a dictionary made up of all non null class properties
	###
	toDictionary: () ->
		dict = {}
		for key in Object.keys(this)
			if this[key]?
				dict[key] = this[key]
		return dict
