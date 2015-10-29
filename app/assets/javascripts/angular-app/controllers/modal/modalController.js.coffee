ModalController = ($scope, $modalInstance, message) ->
	$scope.message = message

	$scope.ok = () ->
		$modalInstance.close();

	$scope.cancel = () ->
		$modalInstance.dismiss('cancel');

ModalController.$inject = ['$scope', '$modalInstance', 'message']

angular
	.module('gradshub-ng.controllers')
	.controller('ModalController', ModalController)