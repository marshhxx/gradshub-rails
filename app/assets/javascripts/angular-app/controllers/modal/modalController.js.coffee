ModalController = ($scope, $uibModalInstance, message, confirm, reject) ->
  $scope.message = message
  $scope.confirm = confirm
  $scope.reject = reject

  $scope.ok = () ->
    $uibModalInstance.close()

  $scope.cancel = () ->
    $uibModalInstance.dismiss('cancel')

ModalController.$inject = ['$scope', '$modalInstance', 'message', 'confirm', 'reject']

angular
  .module('gradshub-ng.controllers')
  .controller('ModalController', ModalController)