var Experience = function($resource){
    return $resource('/api/candidates/:candidate_id/experiences/:id',
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
    .module('gradshub-ng.services')
    .factory('Experience', Experience);
