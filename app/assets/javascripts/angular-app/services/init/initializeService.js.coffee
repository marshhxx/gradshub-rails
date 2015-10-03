InitializeApp = (sessionService, $interval)->

  initialize = ->
    initializeTimer()
    refreshSession()
      
  initializeTimer = ->
    $interval( ->
      refreshSession()
    , 3600000)

  refreshSession = ->
    if sessionService.isAuthenticated()
      sessionService.refreshSession()


  return {
    initialize: initialize
  }

angular.module('gradshub-ng.services')
  .factory('initializeApp', InitializeApp)