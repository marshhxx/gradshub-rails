angular.module('mepedia.services').factory  "registerService",
	['sessionService', '$q',
		(sessionService, $q) ->
			this.tempUser = null
			service = {
				register: (user) ->
					deferred = $q.defer()
					this.tempUser = angular.copy(user)
					user.$save()

				currentUser: () ->
					this.tempUser
			}


			service
	]