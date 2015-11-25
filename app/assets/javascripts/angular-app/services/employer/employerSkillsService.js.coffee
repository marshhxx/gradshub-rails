Skill = ($resource) ->
	$resource('/api/employers/:employer_id/skills/:id',
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
	.module('gradshub-ng.services')
	.factory('EmployerSkills', Skill);