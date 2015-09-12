angular.module('mepedia.controllers').controller("forgotPasswordController", [
  '$scope', 'sessionService', '$state', '$stateParams', 'alertService',
  ($scope, sessionService, $state, $stateParams, alertService)->
    $scope.alerts = []

    $scope.sendEmailForgotPassword = (valid) ->
      if not valid
        return
      if $scope.emailFgtPssw
        sessionService.sendFgtPsswEmail($scope.emailFgtPssw).then(
          (response) ->
            $state.go 'home.checkemail'
        ).catch(alertService.defaultErrorCallback)

    $scope.closeAlert = () ->
      $scope.alerts.splice(0, 1);

    $scope.resetPassword = (valid) ->
      if not valid
        return
      user = {
        uid: $stateParams.r,
        password: $scope.password,
        password_confirmation: $scope.passwordConfirmation,
        reset_password_token: $stateParams.reset_token
      }
      sessionService.resetPassword(user).then(
        (payload) ->
          $state.go 'home.resetsccss'
      ).catch(alertService.defaultErrorCallback)
])