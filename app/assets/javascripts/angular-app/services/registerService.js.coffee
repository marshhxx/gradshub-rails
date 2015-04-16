RegisterService = () ->
	this.tempUser = null
	service = {}

	service.register = (user) ->
		this.tempUser = angular.copy(user)
		user.$save()

	service.currentUser = ->
		this.tempUser

	service

angular
	.module('mepedia.services')
	.factory("registerService", RegisterService)