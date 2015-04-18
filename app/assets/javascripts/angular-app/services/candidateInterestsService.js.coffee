Interests = ($resource) ->
	$resource('/api/candidates/:candidate_id/interests/:id',
		{candidate_id: '@candidate_id', id: '@id'},
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
	.factory('CandidateInterests', Interests);