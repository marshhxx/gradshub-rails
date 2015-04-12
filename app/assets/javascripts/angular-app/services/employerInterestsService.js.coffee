Interests = ($resource) ->
	$resource('/api/candidates/:employer_id/interests/:id',
		{employer_id: '@employer_id', id: '@id'},
		{
			query: {
				method: 'GET',
				isArray: false
			},
			update: {
				method: 'PUT'
			}
		})

angular
.module('mepedia.services')
.factory('EmployerInterests', Interests);