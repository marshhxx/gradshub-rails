angular.module('gradshub-ng.controllers').controller("forgotPasswordController", [
  '$scope', 'sessionService', '$state', '$stateParams', 'alertService',
  ($scope, sessionService, $state, $stateParams, alertService)->
    $scope.alerts = []
    $scope.spinnerVisible = false

    $scope.sendEmailForgotPassword = (valid) ->
      if not valid
        return
      if $scope.emailFgtPssw
        $scope.spinnerVisible = true
        sessionService.sendFgtPsswEmail($scope.emailFgtPssw).then(
          (response) ->
            $scope.spinnerVisible = false
            $state.go 'home.forgotpssw.checkemail'
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
          $state.go 'home.forgotpssw.resetsccss'
      ).catch(alertService.defaultErrorCallback)
])