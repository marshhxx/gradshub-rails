angular
	.module('mepedia.controllers')
	.controller('mainController',
	['$scope', 'sessionService', '$state',
	 ($scope, sessionService, $state) ->

		 $scope.logged = sessionService.isAuthenticated();
		 $scope.logout = () ->
			 sessionService.logout().then(
				 -> $state.go 'home.page'
			 ).catch(
				 (error)-> console.log(error)
			 );
])