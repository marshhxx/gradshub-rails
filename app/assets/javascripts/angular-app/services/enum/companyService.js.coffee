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
	.module('gradshub-ng.services')
	.factory('Company', Company);