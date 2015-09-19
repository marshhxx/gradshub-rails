Errors = ($rootScope, alertService, ALERT_CONSTANTS, $state, $stateParams, stateWrapper) ->

  getType = () ->
    if $state.current.name.indexOf('candidate') >= 0 then 'Candidate' else 'Employer'

  return {
    notLoggedIn: (error) ->
      alertService.addErrorMessage('You are currently not logged in.', ALERT_CONSTANTS.ERROR_TIMEOUT)
      $state.go('home.login')

    userNotFound: (error) ->
      type = getType()
      alertService.addErrorMessage("#{type} not found. Please check you selected the right id.", ALERT_CONSTANTS.ERROR_TIMEOUT)
      $state.go(stateWrapper.previousState)
  }

angular
  .module('gradshub-ng.services')
  .factory('errors', Errors)