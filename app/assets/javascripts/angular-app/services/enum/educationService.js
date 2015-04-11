var Education = function($resource) {
    return $resource('/api/candidates/:candidate_id/educations/:id',
        {candidate_id: '@candidate_id', id: '@id'},
        {
            query: {
                method: 'GET',
                isArray: false
            },
            update: {
                method: 'PUT'
            }
        }
    )
};
angular
    .module('mepedia.services')
    .factory('Education', Education);