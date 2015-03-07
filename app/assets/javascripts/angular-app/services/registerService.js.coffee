angular.module('mepedia.services').factory  "registerService",
	[
		() ->
			this.tempUser = null
			service = {
				register: (user) ->
					this.tempUser = angular.copy(user)
					user.$save()

				currentUser: () ->
					this.tempUser
			}


			service
	]