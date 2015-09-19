ErrorInterceptor = ($q, alertService, $injector) ->

  logoutAndSendToLogin = (response) ->
    alertService.addError(response.data.error, 10000)
    $injector.get('Session').destroy()
    $injector.get('$state').go 'home.login', null, {reload: true}

  responseInterceptor =
  {
    requestError: (response) ->
      alertService.addError(response.data.error)
      $q.reject(response)

    responseError: (response) ->
      switch response.status
        when 403
          if response.data.error.code == 'ERR06'
            logoutAndSendToLogin(response)
            $q.reject(response)
        when 401
          if response.data.error.code == 'ERR07'
            logoutAndSendToLogin(response)
            $q.reject(response)
        else
          $q.reject(response)

  }

angular
	.module('gradshub-ng.services')
	.factory('errorInterceptor', ErrorInterceptor)