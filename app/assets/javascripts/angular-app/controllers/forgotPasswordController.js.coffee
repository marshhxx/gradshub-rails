angular.module('mepedia.controllers').controller("forgotPasswordController", [
	'$scope','sessionService', '$state', '$stateParams',
	($scope, sessionService, $state, $stateParams)->
		$scope.alerts = []

		$scope.sendEmailForgotPassword = () ->
			if $scope.emailFgtPssw
				promise = sessionService.sendFgtPsswEmail $scope.emailFgtPssw
				promise.then(
					(payload) ->
						console.log(payload)
						$state.go 'main.checkemail'
				,
				  (errorPayload) ->
				  	console.log(errorPayload);
				  	$scope.alerts = [{msg: errorPayload.errors.reasons.join()}] if errorPayload
			    )

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
			promise = sessionService.resetPassword user
			promise.then(
				(payload) ->
					console.log(payload)
					$state.go 'main.resetsccss'
			,
				(errorPayload) ->
					console.log(errorPayload);
					$scope.alerts = [{msg: errorPayload.errors.reasons.join()}] if errorPayload
			)
])