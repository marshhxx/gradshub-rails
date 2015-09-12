angular.module('mepedia.controllers').controller("forgotPasswordController", [
  '$scope', 'sessionService', '$state', '$stateParams', 'alertService',
  ($scope, sessionService, $state, $stateParams, alertService)->
    $scope.alerts = []

    $scope.sendEmailForgotPassword = () ->
      if $scope.emailFgtPssw
        sessionService.sendFgtPsswEmail($scope.emailFgtPssw).then(
          (response) ->
            $state.go 'home.checkemail'
        ).catch(alertService.defaultErrorCallback)

    $scope.closeAlert = () ->
      $scope.alerts.splice(0, 1);

    $scope.resetPassword = () ->
      if $scope.password is not $scope.password_confirmation
        console.log("Passwords don't match");
      user = {
        uid: $stateParams.r,
        password: $scope.password,
        password_confirmation: $scope.password_confirmation,
        reset_password_token: $stateParams.reset_token
      }
      sessionService.resetPassword(user).then(
        (payload) ->
          $state.go 'home.resetsccss'
      ).catch(alertService.defaultErrorCallback)
])