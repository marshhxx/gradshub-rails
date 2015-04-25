CandidateLanguages = ($resource) ->
	$resource('/api/candidates/:candidate_id/languages/:id',
		{candidate_id: '@candidate_id', id: '@id'},
		{
			query: {
				method: 'GET',
				isArray: false,
			},
			update: {
				method: 'PUT'
			}
		}
	)

angular
	.module('mepedia.services')
	.factory('CandidateLanguages', CandidateLanguages)