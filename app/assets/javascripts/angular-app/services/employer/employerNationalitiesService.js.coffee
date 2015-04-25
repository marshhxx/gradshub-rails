Nationalities = ($resource) ->
	$resource('/api/employers/:employer_id/nationalities/:id',
		{employer_id: '@employer_id', id: '@id'},
		{
			query: {
				method: 'GET',
				isArray: false
			}
		}
	)
angular
.module('mepedia.services')
.factory('EmployerNationalities', Nationalities);