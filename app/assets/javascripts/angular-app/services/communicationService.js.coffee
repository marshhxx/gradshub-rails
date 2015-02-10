angular.module('mepedia.services').factory  "communicationPlatform",
	['$http', '$q','ENV',
	($http, $q, ENV) ->
		service = {
			loginUser: (user, password) ->
				deferred = $q.defer()
				success = (data, status, headers) ->
					data = JSON.parse data.response
					if data.success != "0"
						error(data)
						return
					console.log 'Logged in to Onepg'
					console.log data
					deferred.resolve(user_id: data.user_id)
				error = (response) ->
					console.log 'Error while logging in to Onepg'
					deferred.reject(response)
				sendRequest(
					"http://onepgr.com/sessions/create3",
					{
						login: if ENV.env == 'prod' then user.email else 'martinbomio@gmail.com',
						password: if ENV.env == 'prod' then password  else '997680',
						clientname: 11,
						clientappid: 22,
						clientappkey: 33,
						xhr_flag: 1
					}, success)
				deferred.promise

			register: (user) ->
				deferred = $q.defer()
				success = (data, status, headers) ->
					data = JSON.parse data.response
					if data.success != "0"
						error(data)
						return
					console.log 'Registered to Onepg'
					console.log data
					deferred.resolve(password: data.user_password, user_id: data.user_id)
				error = (response) ->
					console.log 'Error while registering to Onepg'
					deferred.reject(response)
				sendRequest(
					"http://onepgr.com/users/create_api"
					{
						name:  if ENV.env == 'prod' then [user.name, user.lastname].join(' ') else 'Martin Bomio',
						email: if ENV.env == 'prod' then user.email else 'martinbomio@hotmail.com',
						onepgr_apicall: 1,
						clientappid: 101,
						clientappkey: 123456,
						xhr_flag: 1
					},success)
				deferred.promise

			createPage: () ->

		}
		sendRequest = (url, data, success, error) ->
			$http(
				method: "POST"
				url: url
				headers:
					"Content-Type": "application/x-www-form-urlencoded"

				transformRequest: (obj) ->
					str = []
					for p of obj
						str.push encodeURIComponent(p) + "=" + encodeURIComponent(obj[p])
					str.join "&"

				data: data
			).success(success)

		service
	]