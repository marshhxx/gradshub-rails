ErrorInterceptor = ($q, alertService, $injector) ->

  alertLogoutAndSendToState = (response, stateName) ->
    alertService.addError(response.data.error, 10000)
    logoutAndSendToState(stateName)

  logoutAndSendToState = (stateName) ->
    $injector.get('sessionService').logout()
    $injector.get('$state').go stateName, null, {reload: true}

  responseInterceptor =
  {
    requestError: (response) ->
      alertService.addError(response.data.error)
      $q.reject(response)

    responseError: (response) ->
      switch response.status
        when 403
          if response.data.error.code == 'ERR06'
            logoutAndSendToState('home.page')
        when 401
          if response.data.error.code in ['ERR07', 'ERR01']
            alertLogoutAndSendToState(response, 'home.login')
      $q.reject(response)

  }

angular
.module('gradshub-ng.services')
.factory('errorInterceptor', ErrorInterceptor)