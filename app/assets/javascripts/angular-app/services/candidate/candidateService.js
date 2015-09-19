angular
    .module('mepedia.services')
    .factory('Candidate', function($resource) {
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
});