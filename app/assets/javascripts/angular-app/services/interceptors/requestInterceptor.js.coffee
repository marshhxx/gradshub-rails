Interceptor = ($injector) ->
    return {
      request: (config) ->
        sessionService = $injector.get('sessionService')
        config.headers = config.headers || {};
        if (sessionService.isAuthenticated())
          config.headers.Authorization = 'Bearer ' + sessionService.authenticationToken()
        config
    }

angular.module('gradshub-ng.services')
  .factory('authInterceptor', Interceptor)