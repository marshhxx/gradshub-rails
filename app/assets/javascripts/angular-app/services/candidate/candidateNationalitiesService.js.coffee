Nationalities = ($resource) ->
	$resource('/api/candidates/:candidate_id/nationalities/:id',
		{candidate_id: '@candidate_id', id: '@id'},
		{
			query: {
				method: 'GET',
				isArray: false
			}
		}
	)
angular
	.module('gradshub-ng.services')
	.factory('CandidateNationalities', Nationalities);