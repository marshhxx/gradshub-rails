ModalService = ($uibModal) ->
	service = {}

	service.confirm = (msg, confirmMsg='OK', rejectMsg='Cancel', size='sm') ->
		$uibModal.open({
			size: size,
			controller: 'ModalController',
			templateUrl: 'angular-app/templates/modals/confirm.html',
			resolve: {
				message:
          -> msg
        confirm:
          -> confirmMsg
        reject:
          -> rejectMsg
			}
		}).result

	service

angular
	.module('gradshub-ng.services')
	.factory('modalService', ModalService)