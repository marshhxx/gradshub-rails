Company = ($resource) ->
	$resource('/api/employers/:employer_id/company',
		{candidate_id: '@employer_id'},{}
	)
angular
	.module('mepedia.services')
	.factory('EmployerCompany', Company);
