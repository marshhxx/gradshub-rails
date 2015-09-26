InitializeApp = (sessionService)->

  initialize = ->
    if sessionService.isAuthenticated()
      sessionService.refreshSession()

  return {
    initialize: initialize
  }

angular.module('gradshub-ng.services')
  .factory('initializeApp', InitializeApp)