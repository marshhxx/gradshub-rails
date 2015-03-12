angular
    .module('mepedia.services')
    .factory('Employer', function($resource) {
        var Employer = $resource('/api/employers/:id', { id: '@uid' },
        {
            update: {
                method: 'PUT'
            }
        });

        Employer.prototype.isEmployer = true;
        return Employer;
});