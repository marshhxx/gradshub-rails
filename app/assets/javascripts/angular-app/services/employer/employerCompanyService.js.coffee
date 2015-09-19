Company = ($resource) ->
	$resource('/api/employers/:employer_id/company',
		{employer_id: '@employer_id'},
        {
            update: {
                method: 'PUT'
            }
        })
angular
	.module('gradshub-ng.services')
	.factory('EmployerCompany', Company);
