angular
	.module('mepedia.controllers')
	.controller('mainController',
	['$scope', '$rootScope', 'sessionService', '$state', 'alertService'
	 ($scope, $rootScope, sessionService, $state, alertService) ->

		 $scope.logged = sessionService.isAuthenticated();
		 $scope.logout = () ->
			 sessionService.logout().then(
				 -> $state.go 'home.page'
			 ).catch(
				 (error)-> console.log(error)
			 );
	])