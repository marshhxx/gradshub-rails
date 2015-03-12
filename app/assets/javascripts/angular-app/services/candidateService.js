angular
    .module('mepedia.services')
    .factory('Candidate', function($resource) {
        var Candidate = $resource('/api/candidates/:id', { id: '@uid' },
        {
            update: {
                method: 'PUT'
            }
        });

        Candidate.prototype.isEMployer = false;
        return Candidate;
});