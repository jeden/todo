###
Created by Antonio Bello
antonio@ubersimple.com
(c) 2013 ubersimple llc
All right reserved
###

exports.list = (req, res) ->
	params =
		title: 'To Do List'
		user: req.user

	res.render 'todos', params
