Language = ($resource) ->
	$resource('/api/languages/:id',
		{id: '@id'},
		{
			query: {
				method: 'GET',
				isArray: false,
				cache: true
			}
		}
	)
angular
	.module('gradshub-ng.services')
	.factory('Language', Language)