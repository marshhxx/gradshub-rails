CandidateService = function($resource) {
        var Candidate = $resource('/api/candidates/:id', { id: '@uid' },
        {
            update: {
                method: 'PUT',
                isArray: false
            },
            changePassword: {
                method: 'PUT',
                url: '/api/candidates/:id/password'
            }
        });

        Candidate.className = 'Candidate';

        Candidate.prototype.isEmployer = false;
        return Candidate;
};
angular
    .module('gradshub-ng.services')
    .factory('Candidate', CandidateService);