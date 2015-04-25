ModalService = ($modal) ->
	service = {}

	service.confirm = (msg) ->
		$modal.open({
			size: 'sm',
			controller: 'ModalController',
			templateUrl: 'angular-app/templates/modals/confirm.html',
			resolve: {
				message: () -> msg
			}
		}).result

	service

angular
	.module('mepedia.services')
	.factory('modalService', ModalService)