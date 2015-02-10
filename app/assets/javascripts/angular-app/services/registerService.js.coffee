angular.module('mepedia.services').factory  "registerService",
	['communicationPlatform','sessionService','$state', '$q',
		(communicationPlatform, sessionService, $state, $q) ->
			this.tempUser = null
			service = {
				registerToMepedia: (user) ->
					return user.$save()

				register: (user) ->
					deferred = $q.defer()
					this.tempUser = angular.copy(user)
					promise = communicationPlatform.register(user)
					promise.then(
						(payload) ->
							user.onepgr_id = payload.user_id
							user.onepgr_password = payload.password
							registerToMepedia(user).then(
								() ->
									deferred.resolve()
								,
								(error) ->
									deferred.reject(error)
							)
							return deferred.promise
					,
						(error) ->
							deferred.reject(code: 0, error: error)
							return deferred.promise
					)


				currentUser: () ->
					this.tempUser
			}


			service
	]