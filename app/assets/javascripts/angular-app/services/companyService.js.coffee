Company = ($resource) ->
	$resource('/api/companies/:id',
		{id: '@id'},
		{
			query: {
				method: 'GET',
				isArray: false
			}
		}
	)
angular
	.module('mepedia.services')
	.factory('Company', Company);