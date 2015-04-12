Company = ($resource) ->
	$resource('/api/employers/:employer_id/company',
		{employer_id: '@employer_id'},
        {
            update: {
                method: 'PUT'
            }
        })
angular
	.module('mepedia.services')
	.factory('EmployerCompany', Company);
