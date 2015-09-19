ErrorInterceptor = ($q, alertService, $location) ->
	responseInterceptor =
	{
		requestError: (response) ->
			alertService.addError(response.data.error)
			$q.reject(response)

		responseError: (response) ->
			alertService.addError(response.data.error, 10000)
			switch response.status
				when 401
					$location.path '/home/page'
				else
					$q.reject(response)

  }

angular
	.module('gradshub-ng.services')
	.factory('errorInterceptor', ErrorInterceptor)