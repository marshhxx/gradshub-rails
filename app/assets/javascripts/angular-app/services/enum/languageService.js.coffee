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
	.module('mepedia.services')
	.factory('Language', Language)